//
//  ReportCleanerWorker.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-11.
//

import Foundation
import BackgroundTasks

class ReportCleanerService {
    private let reportEntryRepository: ReportEntryRepositoryProtocol
    private let backgroundTaskIdentifier = "com.Furlogix.reportcleaner"
    private let userDefaults = UserDefaults.standard
    private let lastCleanupKey = "lastReportCleanupDate"
    private let minIntervalBetweenCleanups: TimeInterval = 14 * 24 * 60 * 60 // 14 days
    
    init(reportEntryRepository: ReportEntryRepositoryProtocol = DIContainer.shared.resolve(type: ReportEntryRepositoryProtocol.self )!) {
        self.reportEntryRepository = reportEntryRepository
    }
    
    // Register the background task
    func registerBackgroundTask() {
        // Check if BGTaskScheduler is available (iOS 13+)
        guard #available(iOS 13.0, *) else {
            AppLogger.error("BGTaskScheduler not available on this iOS version")
            return
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: backgroundTaskIdentifier,
            using: nil
        ) { task in
            guard let refreshTask = task as? BGAppRefreshTask else {
                AppLogger.error("Invalid task type received")
                task.setTaskCompleted(success: false)
                return
            }
            self.handleReportCleanup(task: refreshTask)
        }
    }
    
    // Schedule the periodic cleanup (call this when app becomes active)
    func scheduleReportCleaner() {
        guard #available(iOS 13.0, *) else {
            AppLogger.error("BGTaskScheduler not available, attempting foreground cleanup")
            performForegroundCleanupIfNeeded()
            return
        }
        
        // Cancel any existing scheduled tasks
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: backgroundTaskIdentifier)
        
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: minIntervalBetweenCleanups)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            AppLogger.debug("Report cleanup scheduled successfully")
        } catch BGTaskScheduler.Error.notPermitted {
            AppLogger.error("Background refresh not permitted by user")
        } catch BGTaskScheduler.Error.tooManyPendingTaskRequests {
            AppLogger.error("Too many pending background tasks")
        } catch BGTaskScheduler.Error.unavailable {
            AppLogger.error("Background tasks unavailable")
        } catch {
            AppLogger.error("Failed to schedule report cleanup: \(error.localizedDescription)")
        }
    }
    
    // Fallback cleanup for older iOS versions or when background tasks fail
    func performForegroundCleanupIfNeeded() {
        let lastCleanup = userDefaults.object(forKey: lastCleanupKey) as? Date ?? Date.distantPast
        let timeSinceLastCleanup = Date().timeIntervalSince(lastCleanup)
        
        if timeSinceLastCleanup >= minIntervalBetweenCleanups {
            performCleanup()
        }
    }
    
    // Force cleanup (for testing or manual triggers)
    func performCleanup() {
        let tag = "ReportCleanerService"
        
        Task {
            do {
                AppLogger.debug("Starting report cleanup job")
                try await reportEntryRepository.deleteSentReportEntries()
                userDefaults.set(Date(), forKey: lastCleanupKey)
                AppLogger.debug("Report cleanup job success")
            } catch {
                AppLogger.error("Report cleanup job failed: \(error.localizedDescription)")
            }
        }
    }
    
    // Handle the background task execution
    private func handleReportCleanup(task: BGAppRefreshTask) {
        let tag = "ReportCleanerService"
        AppLogger.debug("Background cleanup task started")
        
        // Check if cleanup is actually needed
        let lastCleanup = userDefaults.object(forKey: lastCleanupKey) as? Date ?? Date.distantPast
        let timeSinceLastCleanup = Date().timeIntervalSince(lastCleanup)
        
        if timeSinceLastCleanup < minIntervalBetweenCleanups {
            AppLogger.info("Cleanup not needed yet, skipping")
            scheduleReportCleaner() // Reschedule for later
            task.setTaskCompleted(success: true)
            return
        }
        
        // Schedule the next execution before starting work
        scheduleReportCleaner()
        
        // Create the cleanup operation with proper cancellation handling
        let cleanupOperation = BlockOperation()
        
        cleanupOperation.addExecutionBlock { [weak self, weak cleanupOperation] in
            guard let self = self,
                  let operation = cleanupOperation,
                  !operation.isCancelled else {
                AppLogger.info("Cleanup operation was cancelled")
                task.setTaskCompleted(success: false)
                return
            }
            
            do {
                AppLogger.debug("Starting report cleanup job")
                
                // Check for cancellation during long-running operations
                if operation.isCancelled {
                    task.setTaskCompleted(success: false)
                    return
                }
                
                try self.reportEntryRepository.deleteSentReportEntries()
                self.userDefaults.set(Date(), forKey: self.lastCleanupKey)
                AppLogger.debug("Report cleanup job success")
                task.setTaskCompleted(success: true)
            } catch {
                AppLogger.error("Report cleanup job failed: \(error.localizedDescription)")
                task.setTaskCompleted(success: false)
            }
        }
        
        // Handle task expiration with proper cleanup
        task.expirationHandler = { [weak cleanupOperation] in
            AppLogger.info("Report cleanup job expired")
            cleanupOperation?.cancel()
            task.setTaskCompleted(success: false)
        }
        
        // Execute the cleanup on a background queue
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.addOperation(cleanupOperation)
    }
}

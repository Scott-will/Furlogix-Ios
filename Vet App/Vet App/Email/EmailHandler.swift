//
//  EmailHandler.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-10.
//

import UIKit
import Foundation
import SwiftUI
import MessageUI

class EmailHandler: NSObject, MFMailComposeViewControllerDelegate, EmailHandlerProtocol {
    
    private var userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    // MARK: - Send email using UIActivityViewController (closest to Intent with EXTRA_STREAM)
    func createAndSendEmail(wrapper: EmailWrapper, presentingController: UIViewController) {
        let activityItems: [Any] = [wrapper.subject, wrapper.bodyText, wrapper.fileURL]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // Optionally exclude certain activity types if you only want mail
        // activityVC.excludedActivityTypes = [.postToFacebook, .postToTwitter, .saveToCameraRoll, .assignToContact]
        
        // Present
        presentingController.present(activityVC, animated: true)
        
        // Simulate your repository update
        Task {
            let userId = await userRepository.getCurrentUser()?.id
            //await userRepository.setPendingReportsForUser(userId: userId)
        }
    }
    
    // MARK: - Alternative: Using MFMailComposeViewController (dedicated mail UI)
    func createAndSendEmailWithMF(wrapper: EmailWrapper, presentingController: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            print("No mail accounts configured")
            return
        }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([wrapper.toEmailAddress])
        mailVC.setSubject(wrapper.subject)
        mailVC.setMessageBody(wrapper.bodyText, isHTML: false)
        
        if let data = try? Data(contentsOf: wrapper.fileURL) {
            mailVC.addAttachmentData(data, mimeType: "text/csv", fileName: wrapper.fileURL.lastPathComponent)
        }
        
        presentingController.present(mailVC, animated: true)
        
        // Update user repository
        Task {
            let userId = await userRepository.getCurrentUser()?.id
            //await userRepository.setPendingReportsForUser(userId: userId)
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}

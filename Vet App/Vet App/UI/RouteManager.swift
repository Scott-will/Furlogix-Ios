//
//  RouteManager.swift
//  Vet App
//
//  Created by Scott Williams on 2025-07-06.
//

import SwiftUI

final class RouteManager: ObservableObject {
    static let shared = RouteManager()

    @Published var path = NavigationPath()
    @Published private(set) var stack: [AppRoute] = []

    private init() {}

    var currentRoute: AppRoute {
        stack.last ?? .dashboard(userId: 1)
    }

    func push(_ route: AppRoute) {
        path.append(route)
        stack.append(route)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
            stack.removeLast()
        }
    }

    func popToRoot() {
        path.removeLast(path.count)
        stack.removeAll()
    }
    
    func onNavigate(_ route : AppRoute){
        self.push(route)
    }
}

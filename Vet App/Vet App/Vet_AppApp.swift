//
//  Vet_AppApp.swift
//  Vet App
//
//  Created by Daylyn  Kokeza  on 2024-12-08.
//


import SwiftUI

@main
struct MyApp: App {
    
    init(){
        DIContainer.registerAllServices()
    }
    
    var body: some Scene {
        let userRepository = DIContainer.shared.resolve(type: UserRepositoryProtocol.self)
        let users = userRepository?.getUsers()
        WindowGroup {
            if((users?.count  ?? 0) > 0){
                RootView()
            }
            else{
                SignUpScreenView(onNavigate: {r in RouteManager.shared.onNavigate(r)})
            }
            
        }
    }
}


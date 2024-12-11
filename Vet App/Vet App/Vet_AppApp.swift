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
        WindowGroup {
            MainView()
        }
    }
}


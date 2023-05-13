//
//  ProyectoApp.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 16/2/23.
//

import SwiftUI
import Firebase

@main
struct ProyectoApp: App {
    @StateObject var firebaseManager = FirebaseManager()
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseManager)
        }
    }
}

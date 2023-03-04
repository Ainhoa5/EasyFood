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
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

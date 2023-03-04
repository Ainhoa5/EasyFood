//
//  RootView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 4/3/23.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @State var isUserAuthenticated = false
    
    var body: some View {
        Group {
            if isUserAuthenticated {
                ContentView()
            } else {
                LoginSignupView()
            }
        }
        .onAppear {
            // Check if the user is authenticated and update the state accordingly
            if Auth.auth().currentUser != nil {
                isUserAuthenticated = true
            } else {
                isUserAuthenticated = false
            }
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

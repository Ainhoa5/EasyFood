//
//  UserView.swift
//  Proyecto
//
//  Created by CIFP Villa De Aguimes on 4/3/23.
//

import SwiftUI

struct UserView: View {
    @StateObject private var firestoreManager = FirebaseManager()
    @State private var user: User?
    
    var body: some View {
        VStack {
            if let user = user {
                Text("Email: \(user.email)")
                Text("Name: \(user.name)")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            firestoreManager.fetchUserDocument { user, error in
                if let error = error {
                    print("Failed to fetch user document: \(error.localizedDescription)")
                    return
                }
                self.user = user
            }
        }
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}

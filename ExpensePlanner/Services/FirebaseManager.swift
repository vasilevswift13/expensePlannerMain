//
//  FirebaseManager.swift
//  ExpensePlanner
//
//  Created by Dmitry on 27.05.26.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

class FirebaseManager {
    
    private let googleService: GoogleSignInServiceProtocol
    private let facebookService: FacebookSignInServiceProtocol
    
    init(googleService: GoogleSignInServiceProtocol = GoogleSignInService(),
    facebookService: FacebookSignInServiceProtocol = FacebookSignInService()) {
        self.googleService = googleService
        self.facebookService = facebookService
    }
    
    
    func registNewUser(user: UserData) async throws {
      let authResult = try await Auth.auth().createUser(withEmail: user.email, password: user.password)
        try await authResult.user.sendEmailVerification()
        print(authResult.user.uid)
    }

    func signIn(user: UserData) async throws {
        try await Auth.auth().signIn(withEmail: user.email, password: user.password)
    }
    
    // вход через гугл

    func signInWithGoogle() async throws {
        let credential = try await googleService.signIn()
        let authResult = try await Auth.auth().signIn(with: credential)
        print(" Вход через Google успешен, UID: \(authResult.user.uid)")
    }
    
    
    // вход через ФБ
    
    func signInWithFacebook() async throws {
            let credential = try await facebookService.signIn()
            let authResult = try await Auth.auth().signIn(with: credential)
            print("Вход через Facebook успешен, UID: \(authResult.user.uid)")
        }

    
}




struct UserData {
    var email: String
    var password: String
}

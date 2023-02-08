//
//  GithubAuthentication.swift
//  GithubOAuth-Firebase
//
//  Created by Da Hae Lee on 2023/01/23.
//

import Foundation
import FirebaseAuth

class GitHubAuthManager: ObservableObject {
    static let shared: GitHubAuthManager = GitHubAuthManager() // singleton
    @Published var state: SignInState = .signedOut

    var provider = OAuthProvider(providerID: "github.com")
    let authentification = Auth.auth()
    private var githubCredential: AuthCredential? = nil
    
    enum SignInState {
        case signedIn
        case signedOut
    }

    init() {
        githubPermissionPreconfigure()
    }
    
    func githubPermissionPreconfigure() {
        provider.customParameters = [ // ② - (1)
            "allow_signup": "false"
        ]
        // 사용자의 이메일 주소에 접근하기 위한 요청입니다.
        // 이 부분은 앱의 API 권한에서 사전에 설정되어야만 합니다.
        provider.scopes = ["user:email"]  // ② - (2)
    }
    
    // MARK: - Sign In
    /// Authenticate with Firebase using the OAuth provider object.
    func signIn() {
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                // Handle error
            }
            guard let credential else { return }
            self.githubCredential = credential
            self.authentification.signIn(with: credential) { authResult, error in
                if error != nil {
                    // Handle error
                }
                // User is signed in.
                // IdP data available in authResult.additionalUserInfo.profile.
                
                guard let oauthCredential = authResult?.credential as? OAuthCredential else { return }
                // GitHub OAuth access token can also be retrieved by:
                // oauthCredential.accessToken
                print("\(String(describing: oauthCredential.accessToken))")
                // GitHub OAuth ID token can be retrieved by calling:
                // oauthCredential.idToken
                print("\(String(describing: oauthCredential.idToken))")
                
            }
        }
    }
    
    // MARK: - Link Existing User
    func linkGitHubProviderToExistingUser() {
        if let githubCredential {
            self.authentification.currentUser?.link(with: githubCredential) { authResult, error in
                if error != nil {
                    // Handle Error.
                }
                // GitHub credential is linked to the current user.
                // IdP data available in authResult.additionalUserInfo.profile.
                // GitHub OAuth access token can also be retrieved by:
                // (authResult.credential as? OAuthCredential)?.accessToken
                // GitHub OAuth ID token can be retrieved by calling:
                // (authResult.credential as? OAuthCredential)?.idToken
            }
        }
    }
    
    // MARK: - Reauthenticate
    func reauthenticateUser() {
        if let githubCredential {
            self.authentification.currentUser?.reauthenticate(with: githubCredential) { authResult, error in
                if error != nil {
                    // Handle error.
                }
                // User is re-authenticated with fresh tokens minted and
                // should be able to perform sensitive operations like account
                // deletion and email or password update.
                // IdP data available in result.additionalUserInfo.profile.
                // Additional OAuth access token is can also be retrieved by:
                // (authResult.credential as? OAuthCredential)?.accessToken
                // GitHub OAuth ID token can be retrieved by calling:
                // (authResult.credential as? OAuthCredential)?.idToken
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try authentification.signOut()
            state = .signedOut
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

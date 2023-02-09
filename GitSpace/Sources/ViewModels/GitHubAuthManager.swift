//
//  GithubAuthentication.swift
//  GithubOAuth-Firebase
//
//  Created by Da Hae Lee on 2023/01/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

enum GithubURL: String {
    case baseURL = "https://api.github.com"
    case userPath = "/user"
    case bearer = "Bearer"
}

final class GitHubAuthManager: ObservableObject {
    static let shared: GitHubAuthManager = GitHubAuthManager() // singleton
    
    @Published var state: SignInState = .signedOut
    @Published var githubAcessToken: OAuthCredential?
    
    let authentification = Auth.auth()
    let database = Firestore.firestore()
    var provider = OAuthProvider(providerID: "github.com")
    private var githubCredential: AuthCredential? = nil
    var authenticatedUser: UserInfoTemp?
    
    enum SignInState {
        case signedIn
        case signedOut
    }

    init() {
        githubPermissionPreconfigure()
    }
    
    // MARK: - GitHub OAuth 연결 설정
    /// GitHub OAuth를 사용하기 위해 필요한 설정들을 세팅합니다.
    func githubPermissionPreconfigure() {
        provider.customParameters = [
            "allow_signup": "false"
        ]
        // 사용자의 이메일 주소에 접근하기 위한 요청입니다.
        // 이 부분은 앱의 API 권한에서 사전에 설정되어야만 합니다.
        provider.scopes = [
            "user:email",
            "read:user"
        ]
    }
    
    // MARK: - SignIn
    /// Authenticate User.
    /// Authenticate with Firebase using the OAuth provider object.
    /// 사용자의 깃허브 로그인을 진행합니다.
    func signIn() {
        provider.getCredentialWith(nil) { credential, error in
            if let error {
                // Handle error
                print("here")
                print(error)
            }
            
            if let credential {
            
                self.authentification.signIn(with: credential) { authResult, error in
                    if error != nil {
                        print("SignIn Error: \(String(describing: error?.localizedDescription))")
                    }
                    // User is signed in.
                    guard let oauthCredential = authResult?.credential as? OAuthCredential else { return }
                    
                    // Github 사용자 데이터(name, email)을 가져오기 위해서 GitHub REST API request가 필요하다.
                    guard let githubAuthenticatedUserURL = URL(string: "https://api.github.com/user") else {
                        return
                    }
                    print(oauthCredential.accessToken!)
                    
                    var session = URLSession(configuration: .default)
                    var githubRequest = URLRequest(url: githubAuthenticatedUserURL)
                    githubRequest.httpMethod = "GET"
                    githubRequest.addValue("Bearer \(oauthCredential.accessToken!)", forHTTPHeaderField: "Authorization")
                    
                    let task = session.dataTask(with: githubRequest) { data, response, error in
                        guard error == nil else {
                            print("SignIn Task Error: ", error?.localizedDescription as Any)
                            return
                        }
                        guard let userData = data else {
                            print("SignIn Decoded Error: ", error?.localizedDescription as Any)
                            return
                        }
                        //                    self.decodeUserData(userData)
                        
                        do {
                            let decodedUser = try JSONDecoder().decode(UserInfoTemp.self, from: userData)
                            self.authenticatedUser = decodedUser
                        } catch {
                            print(error)
                        }
                        
                        guard self.authenticatedUser != nil else {
                            return
                        }
                        self.registerNewUser(self.authenticatedUser!)
                        
                        // TODO: 로그인한 유저의 레포정보 가져오기 (request)
                        /* */
                        
                        DispatchQueue.main.async {
                            self.state = .signedIn

                        }
                    }
                    task.resume()
                }
            }
        }
    }
    
    // MARK: - Register New User at Firestore
    /// Firestore에 새로운 회원을 등록합니다.
    func registerNewUser(_ user: UserInfoTemp) {
        database.collection("UserInfo")
            .document("\(user.id)")
            .setData([
                "id": user.id,
                "name": user.name,
                "email": user.email
            ])
    }
    
    // MARK: - Sign Out
    /// 사용자의 깃허브 로그아웃을 진행합니다.
    func signOut() {
        do {
            try authentification.signOut()
            state = .signedOut
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - Delete User at Authentication
    /// 사용자의 회원탈퇴를 진행합니다.
    @MainActor
    func withdrawal() async -> Void {
        do {
            await deleteCurrentUser()
            try await authentification.currentUser?.delete()
            state = .signedOut
        } catch let deleteUserError as NSError {
            print(#function, "Error delete user: %@", deleteUserError)
        }
    }
    
    // MARK: - Delete User at Firestore
    func deleteCurrentUser() async -> Void {
        do {
            try await database.collection("UserInfo")
                .document("\(self.authenticatedUser!.id)")
                .delete()
        } catch let deleteUserError as NSError {
            print(#function, "Error delete user: %@", deleteUserError)
        }
    }
    
    // MARK: - Link Existing User
    /// 이미 Firebase Authenticate에 존재하는 유저를 연결합니다.
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
    /// Reauthenticate User.
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
}


extension GitHubAuthManager {
    
    // MARK: - Decode User Data
    func decodeUserData(_ data: Data) {
        do {
            let decodedUser = try JSONDecoder().decode(UserInfoTemp.self, from: data)
            self.authenticatedUser = decodedUser
        } catch {
            print(error)
        }
    }
    
}

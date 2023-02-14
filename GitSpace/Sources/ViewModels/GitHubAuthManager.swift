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
    case starredPath = "/starred"
    case bearer = "Bearer"
}

// FIXME: AccessToken은 안전하게 보관할 것.
/// keychain에 저장하도록 하자.
var tempoaryAccessToken: String?

final class GitHubAuthManager: ObservableObject {
    
    @Published var state: SignInState = .signedOut
    @Published var githubAcessToken: String?
    
    //    var result: GitHubUser? = nil
    
    var authentification = Auth.auth()
    let database = Firestore.firestore()
    var provider = OAuthProvider(providerID: "github.com")
    private var githubCredential: OAuthCredential? = nil
    var authenticatedUser: GitHubUser?
    
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
                    // FIXME: Keychain에 accesstoken 저장하기
                    print(oauthCredential.accessToken!)
                    self.githubAcessToken = oauthCredential.accessToken
                    tempoaryAccessToken = oauthCredential.accessToken
                    
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
                        
                        self.authenticatedUser = DecodingManager.decodeData(userData, GitHubUser.self)
                        
                        guard self.authenticatedUser != nil else {
                            return
                        }
                        
                        self.registerNewUser(self.authenticatedUser!)
                        
                        DispatchQueue.main.async {
                            self.state = .signedIn
                            
                        }
                    }
                    task.resume()
                }
            }
        }
    }
    
    // FIXME: requestExistUser -> registerNewUser순으로 Completion Handler { Completion Handler { } } 구조로 작업 필요
    // existUser에서 가입일시를 받아서 새 user 만들기 + Github API 닉네임과 UserInfo 닉네임이 일치하지 않으면 업데이트
    // MARK: Method - Auth의 currentUser를 통해 UserInfo에 이미 존재하는 유저인지 여부를 반환하는 메서드
    // Github Auth 로그인 수행 -> User DB에서 이미 존재하는지 체크 -> 가입날짜 유지 및 나머지 정보 최신으로 갱신
    
    // MARK: - Register New User at Firestore
    /// Firestore에 새로운 회원을 등록합니다.
    private func registerNewUser(_ githubUser: GitHubUser) {
        
        if let uid = authentification.currentUser?.uid {
            // 현재 Auth 로그인 uid로 UserInfo에 접근
            database
                .collection("UserInfo")
                .document(uid)
                .getDocument { result, error in
                    // 결과가 없거나, 유저가 존재하지 않으면 UserInfo에 새롭게 추가
                    guard let result, result.exists else {
                        let newUser: UserInfo = .init(id: uid,
                                                      createdDate: Date.now,
                                                      githubUserName: githubUser.login,
                                                      deviceToken: "",
                                                      emailTo: githubUser.email,
                                                      blockedUserIDs: [])
                        self.addUser(newUser)
                        return
                    }
                    // 이미 존재하는 유저 && 깃허브 프로필과 아이디가 다르면 변경된 아이디로 업데이트
                    do {
                        let existUser: UserInfo = try result.data(as: UserInfo.self)
                        if existUser.githubUserName != githubUser.login {
                            self.database
                                .collection("UserInfo")
                                .document(existUser.id)
                                .updateData(["githubUserName" : githubUser.login])
                        }
                    } catch {
                        print("Decode User Error : \(error.localizedDescription)")
                    }
                }
        }
    }
    
    // MARK: - Add User
    // 유저를 DB에 추가합니다.
    private func addUser(_ user: UserInfo) {
        do {
            try database
                .collection("UserInfo")
                .document(user.id)
                .setData(from: user.self)
        } catch {
            print("Error-GitHubAuthManager-addUser : \(error.localizedDescription)")
        }
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
    
    
    
    // MARK: - Get GitHub User Info
    // GitHubUser 구조체의 데이터를 불러옵니다.
    //    func getGitHubUserInfo() {
    //        guard let url = URL(string: "https://api.github.com/users/\(GitHubUserName)") else {
    //            print("Invalid url")
    //            return
    //        }
    //
    //        var request = URLRequest(url: url)
    //        request.addValue("\(GithubURL.bearer) \(String(describing: temporaryAcessToken))", forHTTPHeaderField: "Authorization")
    //
    //        URLSession.shared.dataTask(with: request) { data, response, error in
    //            if error != nil {
    //                // TODO: Handle data task error
    //                return
    //            }
    //
    //            guard let data = data else {
    //                // TODO: Handle this
    //                return
    //            }
    //
    //            let decoder = JSONDecoder()
    //            decoder.keyDecodingStrategy = .convertFromSnakeCase
    //
    //            do {
    //                let response = try decoder.decode([GitHubUser].self, from: data)
    //
    //                DispatchQueue.main.async {
    //                    self.result = response
    //                }
    //            } catch {
    //                // TODO: Handle decoding error
    //                print(error)
    //            }
    //        }.resume()
    //    }
}


class DecodingManager {
    
    // MARK: - Decode User Data
    // FIXME: 공동으로 쓰일 수 있는 함수
    /// 밖으로 꺼내서 쓰고 싶다..!!!1
    static func decodeData<T: Decodable>(_ data: Data, _ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    static func decodeArrayData<T: Decodable>(_ data: Data, _ type: [T].Type) -> [T]? {
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}


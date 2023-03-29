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

final class GitHubAuthManager: ObservableObject {
    @Published var state: SignInState = .signedOut
    
    private let database = Firestore.firestore()
    private let const = Constant.FirestorePathConst.self
    private var authCredential: AuthCredential? = nil
    
    var provider = OAuthProvider(providerID: "github.com")
    var authentification = Auth.auth()
    var authenticatedUser: GithubUser?
    
    enum SignInState {
        case signedIn
        case pending
        case signedOut
    }
    
    init() {
        githubPermissionPreconfigure()
    }
    
    static let sampleUser: GithubUser = GithubUser(id: 123, login: "octo", name: "cuty_octo", email: "gitspace.rbg@gmail.com", avatar_url: "https://avatars.githubusercontent.com/u/124763259?v=4", bio: "I'm Cuty Octo!", company: "GitSpace RBG", location: "Space", blog: "https://gitspace.tistory.com", public_repos: 0, followers: 7, following: 7)
    
    // MARK: - GitHub OAuth 연결 설정
    /// GitHub OAuth를 사용하기 위해 필요한 설정들을 세팅합니다.
    func githubPermissionPreconfigure() {
        provider.customParameters = [
            "allow_signup": "false"
        ]
        // 사용자의 이메일 주소에 접근하기 위한 요청입니다.
        // 이 부분은 앱의 API 권한에서 사전에 설정되어야만 합니다.
        provider.scopes = [
            "user",
            "read",
            "repo"
        ]
    }
    
    // MARK: - SignIn
    /// Authenticate User.
    /// Authenticate with Firebase using the OAuth provider object.
    /// 사용자의 깃허브 로그인을 진행합니다.
    func signin() {
        provider.getCredentialWith(nil) { credential, error in
            if let error {
                // Handle error
                print(error)
            }
            
            if let credential {
                self.state = .pending
                self.authentification.signIn(with: credential) { authResult, error in
                    if error != nil {
                        print("SignIn Error: \(String(describing: error?.localizedDescription))")
                    }
                    // User is signed in.
                    guard let oauthCredential = authResult?.credential as? OAuthCredential else {
                        return
                    }
                    // Github 사용자 데이터(name, email)을 가져오기 위해서 GitHub REST API request가 필요하다.
                    guard let githubAuthenticatedUserURL = URL(string: "https://api.github.com/user") else {
                        return
                    }
                    
                    guard let at = oauthCredential.accessToken else { return }
                    
                    UserDefaults.standard.set(at, forKey: "AT")
                    
                    let session = URLSession(configuration: .default)
                    var githubRequest = URLRequest(url: githubAuthenticatedUserURL)
                    githubRequest.httpMethod = "GET"
                    githubRequest.addValue("Bearer \(at)", forHTTPHeaderField: "Authorization")
                    
                    let task = session.dataTask(with: githubRequest) { data, response, error in
                        guard error == nil else {
                            print("SignIn Task Error: ", error?.localizedDescription as Any)
                            return
                        }
                        guard let userData = data else {
                            print("SignIn Decoded Error: ", error?.localizedDescription as Any)
                            return
                        }
                        
                        self.authenticatedUser = DecodingManager.decodeData(userData, GithubUser.self)
                        
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
    
    // existUser에서 가입일시를 받아서 새 user 만들기 + Github API 닉네임과 UserInfo 닉네임이 일치하지 않으면 업데이트
    // MARK: Method - Auth의 currentUser를 통해 UserInfo에 이미 존재하는 유저인지 여부를 반환하는 메서드
    // Github Auth 로그인 수행 -> User DB에서 이미 존재하는지 체크 -> 가입날짜 유지 및 나머지 정보 최신으로 갱신
    // MARK: - Register New User at Firestore
    /// Firestore에 새로운 회원을 등록합니다.
    private func registerNewUser(_ githubUser: GithubUser) {
        
        if let firebaseAuthUID = authentification.currentUser?.uid {
            // 현재 Auth 로그인 uid로 UserInfo에 접근
            database
                .collection(const.COLLECTION_USER_INFO)
                .document(firebaseAuthUID)
                .getDocument { result, error in
                    // 결과가 없거나, 유저가 존재하지 않으면 UserInfo에 새롭게 추가
                    guard let result, result.exists else {
                        
                        let newUser: UserInfo = .init(id: firebaseAuthUID,
                                                      createdDate: Date.now,
                                                      deviceToken: "",
                                                      blockedUserIDs: [],
                                                      githubID: githubUser.id,
                                                      githubLogin: githubUser.login,
                                                      githubName: githubUser.name,
                                                      githubEmail: githubUser.email,
                                                      avatar_url: githubUser.avatar_url,
                                                      bio: githubUser.bio,
                                                      company: githubUser.company,
                                                      location: githubUser.location,
                                                      blog: githubUser.blog,
                                                      public_repos: githubUser.public_repos,
                                                      followers: githubUser.followers,
                                                      following: githubUser.following)
                        
                        self.addUser(newUser)
                        return
                    }
                    // 기존 유저 정보와 깃허브 로그인 시 받은 정보의 필드가 불일치하면, 로그인 정보로 DB의 기존 유저 정보 업데이트
                    do {
                        let existUser: UserInfo = try result.data(as: UserInfo.self)
                        let existGithubUser: GithubUser = self.getGithubUser(FBUser: existUser)
                        if existGithubUser != githubUser {
                            let updatedUserInfo: UserInfo = self.getFBUserWithUpdatedGithubUser(FBUser: existUser, githubUser: githubUser)
                            try self.database
                                .collection(self.const.COLLECTION_USER_INFO)
                                .document(existUser.id)
                                .setData(from: updatedUserInfo)
                        }
                    } catch {
                        print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
                    }
                }
        }
    }
    
    /**
     Firestore UserInfo에서 깃허브 유저 관련 프로퍼티를 받아서 GithubUser 인스턴스로 반환하는 메서드
     
     - parameters:
     - FBUser: Firestore UserInfo 모델
     
     - Returns: FBUser의 프로퍼티를 통해 생성한 GithubUser 인스턴스
     */
    private func getGithubUser(FBUser: UserInfo) -> GithubUser {
        return .init(id: FBUser.githubID,
                     login: FBUser.githubLogin,
                     name: FBUser.githubName,
                     email: FBUser.githubEmail,
                     avatar_url: FBUser.avatar_url,
                     bio: FBUser.bio,
                     company: FBUser.company,
                     location: FBUser.location,
                     blog: FBUser.blog,
                     public_repos: FBUser.public_repos,
                     followers: FBUser.followers,
                     following: FBUser.following)
    }
    
    /**
     기존 Firestore UserInfo와 업데이트된 GithubUser를 통해서 업데이트된 Firestore UserInfo를 생성하는 메서드
     
     - parameters:
        - FBUser: 기존 Firestore UserInfo
        - githubUser: 새로 업데이트 된 GithubUser
     
     - Returns: 기존 Firestore 유저 정보와 업데이트 된 Github 유저 정보를 통해 생성된 Firestore 유저
     */
    private func getFBUserWithUpdatedGithubUser(FBUser: UserInfo, githubUser: GithubUser) -> UserInfo {
        return .init(id: FBUser.id,
                     createdDate: FBUser.createdDate,
                     deviceToken: FBUser.deviceToken,
                     blockedUserIDs: FBUser.blockedUserIDs,
                     githubID: githubUser.id,
                     githubLogin: githubUser.login,
                     githubName: githubUser.name,
                     githubEmail: githubUser.email,
                     avatar_url: githubUser.avatar_url,
                     bio: githubUser.bio,
                     company: githubUser.company,
                     location: githubUser.location,
                     blog: githubUser.blog,
                     public_repos: githubUser.public_repos,
                     followers: githubUser.followers,
                     following: githubUser.following)
    }
    
    // MARK: - Add User
    // 유저를 DB에 추가합니다.
    private func addUser(_ user: UserInfo) {
        do {
            try database
                .collection(const.COLLECTION_USER_INFO)
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
            try await database.collection(const.COLLECTION_USER_INFO)
                .document(Auth.auth().currentUser?.uid ?? "")
                .delete()
        } catch let deleteUserError as NSError {
            print(#function, "Error delete user: %@", deleteUserError)
        }
    }
    
    // MARK: - Link Existing User
    /// 이미 Firebase Authenticate에 존재하는 유저를 연결합니다.
    func linkGitHubProviderToExistingUser() {
        if let authCredential {
            self.authentification.currentUser?.link(with: authCredential) { authResult, error in
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
    
    // MARK: Reqeust Firebase Credential
    ///
    func requestCredential() async -> Void {
        let credential = await withCheckedContinuation { continuation in
            provider.getCredentialWith(nil) { credential, error in
                continuation.resume(returning: credential)
            }
        }
        authCredential = credential
    }
    
    // MARK: - Reauthenticate
    /// Reauthenticate User.
    func reauthenticateUser() async -> Void {
        
        // 자동 로그인 시 로그인뷰가 아닌 로딩뷰를 띄워주기 위한 상태 변경 (written by 예슬)
        DispatchQueue.main.async {
            self.state = .pending
        }
        
        guard let githubAccessToken = UserDefaults.standard.string(forKey: "AT") else {
            fatalError("Failed To Get Access Token.")
        }
        let authCredential = GitHubAuthProvider.credential(withToken: githubAccessToken)
        await withCheckedContinuation({ continuation in
            self.authentification.currentUser?.reauthenticate(with: authCredential) { authResult, error in
                continuation.resume()
            }
        })
        // Github 사용자 데이터(name, email)을 가져오기 위해서 GitHub REST API request가 필요하다.
        guard let githubAuthenticatedUserURL = URL(string: "https://api.github.com/user") else {
            return
        }
        let session = URLSession(configuration: .default)
        var githubRequest = URLRequest(url: githubAuthenticatedUserURL)
        githubRequest.httpMethod = "GET"
        githubRequest.addValue("Bearer \(githubAccessToken)", forHTTPHeaderField: "Authorization")
        do {
            let (data, _) = try await session.data(for: githubRequest)
            self.authenticatedUser = DecodingManager.decodeData(data, GithubUser.self)
            guard self.authenticatedUser != nil else {
                return
            }
            DispatchQueue.main.async {
                self.state = .signedIn
            }
        } catch {
            print("")
        }
    }
    
    
    
    // MARK: - Get GitHub User Info
    // GithubUser 구조체의 데이터를 불러옵니다.
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
    //                let response = try decoder.decode([GithubUser].self, from: data)
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


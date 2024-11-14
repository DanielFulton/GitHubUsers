//
//  UserRepoViewController.swift
//  Github Users
//
//  Created by Daniel Fulton on 2024/11/14.
//

import UIKit
import SafariServices

enum UserRepoError: Error {
  case missingUser
  case noRepoName
}

class UserRepoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var numberFollowersLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  var user: UserJson?
  var userInfo: UserInfoJSON?
  var repos: [UserRepoJson] = [] {
    didSet {
      print("got repos")
      collectionView.reloadData()
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
//    collectionView.dataSource = self
//    collectionView.delegate = self
    collectionView.setCollectionViewLayout(createBasicListLayout(cellHeight: 128.0), animated: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let currentUser = user else {
      // error
      return
    }
    updateUserUI(currentUser)
    getUserData()
    getRepoData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return repos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let repo = repos[indexPath.item]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepoCell", for: indexPath)
    if let repoCell = cell as? RepoCell {
      repoCell.updateWithRepo(repo, login: user?.login ?? "")
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let repo = repos[indexPath.item]
    guard let url = URL(string: repo.html_url) else {
      // error
      return
    }
    let sfvc = SFSafariViewController(url: url)
    present(sfvc, animated: true)
  }
  
  fileprivate func updateUserUI(_ currentUser: UserJson) {
    getImage(url: currentUser.avatar_url)
    userNameLabel.text = currentUser.login
    if userInfo == nil {
      fullNameLabel.text = ""
      numberFollowersLabel.text = ""
    }
  }
  
  func getUserData() {
    Task {
      let userInfo = try await getInfo()
      self.userInfo = userInfo
      fullNameLabel.text = userInfo.name
      numberFollowersLabel.text = "Followers: \(userInfo.followers)"
    }
  }
  
  func getRepoData() {
    Task {
      do {
        let repos = try await getRepos()
        let nonForks = repos.filter({ !$0.fork })
        self.repos = nonForks
      } catch {
        print("error: \(error)")
      }
    }
  }
  
  func getInfo() async throws -> UserInfoJSON {
    guard let currentUser = user else { throw UserRepoError.missingUser }
    let user1Data = try await getUserInfo(login: currentUser.login)
    let userInfo:UserInfoJSON = try await createEntity(data: user1Data)
    return userInfo
  }
  func getRepos() async throws -> [UserRepoJson] {
    guard let currentUser = user else { throw UserRepoError.missingUser }
    let reposData = try await getReposForUser(login: currentUser.login)
    let repos:[UserRepoJson] = try await createEntity(data: reposData)
    return repos
  }
  
  func getUserInfo(login: String) async throws -> Data {
    return try await getDataForURLString("https://api.github.com/users/\(login)")
  }
  
  func getImage(url: String) {
    Task {
      let data = try await getImageDataForURLString(url)
      if let image = UIImage(data: data) {
        avatarImage.image = image
      }
    }
  }
}

func getReposForUser(login: String) async throws -> Data {
  return try await getDataForURLString("https://api.github.com/users/\(login)/repos")
}

func getRepoLanguages(login: String, repo: String) async throws -> Data {
  return try await getDataForURLString("https://api.github.com/repos/\(login)/\(repo)/languages")
}

struct UserInfoJSON: Codable {
  let name: String?
  let followers: Int
}
struct UserRepoJson: Codable {
  let name: String?
  let html_url: String
  let fork: Bool
  let description: String?
  let stargazers_count: Int
  var languages: [String:Int]?
}

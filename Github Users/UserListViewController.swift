//
//  ViewController.swift
//  Github Users
//
//  Created by Daniel Fulton on 2024/10/31.
//

import UIKit

class UserListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  @IBOutlet weak var collectionView: UICollectionView!
  private var users: [UserJson] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.setCollectionViewLayout(createBasicListLayout(), animated: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getUsers()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath)
    let user = users[indexPath.item]
    if let userCell = cell as? UserCell {
      userCell.userNameLabel.text = user.login
      userCell.showImage(url: user.avatar_url)
    }
    return cell
  }
  
//  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//    let user = users[indexPath.item]
//    
//  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let index = collectionView.indexPathsForSelectedItems!.first!
    let user = users[index.item]
    if let repoListVC = segue.destination as? UserRepoViewController {
      repoListVC.user = user
    }
  }
  
  func getUsers() {
    Task {
      let usersData = try await getUsersData()
      self.users = try await createEntity(data: usersData)
      print(users)
    }
  }
}



struct UserJson: Codable {
  let login: String
  let avatar_url: String
}

func getUsersData() async throws -> Data {
  return try await getDataForURLString("https://api.github.com/users")
}

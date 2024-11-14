//
//  RepoCell.swift
//  Github Users
//
//  Created by Daniel Fulton on 2024/11/14.
//

import UIKit

class RepoCell: UICollectionViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var starsLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  func updateWithRepo(_ repo: UserRepoJson, login: String) {
    nameLabel.text = repo.name
    starsLabel.text = "⭐️ \(repo.stargazers_count)"
    descriptionLabel.text = repo.description
    Task {
      let languages = try await getLanguages(repo: repo, login: login)
      languageLabel.text = languageString(dict: languages)
    }
  }
  
  func languageString(dict: [String: Int]) -> String {
    var text = ""
    for (key, value) in dict {
      text += "\(key) "
    }
    return text
  }
  
  func getLanguages(repo: UserRepoJson, login: String) async throws -> [String: Int] {
    guard let repoName = repo.name else { throw UserRepoError.noRepoName }
    let languageData = try await getRepoLanguages(login: login, repo: repoName)
    let repoLanguages:[String:Int] = try! await createEntity(data: languageData)
    return repoLanguages
  }
}



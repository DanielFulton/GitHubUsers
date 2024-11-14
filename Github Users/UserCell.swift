//
//  UserCell.swift
//  Github Users
//
//  Created by Daniel Fulton on 2024/11/14.
//

import UIKit

class UserCell: UICollectionViewCell {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  
  func showImage(url: String) {
    getImage(url: url)
    
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

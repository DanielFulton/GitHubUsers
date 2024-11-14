//
//  User.swift
//  Github Users
//
//  Created by Daniel Fulton on 2024/11/02.
//

import Foundation

struct User {
  let userName: String
  let fullName: String
  let iconURL: URL
  let numberOfFollowers: UInt
  var repos: [Repo]
}

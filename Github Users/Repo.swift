//
//  Repo.swift
//  Github Users
//
//  Created by Daniel Fulton on 2024/11/02.
//

import Foundation

struct Repo: Equatable {
  let name: String
  let language: String
  let numberOfStars: UInt
  let explanation: String
  let url: URL
}

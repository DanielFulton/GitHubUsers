//
//  UserTests.swift
//  Github UsersTests
//
//  Created by Daniel Fulton on 2024/11/02.
//

import XCTest
@testable import Github_Users

final class UserTests: XCTestCase {
  var user: User!
  override func setUp() {
    user = User(userName: "John", fullName: "John Smith", iconURL: URL(string: "https://godotengine.org")!, numberOfFollowers: 42, repos: [])
  }

  func testThatUserExists() {
    XCTAssertNotNil(user)
  }
  func testThatUserHasAUserName() {
    XCTAssertEqual(user.userName, "John", "the User should have the name I give it.")
  }
  func testThatUserHasFullName() {
    XCTAssertEqual(user.fullName, "John Smith")
  }
  func testThatUserHasIconURL() {
    let url:URL = user.iconURL
    XCTAssertEqual(url.absoluteString, "https://godotengine.org")
  }
  func testThatUserHasNumberOfFollowers() {
    XCTAssertEqual(user.numberOfFollowers, 42)
  }
  
  func testThatNewUserHasNoRepos() {
    XCTAssertEqual(user.repos, [])
  }
  
  func testThatUserCanAddRepo() {
    user.repos.append(.init(name: "", language: "", numberOfStars: 0, explanation: "", url: .init(string: "https://www.apple.com")!))
  }
}

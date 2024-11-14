//
//  RepositoryTests.swift
//  Github UsersTests
//
//  Created by Daniel Fulton on 2024/11/02.
//

import XCTest
@testable import Github_Users
final class RepositoryTests: XCTestCase {
  var repo: Repo!
  
  override func setUp() {
    repo = Repo(name: "SQLite", language: "PHP", numberOfStars: 7, explanation: "An explanation", url: URL(string: "https://github.com/sqlite")!)
  }
  
  func testThatRepositoryExists() {
    XCTAssertNotNil(repo)
  }
  func testThatRepoHasAName() {
    XCTAssertEqual(repo.name, "SQLite")
  }
  func testThatRepoHasDevelopmentLanguage() {
    XCTAssertEqual(repo.language, "PHP")
  }
  func testThatRepoHasNumberOfStars() {
    XCTAssertEqual(repo.numberOfStars, 7)
  }
  func testThatRepoHasExplanation() {
    XCTAssertEqual(repo.explanation, "An explanation")
  }
  func testThatRepoHasURL() {
    let url = repo.url
    XCTAssertEqual(url.absoluteString, "https://github.com/sqlite")
  }
}

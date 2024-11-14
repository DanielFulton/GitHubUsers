//
//  Networking.swift
//  Github Users
//
//  Created by Daniel Fulton on 2024/11/14.
//

import Foundation

enum TestError: Error {
  case couldntMakeTestJSON
  case badURL
  case redirection
  case serverError
  case clientError
  case noData
}
let accessToken = "" // Set this to remove request limits
func getDataForURLString(_ urlString: String) async throws -> Data {
  guard let url = URL(string: urlString) else {
    throw TestError.badURL
  }
  var request = URLRequest(url: url)
//  request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
  request.setValue(accessToken, forHTTPHeaderField: "Authorization")
  request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

  let session = URLSession(configuration: .default)
  let result: (data: Data, response: URLResponse) = try await session.data(for: request)
  if let http = result.response as? HTTPURLResponse {
    print(http)
    switch http.statusCode {
    case 0..<200:
      throw TestError.serverError
    case 300..<400:
      throw TestError.redirection
    case 400..<500:
      throw TestError.clientError
    case 500..<999:
      throw TestError.serverError
    default:
      break
    }
  }
  if result.data.isEmpty {
    throw TestError.noData
  }
  return result.0
}

func getImageDataForURLString(_ urlString: String) async throws -> Data {
  guard let url = URL(string: urlString) else {
    throw TestError.badURL
  }
  let session = URLSession(configuration: .default)
  let result: (data: Data, response: URLResponse) = try await session.data(from: url)
  if let http = result.response as? HTTPURLResponse {
    switch http.statusCode {
    case 0..<200:
      throw TestError.serverError
    case 300..<400:
      throw TestError.redirection
    case 400..<500:
      throw TestError.clientError
    case 500..<999:
      throw TestError.serverError
    default:
      break
    }
  }
  if result.data.isEmpty {
    throw TestError.noData
  }
  return result.0
}

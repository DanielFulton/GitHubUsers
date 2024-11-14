//
//  EntityBuilder.swift
//  Github Users
//
//  Created by Daniel Fulton on 2024/11/14.
//

import Foundation

func createEntity<T:Decodable>(data: Data) async throws -> T {
  let decoder = JSONDecoder()
  let entity = try decoder.decode(T.self, from: data)
  return entity
}

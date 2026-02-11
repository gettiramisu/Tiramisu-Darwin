//
//  StationTag.swift
//  TiramisuCore
//
//  Created by Alexandra Göttlicher
//

import Foundation

public struct StationTag: Sendable, Decodable, Hashable, Identifiable {
    public let id: Int
    public let name: String
}

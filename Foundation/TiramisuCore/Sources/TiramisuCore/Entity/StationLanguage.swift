//
//  StationLanguage.swift
//  TiramisuCore
//
//  Created by Alexandra Göttlicher
//

import Foundation

public struct StationLanguage: Sendable, Decodable, Hashable, Identifiable {
    public let id: Int
    public let iso6391: String
}

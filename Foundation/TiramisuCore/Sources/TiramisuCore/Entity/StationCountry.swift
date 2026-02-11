//
//  StationCountry.swift
//  TiramisuCore
//
//  Created by Alexandra Göttlicher
//

import Foundation

public struct StationCountry: Sendable, Decodable, Hashable, Identifiable {
    public let id: Int
    public let iso31662: String
}

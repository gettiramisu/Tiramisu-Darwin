//
//  Station.swift
//  TiramisuCore
//
//  Created by Alexandra Göttlicher
//

import Foundation

public struct Station: Sendable, Decodable, Hashable, Identifiable {
    public let id: Int
    public let uuid: String
    public let name: String
    public let streamUrl: URL
    public let homepageUrl: URL?
    public let iconUrl: URL?
    public let country: StationCountry
    public let languages: [StationLanguage]?
    public let tags: [StationTag]?
}

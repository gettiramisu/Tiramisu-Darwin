//
//  CappuccinoClient.swift
//  TiramisuCore
//
//  Created by Alexandra Göttlicher
//

import Foundation
import Logger

public struct StationSearchParameters {
    public let name: String?
    public let country: String?
    public let language: String?
    public let tag: String?
    public var page: Int

    public init(name: String? = nil, country: String? = nil, language: String? = nil, tag: String? = nil, page: Int = 1) {
        self.name = name
        self.country = country
        self.language = language
        self.tag = tag
        self.page = page
    }
}

public class CappuccinoClient: NSObject {
    private let endpoint: String = "http://127.0.0.1:8000/api/v1/station"

    public func fetchStations(with parameters: StationSearchParameters) async -> [Station] {
        var components: URLComponents = URLComponents(string: "\(endpoint)/search")!

        var queryItems: Array = [
            ("name", parameters.name),
            ("country", parameters.country),
            ("language", parameters.language),
            ("tag", parameters.tag)
        ].compactMap { key, value in
            value.map {
                URLQueryItem(name: key, value: $0)
            }
        }

        queryItems.append(URLQueryItem(name: "page", value: String(parameters.page)))
        components.queryItems = queryItems

        do {
            let data: Data = try await self.fetch(for: components.url!)
            return try self.decode([Station].self, from: data)
        } catch {
            return self.fetchErrorResult(forError: error)
        }
    }

    public func fetchStationCountries() async -> [StationCountry] {
        do {
            let data: Data = try await self.fetch(for: URL(string: "\(endpoint)/countries")!)
            return try self.decode([StationCountry].self, from: data)
        } catch {
            return self.fetchErrorResult(forError: error)
        }
    }

    public func fetchStationLanguages() async -> [StationLanguage] {
        do {
            let data: Data = try await self.fetch(for: URL(string: "\(endpoint)/languages")!)
            return try self.decode([StationLanguage].self, from: data)
        } catch {
            return self.fetchErrorResult(forError: error)
        }
    }

    public func fetchStationTags() async -> [StationTag] {
        do {
            let data: Data = try await self.fetch(for: URL(string: "\(endpoint)/tags")!)
            return try self.decode([StationTag].self, from: data)
        } catch {
            return self.fetchErrorResult(forError: error)
        }
    }

    private func fetchErrorResult<T>(forError error: Error) -> [T] {
        Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Error fetching data: \(error)", for: .error)
        return []
    }

    private func fetch(for url: URL) async throws -> Data {
        Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Fetching data for URL: \(url)", for: .info)
        return try await URLSession.shared.data(from: url).0
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder: JSONDecoder = .init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData: T = try decoder.decode(T.self, from: data)

        Logger.sharedInstance().logMessage("[\(String(describing: Swift.type(of: self)))] Decoded data: \(decodedData)", for: .info)

        return decodedData
    }
}

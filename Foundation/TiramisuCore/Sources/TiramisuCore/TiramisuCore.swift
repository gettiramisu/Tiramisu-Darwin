//
//  TiramisuCore.swift
//  TiramisuCore
//
//  Created by Alexandra Göttlicher
//

import Logger
import Observation

@Observable @MainActor public class TiramisuCore: NSObject {
    private let client: CappuccinoClient = .init()
    public let player: Player = .init()
    public let playHistories: [PlayHistory] = []
    public var stations: [Station] = []
    public var stationCountries: [StationCountry] = []
    public var stationLanguages: [StationLanguage] = []
    public var stationTags: [StationTag] = []

    public func updateStations(with parameters: StationSearchParameters, _ invalidate: Bool = false) async -> Void {
        if !invalidate && !self.stations.isEmpty {
            Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Using stations from in-memory cache", for: .info)
            return
        }
        self.stations = await client.fetchStations(with: parameters)
    }

    public func updateStationCountries(_ invalidate: Bool = false) async -> Void {
        if !invalidate && !self.stationCountries.isEmpty {
            Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Using station countries from in-memory cache", for: .info)
            return
        }
        self.stationCountries = await client.fetchStationCountries()
    }

    public func updateStationLanguages(_ invalidate: Bool = false) async -> Void {
        if !invalidate && !self.stationLanguages.isEmpty {
            Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Using station languages from in-memory cache", for: .info)
            return
        }
        self.stationLanguages = await client.fetchStationLanguages()
    }

    public func updateStationTags(_ invalidate: Bool = false) async -> Void {
        if !invalidate && !self.stationTags.isEmpty {
            Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Using station tags from in-memory cache", for: .info)
            return
        }
        self.stationTags = await client.fetchStationTags()
    }
}

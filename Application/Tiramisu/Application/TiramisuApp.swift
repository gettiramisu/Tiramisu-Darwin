//
//  TiramisuApp.swift
//  Tiramisu
//
//  Created by Alexandra Göttlicher
//

import TiramisuCore
import SwiftUI

// TODO: imeplement listening history
// TODO: permanent caching
// TODO: user interfaces (ios, ipados, macos, watchos, tvos, visionos)
// TODO: preferences (start at login, auto play on start (incl. selected station), self hosted url)
// TODO: add documention
// TODO: app icon

@main
internal struct TiramisuApp: App {
    @State private var core: TiramisuCore = .init()
    @State private var selectedCountry: StationCountry?
    @State private var selectedLanguage: StationLanguage?
    @State private var selectedTag: StationTag?

    internal var body: some Scene {
        WindowGroup {
            VStack(alignment: .leading, spacing: 0) {
                Picker("Country", selection: $selectedCountry) {
                    Text("Select a country")
                        .tag(StationCountry?.none)

                    ForEach(core.stationCountries) { country in
                        Text(country.iso31662.countryName ?? country.iso31662)
                            .tag(StationCountry?.some(country))
                    }
                }
                Picker("Language", selection: $selectedLanguage) {
                    Text("Select a language")
                        .tag(StationLanguage?.none)

                    ForEach(core.stationLanguages) { language in
                        Text(language.iso6391.languageName ?? language.iso6391)
                            .tag(StationLanguage?.some(language))
                    }
                }
                Picker("Tag", selection: $selectedTag) {
                    Text("Select a tag")
                        .tag(StationTag?.none)

                    ForEach(core.stationTags) { tag in
                        Text(tag.name.capitalized)
                            .tag(StationTag?.some(tag))
                    }
                }
            }
            .task {
                await core.updateStationCountries()
                await core.updateStationLanguages()
                await core.updateStationTags()
            }

            List(self.core.stations) { station in
                HStack {
                    VStack(alignment: .leading) {
                        Text(station.name)
                            .font(.headline)
                        Text(station.country.iso31662.countryName ?? station.country.iso31662)
                            .font(.subheadline)
                        if let languages = station.languages {
                            Text(languages.map { $0.iso6391.languageName ?? $0.iso6391 }.joined(separator: ", "))
                                .font(.caption)
                        }
                        if let tags = station.tags {
                            Text(tags.map { $0.name }.joined(separator: ", "))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    Button(action: {
                        core.player.play(station: station)
                    }) {
                        Image(systemName: "play.fill")
                    }
                }
            }
            .task {
                await core.updateStations(with: .init(country: "LU"))
            }

            Text(self.core.player.nowPlayingTitle ?? "")
            Text(self.core.player.nowPlayingArtist ?? "")
            Text(self.core.player.nowPlayingStation?.name ?? "")

            #if os(iOS)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    iPadOSMainView()
                } else {
                    iOSMainView()
                }
            #elseif os(macOS)
                macOSMainView()
            #elseif os(tvOS)
                tvOSMainView()
            #elseif os(watchOS)
                watchOSMainView()
            #elseif os(visionOS)
                visionOSMainView()
            #endif
        }
    }
}

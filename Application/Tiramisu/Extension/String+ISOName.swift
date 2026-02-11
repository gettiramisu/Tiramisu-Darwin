//
//  String+ISOName.swift
//  TiramisuCore
//
//  Created by Alexandra Göttlicher
//

import Foundation

extension String {
    /// A locale derived from the user's preferred device language.
    /// Uses `Locale.preferredLanguages` instead of `Locale.current`,
    /// because `Locale.current` may not reflect the device language
    /// if the app lacks localization files for that language.
    private static var deviceLocale: Locale {
        Locale(identifier: Locale.preferredLanguages.first ?? "en")
    }

    /// Converts an ISO 3166-1 region code (e.g. "DE") to its localized country name
    /// (e.g. "Allemagne" on a French device). Returns `nil` if the code is unrecognized.
    public var countryName: String? {
        // Self refers to the String type, accessing the static `deviceLocale` property.
        Self.deviceLocale.localizedString(forRegionCode: self)
    }

    /// Converts an ISO 639 language code (e.g. "ja") to its localized language name
    /// (e.g. "japonais" on a French device). Returns `nil` if the code is unrecognized.
    public var languageName: String? {
        Self.deviceLocale.localizedString(forLanguageCode: self)
    }
}

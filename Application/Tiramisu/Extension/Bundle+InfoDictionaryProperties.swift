//
//  Bundle+InfoDictionaryProperties.swift
//  Tiramisu
//
//  Created by Alexandra Göttlicher
//

import Foundation

extension Bundle {
    var bundleIdentifier: String? {
        return object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
    }
    
    var bundleName: String? {
        return object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    var bundleVersion: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

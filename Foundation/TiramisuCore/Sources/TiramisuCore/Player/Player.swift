//
//  Player.swift
//  TiramisuCore
//
//  Created by Alexandra Göttlicher
//

import AVFoundation
import Logger
import Observation

@Observable public class Player: NSObject {
    private let player: AVPlayer = .init()
    private var metadataObserver: StreamMetadataObserver? = nil
    public var nowPlayingTitle: String? = nil
    public var nowPlayingArtist: String? = nil
    public var nowPlayingStation: Station? = nil

    public func play(station: Station) -> Void {
        Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Starting playback for station: \(station)", for: .info)

        self.nowPlayingStation = station

        let playerItem: AVPlayerItem = .init(url: station.streamUrl)
        self.player.replaceCurrentItem(with: playerItem)
        self.player.play()

        self.metadataObserver = StreamMetadataObserver(player: self, playerItem: playerItem)
    }

    private func stop() -> Void {
        Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Stopping playback for station: \(self.nowPlayingStation!)", for: .info)

        self.player.replaceCurrentItem(with: nil)
        self.metadataObserver = nil
        self.nowPlayingTitle = nil
        self.nowPlayingArtist = nil
    }

    public func togglePlayback() -> Bool {
        self.isPlaying() ? self.stop() : self.play(station: self.nowPlayingStation!)
        return self.isPlaying()
    }

    public func isPlaying() -> Bool {
        return self.player.timeControlStatus == .playing
    }
}

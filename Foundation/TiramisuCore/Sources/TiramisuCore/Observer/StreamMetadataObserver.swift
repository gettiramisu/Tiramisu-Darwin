//
//  StreamMetadataObserver.swift
//  TiramisuCore
//
//  Created by Alexandra Göttlicher
//

import AVFoundation
import Logger

public class StreamMetadataObserver: NSObject, AVPlayerItemMetadataOutputPushDelegate {
    private let output: AVPlayerItemMetadataOutput = .init()
    private weak var player: Player?
    private weak var playerItem: AVPlayerItem?

    public init(player: Player, playerItem: AVPlayerItem) {
        super.init()

        self.player = player
        self.playerItem = playerItem
        self.output.setDelegate(self, queue: .main)

        playerItem.add(self.output)

        Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Starting observation of item: \(playerItem)", for: .info)
    }

    deinit {
        Logger.sharedInstance().logMessage("[\(String(describing: type(of: self)))] Stopping observation of item: \(self.playerItem as Any)", for: .info)
        self.playerItem?.remove(self.output)
    }

    public func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        for group in groups {
            for item in group.items where item.commonKey == .commonKeyTitle {
                Task {
                    guard let value = try? await item.load(.stringValue) else {
                        return
                    }

                    let components = value.split(separator: " - ", maxSplits: 1)
                    if components.count == 2 {
                        self.player?.nowPlayingArtist = String(components.first!)
                        self.player?.nowPlayingTitle = String(components.last!)
                    } else {
                        self.player?.nowPlayingArtist = nil
                        self.player?.nowPlayingTitle = value
                    }
                }

                return
            }
        }
    }
}

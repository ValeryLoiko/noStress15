//
//  File.swift
//  noStress15
//
//  Created by Diana on 28/02/2025.
//

import Foundation
import AVFoundation

class VideoService {
    static func createPlayer(forResource resource: String, ofType type: String) -> AVPlayer? {
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else { return nil }
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        return player
    }
}

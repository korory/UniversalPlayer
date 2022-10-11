//
//  PlayerViewModel.swift
//  UniversalPlayer
//
//  Created by Arnau Rivas Rivas on 11/10/22.
//

import Foundation

class PlayerViewModel {
    
    var audioEngine: AudioEngine = AudioEngine()
    
    func audioPlay() {
        self.audioEngine.togglePlayer()
    }
    
}

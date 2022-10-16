//
//  PlayerViewModel.swift
//  UniversalPlayer
//
//  Created by Arnau Rivas Rivas on 11/10/22.
//

import Foundation
import SwiftUI

class PlayerViewModel: ObservableObject {
    
    //MARK: - Variables
    @Published var audioEngine: AudioEngine = AudioEngine()
    @Published var dragOffsetCircle: CGSize = .zero
    @Published var playPauseTextButton: String = ""
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    //MARK: - ASSETS
    
    //Background Colors
    var backgroundColorGray = "backgroundColorGray"
    var backgroundColorDark = "backgroundColorDark"
    
    //Player Controls Assets
    var previousSongButtonAsset = "backward.end.fill"
    var playButtonAsset = "play.circle.fill"
    var pauseButtonAsset = "pause.circle.fill"
    var nextSongButtonAsset = "forward.end.fill"
    
    init() {
        playPauseTextButton = playButtonAsset
    }
    
    //MARK: - Functions
    
    func getCurrrentSongTime() -> String {
        return audioEngine.songTotalTime
    }
    
    func audioPlay() {
        self.audioEngine.togglePlayer()
        changePlayButtonApparence()
        timer.upstream.connect().cancel()
    }
    
    func changePlayButtonApparence() {
        if isPlaying() {
            playPauseTextButton = pauseButtonAsset
        } else {
            playPauseTextButton = playButtonAsset
        }
    }
    
    func isPlaying() -> Bool {
        return audioEngine.playerIsPlaying
    }
    
    func getSongTotalTime() -> String {
        return audioEngine.songTotalTime
    }
    
    func onChangeCircleCurrentTimeBar(value: DragGesture.Value) {
        if value.translation.width < 0 {
            dragOffsetCircle = CGSize(width: 0, height: value.translation.height)
        } else if value.translation.width > UIScreen.main.bounds.width - 40 {
            dragOffsetCircle = CGSize(width: UIScreen.main.bounds.width - 40, height: value.translation.height)
        }else {
            print(value.translation)
            dragOffsetCircle = value.translation
        }
    }
    
}

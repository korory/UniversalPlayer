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
    @Published var timer = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    @Published var currentSongTimePlaying: String = "00:00"

    var sliderCurentSongProgress: CGFloat = 0
    var currentSongTimerCounter: Int = 0
    
    //MARK: - ASSETS
    
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
        if value.location.x < 0 {
            dragOffsetCircle = CGSize(width: 0, height: value.translation.height)
        } else if value.location.x > UIScreen.main.bounds.width - 40 {
            dragOffsetCircle = CGSize(width: UIScreen.main.bounds.width - 40, height: value.translation.height)
        }else {
            dragOffsetCircle = CGSize(width: value.location.x, height: value.translation.height)
            sliderCurentSongProgress = dragOffsetCircle.width
        }
    }
    
    func updateTimePlaying() {
        if sliderCurentSongProgress < CGFloat(UIScreen.main.bounds.width - 40) {
            sliderCurentSongProgress += 1
            
            withAnimation(Animation.linear(duration: 0.1)) {
                dragOffsetCircle = CGSize(width: sliderCurentSongProgress, height: 1)
            }
        }
        
        //Change Current Song Timer
        if currentSongTimePlaying != getSongTotalTime() {
            currentSongTimerCounter += 1
            let timer = translateCounterToMinutesAndSeconds(counter: currentSongTimerCounter)
            self.currentSongTimePlaying = stringFromTimeInterval(minutes: timer.0, seconds: timer.1)
        }
        
    }
    
    func translateCounterToMinutesAndSeconds(counter: Int) -> (Int, Int) {
        return ((counter % 3600) / 60, ((counter % 3600) % 60))
    }
    
    func stringFromTimeInterval(minutes: Int, seconds: Int) -> String {

        let seconds = seconds % 60
        let minutes = (minutes / 60) % 60

        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
}

extension TimeInterval {
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let songTime = Int(interval)

        let seconds = songTime % 60
        let minutes = (songTime / 60) % 60

        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
}

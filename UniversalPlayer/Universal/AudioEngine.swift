//
//  AudioEngine.swift
//  UniversalPlayer
//
//  Created by Arnau Rivas Rivas on 11/10/22.
//

import AVFoundation

class AudioEngine: NSObject {
    
    //MARK: AudioEngine class extensions
    private var engine: AVAudioEngine = AVAudioEngine()
    private var sampler: AVAudioUnitSampler = AVAudioUnitSampler()
    private var distortion: AVAudioUnitDistortion = AVAudioUnitDistortion()
    private var reverb: AVAudioUnitReverb = AVAudioUnitReverb()
    private var player: AVAudioPlayerNode = AVAudioPlayerNode()
    private var sessionInstance = AVAudioSession.sharedInstance()
    
    // buffer for the player
    private var playerLoopBuffer: AVAudioPCMBuffer = AVAudioPCMBuffer()
    
    private var timeInterval: TimeInterval = TimeInterval()
    private var songURL: URL?

    
    var playerIsPlaying: Bool {
        return player.isPlaying
    }
    
    var songTotalTime = ""
        
    override init() {
        super.init()
        initAVAudioSession()
        initSongFileIntoPlayer()
        initAllComponentsToPlayer()
        createEngineAndAttachNodes()
        connectAllComponentsToTheMainMixer()
    }
    
    func initAVAudioSession() {
        // Configure the audio session
        sessionInstance = AVAudioSession.sharedInstance()
        
        //Set the session category
        do {
            try sessionInstance.setCategory(AVAudioSession.Category.playback)
        } catch let error {
            print("Error setting AVAudioSession category! \(error.localizedDescription)\n")
            
        }
        
        //Activate the audio session
        do {
            try sessionInstance.setMode(.default)
            try sessionInstance.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            print("Error setting session active! \(error.localizedDescription)\n")
        }
    }
    
    func initAllComponentsToPlayer() {
        player = AVAudioPlayerNode()
        sampler = AVAudioUnitSampler()
        distortion = AVAudioUnitDistortion()
        reverb = AVAudioUnitReverb()
    }
    
    func createEngineAndAttachNodes() {
        engine = AVAudioEngine()
        engine.attach(sampler)
        engine.attach(distortion)
        engine.attach(reverb)
        engine.attach(player)
    }
    
    func connectAllComponentsToTheMainMixer() {
        let mainMixer = engine.mainMixerNode
        let stereoFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
        let playerFormat = playerLoopBuffer.format
        
        engine.connect(player, to: reverb, format: playerFormat)
        engine.connect(reverb, to: mainMixer, fromBus: 0, toBus: 0, format: playerFormat)
        engine.connect(distortion, to: mainMixer, fromBus: 0, toBus: 2, format: stereoFormat)
        let destinationNodes = [AVAudioConnectionPoint(node: engine.mainMixerNode, bus: 1), AVAudioConnectionPoint(node: distortion, bus: 0)]
        engine.connect(sampler, to: destinationNodes, fromBus: 0, format: stereoFormat)
    }
    
    func initSongFileIntoPlayer() {
        
        do {
            songURL = Bundle.main.url(forResource: "Testing", withExtension: "mp3")
            guard let getSong = songURL else { return }
            let songFile = try AVAudioFile(forReading: getSong)
            self.songTotalTime = timeInterval.stringFromTimeInterval(interval: durationOfNodePlayer(getSong))
            playerLoopBuffer = AVAudioPCMBuffer(pcmFormat: songFile.processingFormat, frameCapacity: AVAudioFrameCount(songFile.length))!
            try songFile.read(into: playerLoopBuffer)
        } catch {
            print("Something went wrong")
        }
    }
    
    func togglePlayer() {
        if !self.playerIsPlaying {
            self.startEngine()
            self.schedulePlayerContent()
            player.play()
        } else {
            player.pause()
        }
    }
    
    private func startEngine() {
        
        if !engine.isRunning {
            do {
                try engine.start()
            } catch let error {
                fatalError("couldn't start engine, \(error.localizedDescription)")
            }
        }
    }
    
    func schedulePlayerContent() {
        player.scheduleBuffer(playerLoopBuffer, at: nil, options: .loops, completionHandler: nil)
    }
    
    func durationOfNodePlayer(_ fileUrl: URL) -> TimeInterval {
        do {
            let file = try AVAudioFile(forReading: fileUrl)
            let audioNodeFileLength = AVAudioFrameCount(file.length)
            return Double(Double(audioNodeFileLength) / 44100) //Divide by the AVSampleRateKey in the recorder settings

           } catch {

              return 0
           }

    }
    
    func getCurrentTimeSong() -> String {
        guard let getSong = songURL else { return "00:00"}
        return currentSongTime(value: durationOfNodePlayer(getSong))
    }
    
    func currentSongTime(value: TimeInterval) -> String {
        return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
    }
    
//    func test(sliderValue: CGSize) -> Double{
//        let nodetime: AVAudioTime  = self.engine.outputNode.lastRenderTime!
//        let playerTime: AVAudioTime = self.player.playerTime(forNodeTime: nodetime)!
//        let sampleRate = playerTime.sampleRate
//
//        var newsampletime = AVAudioFramePosition(sampleRate * Double(sliderValue.width))
//
//        var f: CGFloat?
//
//        if let n = NumberFormatter().number(from: getCurrentTimeSong()) {
//            f = CGFloat(truncating: n)
//        }
//
//        var length = f! - sliderValue.width
//        var framestoplay = AVAudioFrameCount(Float(playerTime.sampleRate) * Float(length))
//
//
//        return sampleRate
//
////        var newsampletime = AVAudioFramePosition(sampleRate * Double(Slider.value))
////        var length = Float(songDuration!) - Slider.value
////        var framestoplay = AVAudioFrameCount(Float(playerTime.sampleRate) * length)
//
//    }
    
//    var currentPositionInSeconds: TimeInterval {
//        var offsetTime = engine.outputNode.lastRenderTime
//        let lastRenderTime = engine.outputNode.lastRenderTime
//        let frames = lastRenderTime!.sampleTime - offsetTime!.sampleTime
//        return Double(frames) / (offsetTime?.sampleRate)!
//
////        get {
////            let lastRenderTime = engine.outputNode.lastRenderTime
////            let frames = lastRenderTime.sampleTime - offsetTime.sampleTime
////            return Double(frames) / offsetTime.sampleRate
////        }
//    }
}

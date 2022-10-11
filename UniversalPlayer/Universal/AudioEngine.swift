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
    
    var playerIsPlaying: Bool {
        return player.isPlaying
    }
    
    override init() {
        super.init()
        initAVAudioSession()
        initSongIntoPlayer()
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
        
        //Set the session Sample Rate (Record Only)
        let hwSampleRate = 44100.0
        do {
            try sessionInstance.setPreferredSampleRate(hwSampleRate)
        } catch let error {
            print("Error setting preferred sample rate! \(error.localizedDescription)\n")
        }
        
        //Set the session BufferDuration (Record Only)
        let ioBufferDuration: TimeInterval = 0.0029
        do {
            try sessionInstance.setPreferredIOBufferDuration(ioBufferDuration)
        } catch let error {
            print("Error setting preferred io buffer duration! \(error.localizedDescription)\n")
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
    
    func initSongIntoPlayer() {
        
        do {
            let songURL = Bundle.main.url(forResource: "Testing", withExtension: "mp3")!
            let songFile = try AVAudioFile(forReading: songURL)
            playerLoopBuffer = AVAudioPCMBuffer(pcmFormat: songFile.processingFormat, frameCapacity: AVAudioFrameCount(songFile.length))!
            try songFile.read(into: playerLoopBuffer)
        } catch {
            print("Something went wrong")
        }
    }
    
    func togglePlayer() {
        if !self.playerIsPlaying {
            self.startEngine()
            //self.initSongIntoPlayer()
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
}

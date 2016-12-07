//
//  SEManager.swift
//  SnowMan
//
//  Created by hiroto takashima on 2016/10/06.
//  Copyright © 2016年 hiroto takashima. All rights reserved.
//

import Foundation
import AVFoundation

class SEManager: NSObject, AVAudioPlayerDelegate {
    
    var soundArray = [AVAudioPlayer]()
    var player: AVAudioPlayer!
    
    func sePlay(soundName: String) {
        let path = NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent(soundName)
        do {
            try player = AVAudioPlayer(contentsOfURL: path)
            soundArray.append(player)
            player.delegate = self
            player.prepareToPlay()
            player.play()
        }
        catch {
            print("エラーです")
        }
    }
    
    func seStop() {
        if ( player.playing ){
            player.stop()
        }
        else{
            player.play()
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        let i: Int = soundArray.indexOf(player)!
        soundArray.removeAtIndex(i)
    }
}
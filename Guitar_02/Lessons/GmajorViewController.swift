//
//  GmajorViewController.swift
//  Guitar_02
//
//  Created by Jibran Haider on 11/05/2019.
//  Copyright © 2019 Jibran Haider. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class GmajorViewController: UIViewController {
    var musiceffect: AVAudioPlayer = AVAudioPlayer()
    
    
    @IBOutlet weak var GMajor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let musicfile = Bundle.main.path(forResource: "GMajor", ofType: "mp3")
        do{
            try musiceffect = AVAudioPlayer(contentsOf: URL(fileURLWithPath:musicfile!))
            
        }
        catch
        {
            print(Error.self)
        }
    }
    
    @IBAction func GMajor(_ sender: UIButton) {
        musiceffect.play()
    }
    
}

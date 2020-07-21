//
//  BminorViewController.swift
//  Guitar_02
//
//  Created by Jibran Haider on 11/05/2019.
//  Copyright © 2019 Jibran Haider. All rights reserved.
//

import UIKit
import AVFoundation

class BminorViewController: UIViewController {
    var musiceffect: AVAudioPlayer = AVAudioPlayer()

    @IBOutlet weak var BMinor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let musicfile = Bundle.main.path(forResource: "BMinor", ofType: "mp3")
        do{
            try musiceffect = AVAudioPlayer(contentsOf: URL(fileURLWithPath:musicfile!))
            
        }
        catch
        {
            print(Error.self)
        }
    }
    
    @IBAction func BMinor(_ sender: UIButton) {
        musiceffect.play()
    }
    
}



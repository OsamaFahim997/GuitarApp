//
//  AminorViewController.swift
//  Guitar_02
//
//  Created by Jibran Haider on 10/05/2019.
//  Copyright © 2019 Jibran Haider. All rights reserved.
//

import UIKit
import AVFoundation

class AminorViewController: UIViewController {
    
    var musiceffect: AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var AMinor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let musicfile = Bundle.main.path(forResource: "AMinor", ofType: "mp3")
        do{
            try musiceffect = AVAudioPlayer(contentsOf: URL(fileURLWithPath:musicfile!))
            
        }
        catch
        {
            print(Error.self)
        }
        
    }
    

    @IBAction func AMinor(_ sender: UIButton) {
        musiceffect.play()
    }
    
}

//
//  G#majorViewController.swift
//  Guitar_02
//
//  Created by Jibran Haider on 11/05/2019.
//  Copyright © 2019 Jibran Haider. All rights reserved.
//

import UIKit
import AVFoundation

class G_majorViewController: UIViewController {
    var musiceffect: AVAudioPlayer = AVAudioPlayer()
   // @IBOutlet weak var G_Major: UIButton!
    
    @IBAction func GMajor(_ sender: UIButton) {
        musiceffect.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let musicfile = Bundle.main.path(forResource: "G#Major", ofType: "mp3")
        do{
            try musiceffect = AVAudioPlayer(contentsOf: URL(fileURLWithPath:musicfile!))
            
        }
        catch
        {
            print(Error.self)
        }
    }
    
   // @IBAction func G_Major(_ sender: UIButton) {
     //   musiceffect.play()
   // }
    

}

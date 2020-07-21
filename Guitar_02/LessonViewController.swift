//
//  LessonViewController.swift
//  Guitar_02
//
//  Created by Jibran Haider on 17/04/2019.
//  Copyright © 2019 Jibran Haider. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController {

    @IBOutlet var imageview: UIImageView!
    @IBOutlet var Label: UILabel!
    
    @IBOutlet var backOutlet: UIButton!
    @IBOutlet var nextOutlet: UIButton!
    
    var imageInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageInt = 1
        Label.text = String("\(imageInt)/7")
        backOutlet.isEnabled = false
    }
    
    @IBAction func backButton(_ sender: Any) {
        imageInt -= 1
        Label.text = String("\(imageInt)/7")
        self.imageGallery()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        imageInt += 1
        Label.text = String("\(imageInt)/7")
        self.imageGallery()
    }
    
    func imageGallery(){
        if imageInt == 1{
            backOutlet.isEnabled = false
            imageview.image = UIImage(named: "A-Major.jpg")
        }
        if imageInt == 2{
            backOutlet.isEnabled = true
            imageview.image = UIImage(named: "B-Major.jpg")
        }
        if imageInt == 3{
            imageview.image = UIImage(named: "C-Major.jpg")
        }
        if imageInt == 4{
            imageview.image = UIImage(named: "C-Sharp.jpg")
        }
        if imageInt == 5{
            imageview.image = UIImage(named: "E-Chord.jpg")
        }
        if imageInt == 6{
            nextOutlet.isEnabled = true
            imageview.image = UIImage(named: "F-Major.jpg")
        }
        if imageInt == 7{
            nextOutlet.isEnabled = false
            imageview.image = UIImage(named: "G-Major.jpg")
        }
    }
    
    
}

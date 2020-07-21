
import UIKit
import AVFoundation
import AudioToolbox

class LessonsViewController: UIViewController {
    
    var musiceffect: AVAudioPlayer = AVAudioPlayer()
    

    @IBOutlet weak var AMajor: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let musicfile = Bundle.main.path(forResource: "AMajor", ofType: "mp3")
        do{
            try musiceffect = AVAudioPlayer(contentsOf: URL(fileURLWithPath:musicfile!))
            
        }
        catch
        {
            print(Error.self)
        }
}
    
    @IBAction func AMajor(_ sender: UIButton) {
        musiceffect.play()
    }
}

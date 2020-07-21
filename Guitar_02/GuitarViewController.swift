
import UIKit
import AVFoundation
import SQLite3
import RealmSwift

class GuitarViewController: UIViewController, AVAudioPlayerDelegate , AVAudioRecorderDelegate {
    
    let realm = try! Realm()
    @IBOutlet weak var firststring: UIButton!
    @IBOutlet weak var secondstring: UIButton!
    @IBOutlet weak var thirdstring: UIButton!
    @IBOutlet weak var fourthstring: UIButton!
    @IBOutlet weak var fifthstring: UIButton!
   

    @IBOutlet weak var nodesEntry: UITextField!
    
    @IBOutlet weak var nodesDisplay: UILabel!
    var nodesArray = [String]()
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var view9: UIView!
    @IBOutlet weak var view10: UIView!
    @IBOutlet weak var view11: UIView!
    @IBOutlet weak var view12: UIView!
    @IBOutlet weak var view13: UIView!
    @IBOutlet weak var view14: UIView!
    @IBOutlet weak var view15: UIView!
    @IBOutlet weak var view16: UIView!
    @IBOutlet weak var view17: UIView!
    @IBOutlet weak var view18: UIView!
    @IBOutlet weak var view19: UIView!
    @IBOutlet weak var view20: UIView!
    @IBOutlet weak var view21: UIView!
    @IBOutlet weak var view22: UIView!
    
    
    @IBAction func Exit(_ sender: Any) {
        showAlert2(title: "Alert!", message: "Do you want to exit?", handlerYes: {action in
            print("Action Called")
        }, handlerCancel: { actionCancel in
            print("Action Cancel Called")
        })
    }

    
    
    var recordingflag = false
    var audiorecordingstring = String()
    var db : OpaquePointer? = nil
   var player: AVAudioPlayer?
    var dbc = DbConnection()
    var tap1 = false
    
    
    
    //var soundArray1 = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T"]
    var soundArray1 = ["E3","F3","G3","A3","E","A","B#","C4","D","E2","D#","D4","E4","G#4","A#","G#4","G4","A4","B4","D#4"]
   var selectedSoundName : String = ""
    var rname = ""
    
    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var url = String()
    var num = String()
    var toneflag = false
    var url1 = URL(fileURLWithPath: "")
    var donerecording = false
    
    
    var urlArray = [URL]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Url is \(Realm.Configuration.defaultConfiguration.fileURL)")
        settingTapGesturse()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapOccured))
//        view.addGestureRecognizer(tap)
//
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOccured(_:)))
//        swipe.direction = .left
//        view.addGestureRecognizer(swipe)
        
       if let user = UserDefaults.standard.value(forKey: "number")
       {
        
        num = String(UserDefaults.standard.integer(forKey: "number") + 1)
        UserDefaults.standard.set(num, forKey: "number")
        
        }
       else{
        UserDefaults.standard.set(3, forKey: "number")
        
        }
        dbc.prepareDatafile()
        db = dbc.openDatabase()
        listfiles()
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
                }
            }
            break
        default:
            break
        }
    }
    
    func tapOccured(tap: UITapGestureRecognizer){
        print("Screen Tapped")
    }
    func swipeOccured(swipe: UITapGestureRecognizer){
        print("screen swiped")
    }
    
    
    @IBAction func recordBtn(_ sender: Any) {
        
        if let user = UserDefaults.standard.value(forKey: "number")
        {
         
         num = String(UserDefaults.standard.integer(forKey: "number") + 1)
         UserDefaults.standard.set(num, forKey: "number")
         
         }
        else{
         UserDefaults.standard.set(3, forKey: "number")
         
         }
        urlArray.removeAll()
        recordingflag = true
//        toneflag = true
        donerecording = false
        //record()
       // recordToneOnly()
        //showToast(message: "Recording")
        showAlert(title: "Alert!", message: "Do you want to record?", handlerYes: {action in
            print("Action Called")
        }, handlerCancel: { actionCancel in
            print("Action Cancel Called")
        })
        
    }
    
    
    
    func listfiles ()
    {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            print(fileURLs)
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
  
    
    
    @IBAction func playBtn(_ sender: Any) {
        
        showAlert1(title: "Alert!", message: "Do you want to Save?", handlerYes: {action in
            print("Action Called")
        }, handlerCancel: { actionCancel in
            print("Action Cancel Called")
        })
        
        //audioRecorder.stop()
        donerecording = true
        recordToneOnly(selectedUrl: url1)
        recordingflag = false
        selectedSoundName = "audioRecording"
        insert(titleC: rname as NSString, name: audiorecordingstring as NSString)
    
        
        print(audiorecordingstring)
        audiorecordingstring = ""
        playSound()
    }
  
    func recordToneOnly( selectedUrl : URL)
    {
        
        var documents: AnyObject = NSSearchPathForDirectoriesInDomains( FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)[0] as AnyObject
        var name = "myRecording"
        name.append(num)
        name.append(".caf")
        var str =  documents.appending("/\(name)")
        rname = name
        
//        var documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as! NSURL
//        var fileDestinationUrl = documentDirectoryURL.appendingPathComponent(rname)
//            print(fileDestinationUrl)
//
        var url2 = NSURL.fileURL(withPath: str as String)
        //Create audio file name URL
        let audioFilename = getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
        //Create the audio recording, and assign ourselves as the delegate
        url = url2 .absoluteString
         var extention = "wav"
//        let url1 = Bundle.main.url(forResource: selectedname, withExtension:  extention)
//        do{
//
//
//        } catch let error as NSError{
//            print(error)
//        }
        
        if recordingflag
        {
            
            
                let composition = AVMutableComposition()
                let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                
                for url in urlArray
                {
                    compositionAudioTrack!.append(url: url)
                }
                 if let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough) {
                        assetExport.outputFileType = AVFileType.wav
                        assetExport.outputURL = url2
                        assetExport.exportAsynchronously(completionHandler: {})
                    }
                
                
               // compositionAudioTrack!.append(url: url1)
                //compositionAudioTrack!.append(url: selectedUrl)
                
            
         }
    }
 
    
    func record()
    {
        
        
        if isAudioRecordingGranted {
            
            //Create the session.
            let session = AVAudioSession.sharedInstance()
            
            do {
                //Configure the session for recording and playback.
//                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                try session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                
               // (AVAudioSession.Category.playback)
                try session.setActive(true)
                //Set up a high-quality recording session.
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                
                var documents: AnyObject = NSSearchPathForDirectoriesInDomains( FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)[0] as AnyObject
                var name = "myRecording"
                name.append(num)
                name.append(".caf")
                var str =  documents.appending("/\(name)")
                rname = name
                var url2 = NSURL.fileURL(withPath: str as String)
                //Create audio file name URL
                let audioFilename = getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
                //Create the audio recording, and assign ourselves as the delegate
                url = url2 .absoluteString
                print(url)
                audioRecorder = try AVAudioRecorder(url: url2, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.record()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            }
            catch let error {
                print("Error for start audio recording: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func updateAudioMeter(timer: Timer) {
        
        if audioRecorder.isRecording {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            //recordingTimeLabel.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
  // @IBAction func notePressed(_ sender: UIButton) {
     //  selectedSoundName = soundArray[sender.tag - 1]
    //  playSound()
    //}
    
 //   @IBAction func FirstString(_ sender: UIButton) {
     //   if recordingflag
       // {
        //    audiorecordingstring.append(soundArray1[sender.tag - 1])
            
       // }
        //selectedSoundName = soundArray1[sender.tag - 1]
       // playSound()
        
    
    //}
  
    func playSound(){
    var extention = "wav"
        if selectedSoundName == "audioRecording"
        {
            let toAppendString = rname //
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var soundFileURL = documentsDirectory.appendingPathComponent(toAppendString)
            extention = "caf"
            let url = soundFileURL
            
            do{
                player = try AVAudioPlayer(contentsOf: url  )
                
                
            guard let player = player else {return}
            
            player.prepareToPlay()
            player.play()
                
        }
            catch let error as NSError{
                print(error)
            }
        }
        else
        {
        let url = Bundle.main.url(forResource: selectedSoundName, withExtension: extention)
            
        do{
           // recordToneOnly(selectedUrl: url!)
           if recordingflag
           {
            urlArray.append(url!)
            }
            player = try AVAudioPlayer(contentsOf: url! )
            guard let player = player else {return}
            
            player.prepareToPlay()
            player.play()
            
        } catch let error as NSError{
            print(error)
        }
            
        }
    }
    
    @IBAction func PlayButtonPressed(_ sender: UIButton) {
        
        let newItem = NodesData()
        newItem.name = nodesEntry.text!
        self.saveData( value: newItem)
        
        if nodesEntry.text == ""{
            nodesEntry.text = "Error"
        }
            
        else if nodesEntry.text == "E"{
            view5.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view5.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[4]
            playSound()
        }
        
        else if nodesEntry.text == "A3"{
            view4.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view4.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[3]
            playSound()
            
        }
        
        else if nodesEntry.text == "G3"{
            view3.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view3.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[2]
            playSound()
        }
        
        else if nodesEntry.text == "F3"{
            view2.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view2.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[1]
            playSound()
        }
        
        else if nodesEntry.text == "E3"{
            view1.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view1.backgroundColor = nil
                
                
            })
            
            selectedSoundName = soundArray1[0]
            playSound()
        }
        
        else if nodesEntry.text == "E2"{
            view10.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view10.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[9]
            playSound()
        }
        
        else if nodesEntry.text == "D"{
            view9.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view9.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[8]
            playSound()
        }
        
        else if nodesEntry.text == "C4"{
            view8.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view8.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[7]
            playSound()
        }
        
        else if nodesEntry.text == "B#"{
            view7.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view7.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[6]
            playSound()
        }
        
        else if nodesEntry.text == "A"{
            view6.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view6.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[5]
            playSound()
        }
        
        else if nodesEntry.text == "A#"{
            view15.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view15.backgroundColor = nil
                
            })
            selectedSoundName = soundArray1[14]
            playSound()
        }
        
        else if nodesEntry.text == "G#4"{
            view14.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view14.backgroundColor = nil
                
            })
            selectedSoundName = soundArray1[13]
            playSound()
        }
        
        else if nodesEntry.text == "E4"{
            view13.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view13.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[12]
            playSound()
        }
        
        else if nodesEntry.text == "D#"{
            view11.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view11.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[10]
            playSound()
        }
        
        else if nodesEntry.text == "D4"{
            view12.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view12.backgroundColor = nil
                
                
            })
            selectedSoundName = soundArray1[11]
            playSound()
        }
            
        else if nodesEntry.text == "D#4"{
            view20.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view20.backgroundColor = nil
                
            })
            selectedSoundName = soundArray1[19]
            playSound()
            
        }
        
        else if nodesEntry.text == "B4"{
            view19.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view19.backgroundColor = nil
                
            })
            selectedSoundName = soundArray1[18]
            playSound()
        }
        
        else if nodesEntry.text == "A4"{
            view18.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view18.backgroundColor = nil
                
            })
            selectedSoundName = soundArray1[17]
            playSound()
        }
        
        else if nodesEntry.text == "G4"{
            view17.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view17.backgroundColor = nil
                
            })
            selectedSoundName = soundArray1[16]
            playSound()
        }
        
        else if nodesEntry.text == "G#4"{
            view16.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
            UIView.animate(withDuration: 0.5, animations: {
                self.view16.backgroundColor = nil
                
            })
            selectedSoundName = soundArray1[15]
            playSound()
        }
        
        else{
            nodesEntry.text = "Error"
        }
        
        
    }
    
    func saveData( value : NodesData){
        
        do{
            try realm.write {
                realm.add(value)
                print("saved")
            }
        }catch{
            print("Error saving context \(error)")
        }
        
        
    }
    
}

extension GuitarViewController
{
    func insert(titleC:NSString , name :NSString) {
        let insertQueryStatementString = "insert into MusicString(mstring,Recording) values(?,?)"
        
        var insertStatement: OpaquePointer? = nil
        
        // 1
        if sqlite3_prepare_v2(db, insertQueryStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let title:NSString  = titleC
            let name : NSString = name
            // 2
            
            // 3
            
            sqlite3_bind_text(insertStatement, 1, title.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print( String( cString : sqlite3_errmsg(db)))
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    
    

}


extension GuitarViewController
{
    func settingTapGesturse(){
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap1(_:)))
        self.view1.addGestureRecognizer(tap1)
        
        //if tap1 {
       // Textview.text = "E3"
        //}
        
        print("Tapped")
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap2(_:)))
        self.view2.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap3(_:)))
        self.view3.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap4(_:)))
        self.view4.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap5(_:)))
        self.view5.addGestureRecognizer(tap5)
        
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap6(_:)))
        self.view6.addGestureRecognizer(tap6)
        
        let tap7 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap7(_:)))
        self.view7.addGestureRecognizer(tap7)
        
        let tap8 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap8(_:)))
        self.view8.addGestureRecognizer(tap8)
        
        let tap9 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap9(_:)))
        self.view9.addGestureRecognizer(tap9)
        
        let tap10 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap10(_:)))
        self.view10.addGestureRecognizer(tap10)
        
        let tap11 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap11(_:)))
        self.view11.addGestureRecognizer(tap11)
        
        let tap12 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap12(_:)))
        self.view12.addGestureRecognizer(tap12)
        
        let tap13 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap13(_:)))
        self.view13.addGestureRecognizer(tap13)
        
        let tap14 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap14(_:)))
        self.view14.addGestureRecognizer(tap14)
        
        let tap15 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap15(_:)))
        self.view15.addGestureRecognizer(tap15)
        
        let tap16 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap16(_:)))
        self.view16.addGestureRecognizer(tap16)
        
        let tap17 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap17(_:)))
        self.view17.addGestureRecognizer(tap17)
        
        let tap18 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap18(_:)))
        self.view18.addGestureRecognizer(tap18)
        
        let tap19 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap19(_:)))
        self.view19.addGestureRecognizer(tap19)
        
        let tap20 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap20(_:)))
        self.view20.addGestureRecognizer(tap20)
        
        ///Downwaords
       //let tap21 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handlesilde5(_:)))
       //self.view21.addGestureRecognizer(tap21)
        
       //let tap22 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handlesilde6(_:)))
       // self.view22.addGestureRecognizer(tap22)
        
        
        
        
        
        let swipeLeft1 = UISwipeGestureRecognizer(target: self, action: #selector(GuitarViewController.handlesilde1(_:)))
        swipeLeft1.direction = .left
        self.view1.addGestureRecognizer(swipeLeft1)
        
        let swipeLeft2 = UISwipeGestureRecognizer(target: self, action: #selector(GuitarViewController.handlesilde2(_:)))
        swipeLeft2.direction = .left
        self.view6.addGestureRecognizer(swipeLeft2)
        
        let swipeLeft3 = UISwipeGestureRecognizer(target: self, action: #selector(GuitarViewController.handlesilde3(_:)))
        swipeLeft3.direction = .left
        self.view11.addGestureRecognizer(swipeLeft3)
        
        let swipeLeft4 = UISwipeGestureRecognizer(target: self, action: #selector(GuitarViewController.handlesilde4(_:)))
        swipeLeft4.direction = .left
        self.view16.addGestureRecognizer(swipeLeft4)
        
        //let swipeDown5 = UISwipeGestureRecognizer(target: self, action: #selector(GuitarViewController.handlesilde5(_:)))
       // swipeDown5.direction = .down
       // self.view21.addGestureRecognizer(swipeDown5)
        
       // let swipeDown6 = UISwipeGestureRecognizer(target: self, action: #selector(GuitarViewController.handlesilde6(_:)))
       // swipeDown6.direction = .down
       // self.view22.addGestureRecognizer(swipeDown6)
        
        //view.addGestureRecognizer(swipeDown5)
       // view.addGestureRecognizer(swipeDown6)
        
   
        
        
    }
    
    func settingTapGestursee(){
        print("Hello")
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(GuitarViewController.handleTap6(_:)))
        self.view6.addGestureRecognizer(tap6)
    }
    
    @objc func handlesilde1(_ sender: UITapGestureRecognizer) {
        
        view1.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view1.backgroundColor = nil
            
        })
        
        selectedSoundName = "First slide"
        
        playSound()
        
        
    }
    
    @objc func handlesilde2(_ sender: UITapGestureRecognizer) {
        
        view6.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view6.backgroundColor = nil
            
        })
        selectedSoundName = "Second slide"
        playSound()
        print("Here")
       
    }
    
    @objc func handlesilde3(_ sender: UITapGestureRecognizer) {
        
        view11.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view11.backgroundColor = nil
            
        })
        selectedSoundName = "Third slide"
        playSound()
        print("sasasa")
        
        
        
    }
    
    @objc func handlesilde4(_ sender: UITapGestureRecognizer) {
        
        view16.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view16.backgroundColor = nil
            
        })
        selectedSoundName = "Fourth slide"
        playSound()
        
        
    }
    @objc func handlesilde5(_ sender: UITapGestureRecognizer) {
        
        view21.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view21.backgroundColor = nil
            
        })
        selectedSoundName = "Fifth slide"
        playSound()
        
        
    }
    @objc func handlesilde6(_ sender: UITapGestureRecognizer) {
        
        view22.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view22.backgroundColor = nil
            
        })
        selectedSoundName = "sixth slide"
        playSound()
        
        
    }
    
    
    
    
    
    
    @objc func handleTap1(_ sender: UITapGestureRecognizer) {
        
        print("sa")
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[0])
            
        }
        view1.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view1.backgroundColor = nil
           
            
        })
        
        selectedSoundName = soundArray1[0]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Hello1")
    }
    
    @objc func handleTap2(_ sender: UITapGestureRecognizer) {
        print("I am tapped")
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[1])
            
        }
        view2.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view2.backgroundColor = nil
           
            
        })
        selectedSoundName = soundArray1[1]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Hello11")
    }
    
    @objc func handleTap3(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[2])
            
        }
        view3.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view3.backgroundColor = nil
           
            
        })
        selectedSoundName = soundArray1[2]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Hello111")
    }
    @objc func handleTap4(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[3])
            
        }
        view4.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view4.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[3]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
    }
    
    @objc func handleTap5(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[4])
            
        }
        view5.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view5.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[4]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
    }
    
    @objc func handleTap6(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[5])
            
        }
        view6.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view6.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[5]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo1")
    }
    
    @objc func handleTap7(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[6])
            
        }
        view7.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view7.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[6]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo2")
    }
    
    
    @objc func handleTap8(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[7])
            
        }
        view8.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view8.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[7]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo3")
    }
    @objc func handleTap9(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[8])
            
        }
        view9.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view9.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[8]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo4")
    }
    
    @objc func handleTap10(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[9])
            
        }
        view10.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view10.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[9]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo5")
    }
    @objc func handleTap11(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[10])
            
        }
        view11.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view11.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[10]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo6")
    }
    @objc func handleTap12(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[11])
            
        }
        view12.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view12.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[11]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo7")
    }
    @objc func handleTap13(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[12])
            
        }
        view13.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view13.backgroundColor = nil
            
            
        })
        selectedSoundName = soundArray1[12]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo8")
    }
    @objc func handleTap14(_ sender: UITapGestureRecognizer) {
        
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[13])
            
        }
        view14.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view14.backgroundColor = nil
            
        })
        selectedSoundName = soundArray1[13]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo9")
    }
    @objc func handleTap15(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[14])
            
        }
        view15.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view15.backgroundColor = nil
            
        })
        selectedSoundName = soundArray1[14]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo10")
    }
    @objc func handleTap16(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[15])
            
        }
        view16.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view16.backgroundColor = nil
            
        })
        selectedSoundName = soundArray1[15]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo11")
    }
    @objc func handleTap17(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[16])
            
        }
        view17.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view17.backgroundColor = nil
            
        })
        selectedSoundName = soundArray1[16]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo12")
    }
    @objc func handleTap18(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[17])
            
        }
        view18.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view18.backgroundColor = nil
            
        })
        selectedSoundName = soundArray1[17]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo13")
    }
    @objc func handleTap19(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[18])
            
        }
        view19.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view19.backgroundColor = nil
            
        })
        selectedSoundName = soundArray1[18]
        playSound()
        print(selectedSoundName)
        
        nodesArray.append(selectedSoundName)
        nodesDisplay.text = ""
        for time in nodesArray{
            let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
            self.nodesDisplay.text = arr
            
        }
        print("Helllo14")
        
    }
    @objc func handleTap20(_ sender: UITapGestureRecognizer) {
        
        if recordingflag
        {
            audiorecordingstring.append(soundArray1[19])
            
        }
        view20.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        UIView.animate(withDuration: 0.5, animations: {
            self.view20.backgroundColor = nil
            
        })
        selectedSoundName = soundArray1[19]
        playSound()
        print(selectedSoundName)
    
    nodesArray.append(selectedSoundName)
    nodesDisplay.text = ""
    for time in nodesArray{
    let arr  = (self.nodesDisplay.text ?? "") + " " + String(time)
    self.nodesDisplay.text = arr
    
}
        print("Helllo15")
}
    
    
}

//
//  RecordingListViewController.swift
//  Guitar_02
//
//  Created by Abdul on 19/06/2019.
//  Copyright © 2019 Jibran Haider. All rights reserved.
//

import UIKit
import SQLite3
import AVFoundation


class RecordingListViewController: UIViewController {

    
    var frvtflag =  false
    var list = [MusicList]()
    @IBOutlet weak var tableview: UITableView!
    var urlsarry = [URL]()
    var db : OpaquePointer? = nil
    var dbc = DbConnection()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbc.prepareDatafile()
        db = dbc.openDatabase()
        if frvtflag
        {
        getrfvtList()
            
            
        }
        listfiles()
     //    var extention = "wav"
     //   let url = Bundle.main.url(forResource: "I", withExtension:  extention)
      //  do{
            
            
       // } catch let error as NSError{
       //     print(error)
       // }
        
       // let url2 = Bundle.main.url(forResource: "B", withExtension: extention)
       // do{
            
            
       // } catch let error as NSError{
       //     print(error)
       // }
        
       // var documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as! NSURL
       //     var fileDestinationUrl = documentDirectoryURL.appendingPathComponent("myRecording105.wav")
       //         print(fileDestinationUrl)
        
       // let composition = AVMutableComposition()
       // let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
       // compositionAudioTrack!.append(url: url!)
       //compositionAudioTrack!.append(url: url2!)
        
       // if let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough) {
         //   assetExport.outputFileType = AVFileType.wav
          //  assetExport.outputURL = fileDestinationUrl
          //  assetExport.exportAsynchronously(completionHandler: {})
       // }
        
        //merge(audio1:url as! NSURL, audio2: url2 as! NSURL)
        
//        let url:Any = urlsarry[0]
//        let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//        self.present(avc, animated: true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        listfiles()
        
    }
    
//   func merge(audio1: NSURL, audio2:  NSURL) {
//
//
//        var error:NSError?
//
//        var ok1 = false
//        var ok2 = false
//
//
//
//        // var documentsDirectory:String = paths[0] as! String
//
//        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
//        var composition = AVMutableComposition()
//        var compositionAudioTrack1:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
//        var compositionAudioTrack2:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
//
//        //create new file to receive data
//        var documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as! NSURL
//        var fileDestinationUrl = documentDirectoryURL.appendingPathComponent("myRecording100.wav")
//        print(fileDestinationUrl)
//
//
//        var url1 = audio1
//        var url2 = audio2
//
//
//        var avAsset1 = AVURLAsset(url: url1 as URL, options: nil)
//        var avAsset2 = AVURLAsset(url: url2 as URL, options: nil)
//
//        var tracks1 =  avAsset1.tracks(withMediaType: AVMediaType.audio)
//        var tracks2 =  avAsset2.tracks(withMediaType: AVMediaType.audio)
//
//        var assetTrack1:AVAssetTrack = tracks1[0] as! AVAssetTrack
//        var assetTrack2:AVAssetTrack = tracks2[0] as! AVAssetTrack
//
//
//        var duration1: CMTime = assetTrack1.timeRange.duration
//        var duration2: CMTime = assetTrack2.timeRange.duration
//
//        var timeRange1 = CMTimeRangeMake(start: CMTime.zero, duration: duration1)
//        var timeRange2 = CMTimeRangeMake(start: duration1, duration: duration2)
//
//
//        //        try  ok1 = compositionAudioTrack1.insertTimeRange(timeRange1,  of: assetTrack1,at: duration1)
//        //        {
//        //        if ok1 {
//        //
//        //           try  ok2 = compositionAudioTrack2.insertTimeRange(timeRange2,  of: assetTrack2, at: duration2)
//        //           {
//        //
//        //            if ok2 {
//        //                print("success")
//        //            }
//        //            }
//        //
//        //        }
//        //        }
//
//
//
//        //AVAssetExportPresetPassthrough => concatenation
//        var assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
//        assetExport!.outputFileType = AVFileType.m4a
//        assetExport!.outputURL = fileDestinationUrl
//       try   assetExport!.exportAsynchronously {
//            switch assetExport!.status{
//            case  AVAssetExportSessionStatus.failed:
//                print("failed \(assetExport?.error)")
//            case AVAssetExportSessionStatus.cancelled:
//                print("cancelled \(assetExport?.error)")
//            default:
//                print("complete")
//                var audioPlayer = AVAudioPlayer()
//                try   audioPlayer = AVAudioPlayer(contentsOf: fileDestinationUrl!, fileTypeHint: nil)
//                audioPlayer.prepareToPlay()
//                audioPlayer.play()
//
//
//
//            }
//        } as! () -> Void
//
//
//
//    }
//
    func listfiles ()
    {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
        
            if frvtflag
            {
                for b in list
                {
                    for a in fileURLs
                    {
                        var file = a.absoluteString
                        var splitfile = file.split(separator: "/")
                        if b.description == String(splitfile[splitfile.count - 1])
                        {
                            urlsarry.append(a)
                        }
                    }
                }
                
            }
            else
            {
               urlsarry = fileURLs
            }
           
            
            self.tableview.reloadData()
            print(fileURLs)
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RecordingListViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlsarry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RTableViewCell
        var url = urlsarry[indexPath.row ].absoluteString
        var name = url.split(separator: "/")
        
        
        cell.label.text = String(name[name.count - 1])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
        var url = urlsarry[indexPath.row ].absoluteString
        var name = url.split(separator: "/")
        vc.recrdingname = String(name[name.count - 1])
        vc.url = urlsarry[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    
}


extension RecordingListViewController

{
    func getrfvtList(){
        var str = [MusicList]()
        let queryStatementString = "select * from Frvt"
        var queryStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            
            while  sqlite3_step(queryStatement) == SQLITE_ROW
            {
                let c2 = sqlite3_column_text(queryStatement, 0)
                let des  = String(cString: c2!)
                
                
                let c3 = sqlite3_column_text(queryStatement, 1)
                let title  = String(cString: c3!)
                
                var mus = MusicList(title: title, description: des)
                str.append(mus)
                
                
                
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        
        list = str
        //return str
        
    }
}



extension AVMutableCompositionTrack {
    func append(url: URL) {
        let newAsset = AVURLAsset(url: url)
        let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
        let end = timeRange.end
        print(end)
        if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
            try! insertTimeRange(range, of: track, at: end)
        }
        
    }
}

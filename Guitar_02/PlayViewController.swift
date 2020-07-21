//
//  PlayViewController.swift
//  Guitar_02
//
//  Created by Abdul on 19/06/2019.
//  Copyright © 2019 Jibran Haider. All rights reserved.
//

import UIKit
import AVFoundation
import SQLite3

class PlayViewController: UIViewController {

    var db : OpaquePointer? = nil
    var dbc = DbConnection()
    var recrdingname  = String()
    var tone = String()
    var list = [MusicList]()
    var url:URL? 
    //var db = DbConnection()
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var recordingname: UILabel!
    @IBOutlet weak var recordingtone: UILabel!
     var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        dbc.prepareDatafile()
        db = dbc.openDatabase()
        getList()
          //list =  db.getList()
        if list.count > 0
        {
            for a in list{
        
        if a.description == recrdingname
        {
            label.text = a.title
            print(list)
        }
        }
        }
        recordingname.text = recrdingname
        //frvt()
        //renamefile()
       // deletefile()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func ShareBtn(_ sender: Any) {
        //let activityVC = UIActivityViewController(activityItems: [self.recordingtone.soundFileURL], applicationActivities: nil)
       // activityVC.popoverPresentationController?.sourceView = self.view
        
        //self.present(activityVC, animated: true, completion: nil)
        
        let url1:Any = url
        let avc = UIActivityViewController(activityItems: [url1], applicationActivities: nil)
        self.present(avc, animated: true)
    }
    
    
    
    
    @IBAction func shareBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Change Name", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "New Name"
 
            textField.minimumFontSize = CGFloat(bitPattern: 20)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            
            (action : UIAlertAction!) -> Void in
            
            alertController.dismiss(animated: true, completion: nil)
            
        })
         alertController.addAction(cancelAction)
        
        let OkAction = UIAlertAction(title: "Ok", style: .default, handler: {
            
            (action : UIAlertAction!) -> Void in
            
            do {
                 let name = alertController.textFields![0] as UITextField
                self.insert(titleC:"\(name.text!).caf" as NSString, name: self.label!.text as! NSString)
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let documentDirectory = URL(fileURLWithPath: path)
                
                let originPath = documentDirectory.appendingPathComponent(self.recrdingname)
                let destinationPath = documentDirectory.appendingPathComponent("\(name.text!).caf")
                try FileManager.default.moveItem(at: originPath, to: destinationPath)
            } catch {
                print(error)
            }
            
        })
        alertController.addAction(OkAction)
 
        self.present(alertController, animated: true, completion: nil)
       // sharefile()
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil
        )
    }
    
    @IBAction func playbtn(_ sender: Any) {
        var extention = "wav"
        
            let toAppendString = recrdingname //
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var soundFileURL = documentsDirectory.appendingPathComponent(toAppendString)
            extention = "caf"
            let url1 = soundFileURL
            
            do{
                player = try AVAudioPlayer(contentsOf: url1  )
                
                
                guard let player = player else {return}
                
                player.prepareToPlay()
                player.play()
            }
            catch let error as NSError{
                print(error)
            }
        }
    
    func frvt()
    {
        inserttofrvt(titleC: recrdingname as NSString, name:label!.text as! NSString )
    }
    
    func renamefile()/////////////////////////  Rename
    {
        do {
            insert(titleC:"new1.caf", name: label!.text as! NSString)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentDirectory = URL(fileURLWithPath: path)
            
            let originPath = documentDirectory.appendingPathComponent(recrdingname)
            let destinationPath = documentDirectory.appendingPathComponent("new1.caf")
            try FileManager.default.moveItem(at: originPath, to: destinationPath)
        } catch {
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func deletefile()
    {
        do {
           // insert(titleC:"new45.caf", name: label!.text as! NSString)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentDirectory = URL(fileURLWithPath: path)
            
            let originPath = documentDirectory.appendingPathComponent(recrdingname)
            
            try FileManager.default.removeItem(at: originPath)
        } catch {
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sharefile()
        
    {
        
        let url1:Any = url
        let avc = UIActivityViewController(activityItems: [url1], applicationActivities: nil)
        self.present(avc, animated: true)
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
extension PlayViewController
{
    func getList(){
        var str = [MusicList]()
        let queryStatementString = "select * from MusicString"
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
    
    func insert(titleC:NSString , name :NSString) {
        let insertQueryStatementString = "insert into MusicString(mstring,Recording) values(?,?)"
        
        var insertStatement: OpaquePointer? = nil
        
        // 1
        if sqlite3_prepare_v2(db, insertQueryStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let title:NSString  = titleC
            let nam : NSString = name
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
    
    
    func inserttofrvt(titleC:NSString , name :NSString) {
        let insertQueryStatementString = "insert into Frvt(mstring,Recording) values(?,?)"
        
        var insertStatement: OpaquePointer? = nil
        
        // 1
        if sqlite3_prepare_v2(db, insertQueryStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let title:NSString  = titleC
            let nam : NSString = name
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
    
    
    
    func getfrvtList(){
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

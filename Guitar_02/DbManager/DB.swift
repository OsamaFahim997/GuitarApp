//
//  DB.swift
//  Guitar_02
//
//  Created by Abdul on 20/06/2019.
//  Copyright © 2019 Jibran Haider. All rights reserved.
//

import Foundation
import SQLite3

struct MusicList{
    var title:String
    var description:String
}

class DbConnection{
    
    var db:OpaquePointer!
   
    
    //db configuration
    func prepareDatafile()
    {
        let docUrl=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(docUrl)
        let fdoc_url=URL(fileURLWithPath: docUrl).appendingPathComponent("MusicTones12.db")
        
        let localUrl=Bundle.main.url(forResource: "MusicTones12", withExtension: "db")
        print(localUrl?.path)
        
        let filemanager=FileManager.default
        
        if !FileManager.default.fileExists(atPath: fdoc_url.path){
            do{
                try filemanager.copyItem(atPath: (localUrl?.path)!, toPath: fdoc_url.path)
                
                print("done")
            }catch
            {
                print("error")
            }
        }
        else{
            print("already")
        }
    }
    
    //open database
    func openDatabase() -> OpaquePointer? {
        
        let docUrl=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(docUrl)
        let fdoc_url=URL(fileURLWithPath: docUrl).appendingPathComponent("MusicTones12.db")
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fdoc_url.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(fdoc_url.path)")
            
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
            return nil
        }
        
    }
    
    
    // to get reminders for reminderList
    
    
    //insert reminder
        
}

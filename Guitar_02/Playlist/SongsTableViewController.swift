//
//  ViewController.swift
//  Todoey
//
//  Created by Angela Yu on 16/11/2017.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SQLite3
import AVFoundation


class
SongsTableViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var frvtflag =  false
    var list = [MusicList]()
    var urlsarry = [URL]()
    var db : OpaquePointer? = nil
    var dbc = DbConnection()
    var stringg = ""
    var countt = 0
    var index = 0
    var categories: Results<Category>?
    
    
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedCategory?.name)
        tableView.separatorStyle = .none
        dbc.prepareDatafile()
        db = dbc.openDatabase()
        if frvtflag
        {
            // getrfvtListt()
            
            
        }
        listfiles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        listfiles()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
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
            
            
            //self.tableview.reloadData()
            print(fileURLs)
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        // navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        //        searchBar.barTintColor = navBarColour
        
    }
    
    
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countt
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RTableViewCell
        //let url = urlsarry[indexPath.row ].absoluteString
        //var name = url.split(separator: "/")
        
        //let stringgg = String(name[name.count - 1])
        let value1 = indexPath.row
        let value = 0
        print("Value is \(todoItems?.count)")
        var option = 0
        for i in value..<urlsarry.count {
            
            let url = urlsarry[i].absoluteString
            var name = url.split(separator: "/")
            let actualValue = String(name[name.count - 1])
            print("I \(i)    value \(value)  dasd \(actualValue)")
            
            for j in value1..<todoItems!.count {
                if let item = todoItems?[j] {
                    print("I \(j)    value1 \(value)  hsdajhdsahj \(todoItems![j])")
                    if item.title == actualValue{
                        cell.label.text = String(name[name.count - 1])
                        option = 1
                        break
                    }
                }
            }
            
            if option == 1{
                break
            }
            
        }
        
        //        if i < (todoItems?.count)! - 1 {
        //            if let item = todoItems?[i] {
        //
        //                if stringgg == item.title {
        //                    print("as")
        //                    //                }
        //            }
        //        }
        print("Jeaes")
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
        let url = urlsarry[indexPath.row ].absoluteString
        var name = url.split(separator: "/")
        vc.recrdingname = String(name[name.count - 1])
        vc.url = urlsarry[indexPath.row]
        print("hsadh")
        stringg = String(name[name.count - 1])
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return todoItems?.count ?? 1
    //    }
    //
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    //
    //        if let item = todoItems?[indexPath.row] {
    //
    //            cell.textLabel?.text = item.title
    //
    //        } else {
    //            cell.textLabel?.text = "No Items Added"
    //        }
    //
    //
    //
    //
    //
    //        return cell
    //    }
    //
    //    //MARK: - TableView Delegate Methods
    //
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        tableView.reloadData()
    //
    //        tableView.deselectRow(at: indexPath, animated: true)
    //
    //    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToItems2", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RecordingViewController
        
        // if let indexPath = tableView.indexPathForSelectedRow {
        print("SAJjasj is \(selectedCategory)")
        destinationVC.selectedCategory = selectedCategory
        //}
    }
    
    
    
    
    //MARK - Model Manupulation Methods
    
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        countt = (todoItems?.count)!
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    }
    
}

extension SongsTableViewController
    
{
    func getrfvtListt(){
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









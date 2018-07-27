//
//  ViewController.swift
//  LoadData
//
//  Created by Sebastian DeRossi on 2018-07-26.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import UIKit
//SD: Simple data structure used by model and to display info
struct ListItem:Decodable {
    var title:String;
    var notes:String;
}

class ViewController: UITableViewController {
    //SD: Used to hold list of ListItems
    var model = [ListItem]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.tableView.rowHeight = 80;
        //SD:Load JSON data
        loadData(file:"data");
    }
    
    func loadData(file:String) {
        //SD: Find data source
        let path = Bundle.main.path(forResource: "data", ofType: "json");
        do {
            //SD:Parse JSON file
            if let urlPath = path {
                let data = try Data(contentsOf: URL(fileURLWithPath: urlPath), options: .mappedIfSafe)
                self.model = try JSONDecoder().decode([ListItem].self, from: data);
            }else {
                return;
            }
            
        }catch {
            print("ERROR", error.localizedDescription, error);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //SD: Set up table count of visible cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count;
    }
    
    //SD: Define the cell being used within table view. Load cell information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "dataCell", for:indexPath);
        let selectedData = self.model[indexPath.row];
        cell.textLabel?.text = selectedData.title;
        return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow!;
        //SD:
        let noteViewContainer = segue.destination as! NoteViewContainer;

        let selectedData = self.model[indexPath.row];
        noteViewContainer.item = selectedData;
       
    }
}


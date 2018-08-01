//
//  ViewController.swift
//  AddItemsToUITable
//
//  Created by Sebastian DeRossi on 2018-07-26.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import UIKit

//SD: Simple data structure used by model and to display info
struct ListItem:Decodable {
    var title:String;
}

class ViewController: UITableViewController {
    
     @IBOutlet weak var AddTaskBtn: UIBarButtonItem!
    
    //SD: Used to hold list of ListItems
    var model = [ListItem]();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.rowHeight = 80;
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //SD: Handle Click event on "+" button
    //SD: This will prompt user to create a new item
    @IBAction func handleAddItem(_ sender: UIBarButtonItem) {
        let addPrompt = UIAlertController(title: "Add Item", message: "Enter new item name", preferredStyle: .alert);
        
        let submitButton = UIAlertAction(title: "Add item", style: .default, handler: {(action)-> Void in
            let textField = addPrompt.textFields![0];
            if (textField.text != "") {
                self.saveToModel(item:ListItem(title: textField.text!));
            }
        });
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: {(action)-> Void in});
        
        addPrompt.addAction(submitButton);
        addPrompt.addAction(cancelButton);
        
        addPrompt.addTextField {
            (textField: UITextField) in
            textField.keyboardAppearance = .dark;
            textField.keyboardType = .default;
            textField.autocorrectionType = .default;
            textField.placeholder = "Item name";
            textField.clearButtonMode = .whileEditing;
        }
        
        present(addPrompt, animated: true, completion: nil);
    }
    
    func saveToModel(item:ListItem) {
        self.model.append(item);
        self.tableView.reloadData();
    }


}


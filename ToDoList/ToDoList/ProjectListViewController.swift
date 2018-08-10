//
//  ProjectListViewController.swift
//  ToDoList
//
//  Created by Sebastian DeRossi on 2018-07-21.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import UIKit

protocol ProjectListDelegate : class {
    func updateModel(taskList:[Task], index:Int)
    func updateCompleteProjectList(cell:ProjectListCell, index:Int)
}

class ProjectListViewController : UITableViewController, ProjectListDelegate {
    var model = [ListItem]();
    var oldIndexPath:IndexPath?
    
    @IBOutlet weak var AddTaskBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setNav();
        setupTableView();
        
        loadData(file:"data");
    }

    //SD: Load local JSON data and parse data into the model structure
    func loadData(file:String) {
        //SD:Get path for data file
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //SD:Remove from model
            self.model.remove(at: indexPath.row);
            //SD:Update just the effect row
            self.tableView.deleteRows(at:[indexPath], with:.bottom);
        }
    }
    
    //SD: Define the cell being used within table view. Load cell information
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "projectCell", for:indexPath) as! ProjectListCell;
        let selectedData = self.model[indexPath.row];
        let tasks = selectedData.tasks;
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.message = ListMessage(title:selectedData.title, subTitle:"task count: "+String(tasks.count), isComplete:selectedData.hasComplete);
        cell.accessoryType = (selectedData.tasks.count > 0) ? .disclosureIndicator : .none;
        return cell;
    }
    
    fileprivate func setupTableView() {
        tableView.register(ProjectListCell.self, forCellReuseIdentifier: "projectCell");
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24);
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.rowHeight = 100;
    }
    
    fileprivate func setNav() {
        navigationItem.title = "Project List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 0.19, green: 0.78, blue: 0.94, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 0.19, green: 0.78, blue: 0.94, alpha: 1.0)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    //SD:Programmatically call the view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = self.tableView.indexPathForSelectedRow!;
        
        guard let tasksViewController = storyboard?.instantiateViewController(withIdentifier: "taskViewController") as? TasksViewController else {
            print("TasksViewController not found")
            return
        }
        
        let tasks = self.model[indexPath.row].tasks;
        let title = self.model[indexPath.row].title;
        tasksViewController.delegate = self;
        tasksViewController.taskList = tasks;
        tasksViewController.updateTitle(value: title);
        
        self.navigationController?.pushViewController(tasksViewController, animated: true);
    }
    
    //SD:If using story this will be the way to go.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let indexPath = self.tableView.indexPathForSelectedRow!;
        let taskViewController = segue.destination as! TasksViewController;
        //SD: Pass along my data to my new Visible view controller from the model at selected index;
        //SD: In this case we want to pass along the selected "Tasks" for a selected "Project List"
        let tasks = self.model[indexPath.row].tasks;
        let title = self.model[indexPath.row].title;
        taskViewController.delegate = self;
        taskViewController.taskList = tasks;
        taskViewController.updateTitle(value: title);
    }
    
    //SD: Handle Click event on "+" button
    //SD: This will prompt user to create a new list
    @IBAction func handleAddNewTask(_ sender: UIBarButtonItem) {
        let addPrompt = UIAlertController(title: "New List", message: "Enter new task name", preferredStyle: .alert);
        
        let submitButton = UIAlertAction(title: "Create List", style: .default, handler: {(action)-> Void in
            let textField = addPrompt.textFields![0];
            if (textField.text != "") {
                let listItem = ListItem(title: textField.text!, hasComplete:false, tasks: [])
                self.saveToModel(item:listItem);
                self.tableView.reloadData();
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
            textField.placeholder = "List Name";
            textField.clearButtonMode = .whileEditing;
        }
        
        present(addPrompt, animated: true, completion: nil);
    }
    
    func saveToModel(item:ListItem) {
        self.model.append(item);
    }
    
    
    func updateCompleteProjectList(cell:ProjectListCell, index:Int) {
        //SD:Don't move cell if already selected
        if(cell.message!.isComplete == false) {
            self.model[index].hasComplete = cell.message!.isComplete;
            return;
        }
        
        //SD:Move cell
        CATransaction.begin();
        self.tableView.beginUpdates()
        CATransaction.setCompletionBlock {
            // SD: Animation complete reload table
             self.tableView.reloadData();
        }
        self.tableView.moveRow(at:IndexPath(row: index, section: 0),to:IndexPath(row: 0, section: 0));
        
        //SD:Get selected item
        var currentItem = self.model[index];
        currentItem.hasComplete = cell.message!.isComplete;
        self.model[index].hasComplete = currentItem.hasComplete;
        //SD:Remove from list
        self.model.remove(at:index);
        //SD:Need to update project list on model
        self.model.insert(currentItem, at:0);
        //SD:Need to update there cell index
        self.tableView.endUpdates()
        CATransaction.commit();
    }
    
    func updateModel(taskList: [Task], index: Int) {
        if let selectedPath = self.tableView.indexPathForSelectedRow {
            self.model[selectedPath.row].tasks = taskList;
            self.tableView.reloadData();
            self.oldIndexPath = selectedPath;
        }else {
            if let path = self.oldIndexPath {
                self.model[path.row].tasks = taskList;
                self.tableView.reloadData();
            }
        }
         //print("SAVED MODEL", self.model);
    }
    
   
    
}


//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Sebastian DeRossi on 2018-07-23.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import Foundation
import UIKit

//SD:Need to type as class to avoid retain cycle
protocol TasksViewDelegate: class {
    func handleCompleteTask(cell:UITableViewCell);
    func handleNoteSaved(detail:Detail);
}

class TasksViewController : UITableViewController, TasksViewDelegate {
    
    @IBOutlet weak var addTaskBtn: UIBarButtonItem!
    
    weak var delegate:ProjectListDelegate?
    
    var taskList = [Task]();
    var cellId = "taskCell1";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: cellId);
        
         tableView.rowHeight = 100;
    }
    
    func updateTitle(value:String) {
        self.navigationItem.title = value;
    }
    
    func handleNoteSaved(detail:Detail) {
        let indexPath:IndexPath?;
        indexPath = self.tableView.indexPathForSelectedRow!;
        self.taskList[indexPath!.row].details = detail;
        
        delegate?.updateModel(taskList: self.taskList, index: 0);
        //SD:Need to update cell with comment icon
       tableView.reloadRows(at: [indexPath!], with: .fade);
        
    }
    
    //SD:This is a hack... will change for custom delegation
    //SD:Has been updated to work with a delegate
    func handleCompleteTask(cell:UITableViewCell) {
        let index = tableView.indexPath(for: cell);
        let task = taskList[index!.row];
        let hasComplete = task.hasComplete;
        taskList[index!.row].hasComplete = !hasComplete;
        delegate?.updateModel(taskList: taskList, index: -1);
        tableView.reloadRows(at: [index!], with: .fade);
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "taskCell1", for: indexPath) as! TaskCell;
        //SD: Get the select data from the selected Index
        let task = taskList[indexPath.row];
        
        cell.textLabel?.text = task.title;
        cell.delegate = self;
        cell.detailMessage = task.details;
        cell.accessoryView?.tintColor = task.hasComplete ? UIColor.red : .lightGray
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskList.count;
    }
    //SD:Call view via code not relaying on segue from storyboard
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = self.tableView.indexPathForSelectedRow!;
        
        guard let taskDetailView = storyboard?.instantiateViewController(withIdentifier: "taskDetail") as? TaskDetailView else {
            print("taskDetail not found")
            return
        }
        taskDetailView.delegate = self;
        let row = indexPath.row
        let selectedData = self.taskList[row];
        let details = selectedData.details;
        let title =  selectedData.title;
        let hasComplete = selectedData.hasComplete;
        taskDetailView.details = details;
        taskDetailView.updateTitle(value: title);
        taskDetailView.updateStatus(value: hasComplete);
        
        self.navigationController?.pushViewController(taskDetailView, animated: true);
    }
    @IBAction func addTaskClicked(_ sender: Any) {
        let addPrompt = UIAlertController(title: "New Task", message: "Enter new task name", preferredStyle: .alert);
        
        let submitButton = UIAlertAction(title: "Create Task", style: .default, handler: {(action)-> Void in
            let textField = addPrompt.textFields![0];
            if (textField.text != "") {
                //SD: Appending to model when it was just an array of strings;
                let format = DateFormatter();
                format.dateFormat = "MM-dd-yyyy";
                let dateStr:String = format.string(from:Date());
                self.taskList.append(Task(title: textField.text!, details: Detail(date: dateStr, notes: ""), hasComplete: false));
                self.tableView.reloadData();
                
                //SD:Save
                self.delegate?.updateModel(taskList: self.taskList, index: 1);
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
            textField.placeholder = "Task Name";
            textField.clearButtonMode = .whileEditing;
        }
        
        present(addPrompt, animated: true, completion: nil);
    }
}

//
//  TaskDetailView.swift
//  ToDoList
//
//  Created by Sebastian DeRossi on 2018-07-23.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import Foundation
import UIKit

class TaskDetailView: UIViewController {

    @IBOutlet var dateTxt: UILabel!
   
    @IBOutlet var notes: UITextView!
    
    @IBOutlet var saveBtn: UIButton!
    
    @IBOutlet var editBtn: UIButton!
    
    @IBOutlet var statusLbl: UILabel!
    
    weak var delegate:TasksViewDelegate?
    
    var details:Detail? //SD: TO-DO update to pass data correctly via didSet
    var status:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        dateTxt.text = details?.date;
        notes.text = details?.notes;
        notes.isEditable = false;
        statusLbl.text = (status) ? "Complete" : "Pending" ;
        if (status) {
            statusLbl.textColor = UIColor(red: 174/255, green: 218/255, blue: 133/255, alpha: 1.0)
        }else {
             statusLbl.textColor = UIColor(red: 4/255, green: 4/255, blue: 4/255, alpha: 1.0)
        }
        self.updateNotes();
        
        print("View did load")
    }
    
    func updateTitle(value:String) {
        self.navigationItem.title = value;
    }
    
    func updateStatus(value:Bool) {
        status = value;
    }
    
    func updateNotes() {
         notes.backgroundColor = (notes.isEditable) ? .white : .lightGray;
    }
    
    @IBAction func handleEditClicked(_ sender: Any) {
        notes.isEditable = !notes.isEditable;
        self.updateNotes();
    }
    
    @IBAction func handleSaveClicked(_ sender: Any) {
        details?.date = dateTxt.text!;
        details?.notes = notes.text!;
        delegate?.handleNoteSaved(detail: details!);
    }
    
    @objc private func handleSaveClick(_ sender: UIButton, forEvent event: UIEvent) {
        print("SAVE");
    }
}

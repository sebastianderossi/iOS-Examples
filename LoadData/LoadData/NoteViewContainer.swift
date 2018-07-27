//
//  NoteViewContainer.swift
//  LoadData
//
//  Created by Sebastian DeRossi on 2018-07-26.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import Foundation
import UIKit

class NoteViewContainer: UIViewController {
    
    @IBOutlet var noteTxt: UITextView!
    
    var item:ListItem?
        
    override func viewDidLoad() {
        super.viewDidLoad();
        //SD: Use data from ListItem struct
        if let message = item?.notes {
            noteTxt.text = message;
        }
        
        if let title = item?.title {
            //SD Appending String... just because :)
            self.navigationItem.title = title + String(" !!!");
        }
    }
}

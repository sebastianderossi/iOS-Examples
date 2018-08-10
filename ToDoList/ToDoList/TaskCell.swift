//
//  TaskCell.swift
//  ToDoList
//
//  Created by Sebastian DeRossi on 2018-07-23.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import Foundation
import UIKit

class TaskCell : UITableViewCell {
    
    //var parentRef:TasksViewController?
    weak var delegate:TasksViewDelegate?
    
    var detailMessage:Detail? {
        didSet {
            
            if let message = detailMessage?.notes {
                if (message == "" || message.count == 0) {
                    commentImage.alpha = 0;
                }else {
                    commentImage.alpha = 1;
                }
            }
        }
    }
    
    let commentImage:UIImageView = {
        let imageView = UIImageView();
        return imageView;
    }();
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier);
        
        setupViews();
    }
    
    func setupViews() {
        commentImage.image = UIImage(named:"WLConversation-bubble-down");
        contentView.addSubview(commentImage);
        contentView.addElementConstraints(format: "H:|-320-[v0(20)]", views: commentImage);
        contentView.addElementConstraints(format: "V:|-12-[v0(20)]", views: commentImage);
        
        centerElementY(item:commentImage);
        
        let checkBtn = UIButton(type: .system);
        checkBtn.setImage(#imageLiteral(resourceName: "sidebar-starred-white"), for: .normal);
        checkBtn.frame = CGRect(x:0, y:0, width:50, height:50);
        accessoryView = checkBtn;
        checkBtn.addTarget(self, action: #selector(handleIconClick), for: .touchUpInside);
        
    }

    @objc private func handleIconClick() {
        delegate?.handleCompleteTask(cell: self);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented!");
    }
}

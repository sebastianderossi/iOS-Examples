//
//  ProjectListCell.swift
//  ToDoList
//
//  Created by Sebastian DeRossi on 2018-07-25.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import Foundation
import UIKit

class ProjectListCell: UITableViewCell {

    weak var delegate:ProjectListDelegate?
    
    var index = 0;
    
    var message: ListMessage? {
        didSet {
            subTitle.text = message?.subTitle;
            title.text = message?.title;
            if let isComplete = message?.isComplete {
                if (isComplete == true) {
                    completeListBtn.setImage(#imageLiteral(resourceName: "WLDetailViewRibbon_1-2"), for: .normal)
                }else {
                    completeListBtn.setImage(#imageLiteral(resourceName: "WLDetailViewRibbon_1b"), for: .normal)
                }
            }
        }
    }
    
    let title:UILabel = {
        let titleLabel = UILabel();
        titleLabel.text = "--";
        titleLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold);
        return titleLabel;
    }()
    
    let subTitle:UILabel = {
        let subTitleLabel = UILabel();
        subTitleLabel.text = "--";
        subTitleLabel.textColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0)
        subTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light);
        return subTitleLabel;
    }()
    
    let completeListBtn:UIButton = {
        let btn = UIButton();
        btn.isEnabled = true;
        return btn;
    }();
    
    @objc private func handleClick() {
        message!.isComplete = !message!.isComplete;
        delegate?.updateCompleteProjectList(cell: self, index:self.index);
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:.subtitle, reuseIdentifier:reuseIdentifier);
        
        detailTextLabel?.textColor = .black
        detailTextLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        
         completeListBtn.addTarget(self, action: #selector(self.handleClick), for: .touchUpInside)
        setupViews();
    }
    
    func setupViews() {
        subTitle.translatesAutoresizingMaskIntoConstraints = false;
        textLabel?.removeFromSuperview();
        detailTextLabel?.removeFromSuperview();
        
        let container = UIView();
        //container.backgroundColor = .red;
        contentView.addSubview(completeListBtn);
        contentView.addSubview(container);
        
        //SD:Using extending method
        contentView.addElementConstraints(format: "H:|-12-[v0]", views: completeListBtn);
        contentView.addElementConstraints(format: "V:|-0-[v0]", views: completeListBtn);
        
        contentView.addElementConstraints(format: "H:|-82-[v0]", views: container);
        contentView.addElementConstraints(format: "V:|-12-[v0(50)]", views: container);
        
        container.addSubview(subTitle);
        container.addSubview(title);
        
        container.addElementConstraints(format: "H:|[v0]|", views: title)
        container.addElementConstraints(format: "V:|[v0][v1(24)]|", views: title, subTitle)
        container.addElementConstraints(format: "H:|[v0]|", views: subTitle)
        
        centerElementY(item:container);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented!");
    }
}

extension UIView {
    
    func centerElementY(item:UIView) {
        addConstraint(NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0));
    }
    
    func addElementConstraints(format:String, views:UIView...) {
        var viewsArr = [String: UIView]();
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsArr[key] = view;
            view.translatesAutoresizingMaskIntoConstraints = false;
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsArr));
    }
}

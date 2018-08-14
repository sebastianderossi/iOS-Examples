//
//  DataCell.swift
//  WorldCupApp
//
//  Created by Sebastian DeRossi on 2018-07-30.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import Foundation

import UIKit


class DataCell: UICollectionViewCell {
    var matches = [MatchDay]();
    
    //SD: Model supplies data for UI components
    var data: MatchDetail? {
        didSet {
            
            if let _date = data?.date {
                displayDate.text = formatDate(date:_date);
            }
            homeTeam.text = data?.team1.name;
            awayTeam.text = data?.team2.name;
            scoreDisplay.text = "\(data!.score1) : \(data!.score2)";
            
            team1Flag.image = UIImage(named: data!.team1.name);
            team2Flag.image = UIImage(named: data!.team2.name);
            
        }
    }
    //SD: Set up my UI components
    let team1Flag:UIImageView = {
        let imageView = UIImageView();
        imageView.contentMode = .scaleAspectFill;
        return imageView;
    }();
    
    let team2Flag:UIImageView = {
        let imageView = UIImageView();
        imageView.contentMode = .scaleAspectFill;
        return imageView;
    }();
    
    let title:UILabel = {
        let label = UILabel();
        label.textColor = UIColor(red: 231/255, green: 154/255, blue: 108/255, alpha: 1.0);
        label.font = UIFont(name: "MyriadPro-Bold", size: 33.0)
        return label;
    }();
    
    let homeTeam:UILabel = {
        let label = UILabel();
        label.textColor = UIColor(red: 192/255, green: 194/255, blue: 202/255, alpha: 1.0);
        label.font = UIFont(name: "MyriadPro", size: 24.0);
        return label;
    }();
    
    let awayTeam:UILabel = {
        let label = UILabel();
        label.textColor = UIColor(red: 192/255, green: 194/255, blue: 202/255, alpha: 1.0);
        label.font = UIFont(name: "MyriadPro", size: 24.0);
        return label;
    }();
    
    let scoreDisplay:UILabel = {
        let label = UILabel();
        label.font = UIFont(name: "MyriadPro-Bold", size: 54.0);
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0);
        return label;
    }()
    
    let flagView:UIView = {
        let container = UIView(frame:CGRect(x:0.0, y:0.0, width:300.0,height:10.0));
        return container
    }();
    
    let displayDate:UILabel = {
        let label = UILabel();
        label.textColor = UIColor(red: 192/255, green: 194/255, blue: 202/255, alpha: 1.0);
        label.font = UIFont(name: "MyriadPro", size: 19.0)
        return label;
    }();
    
    override init(frame: CGRect) {
        super.init(frame:frame);
        
        setupView();
    }
    
    /***
     SD:Convertion util method helps format String date value.
     SD:Example 2018-06-14 returns Thursday Jun 14, 2018
    ***/
    private func formatDate(date:String) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd";
        let convertedDate = dateFormatter.date(from: date);
        if let _date = convertedDate {
            let displayDate = DateFormatter();
            displayDate.dateFormat = "EEEE MMM d, yyyy";
            return displayDate.string(from:_date);
        }
        return date;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error creating DataCell");
    }
    
    //SD: Set up UI components
    private func setupView() {
        contentView.layer.cornerRadius = 20;
        contentView.layer.borderWidth = 0;
        
        let color = UIColor.init(red: 51/255, green: 57/255, blue: 84/255, alpha: 1.0).cgColor;
        contentView.layer.backgroundColor = color
        contentView.layer.masksToBounds = true
        
        addSubview(title);
        addSubview(displayDate);
        
        scoreDisplay.translatesAutoresizingMaskIntoConstraints = false;
        //scoreDisplay.text = "4 : 2";
        scoreDisplay.textAlignment = .center
        
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.text = "Final";
        
        flagView.translatesAutoresizingMaskIntoConstraints = false;
        displayDate.translatesAutoresizingMaskIntoConstraints = false;
        team1Flag.translatesAutoresizingMaskIntoConstraints = false;
        team2Flag.translatesAutoresizingMaskIntoConstraints = false;
        
        awayTeam.translatesAutoresizingMaskIntoConstraints = false;
        awayTeam.textAlignment = .right;
        homeTeam.translatesAutoresizingMaskIntoConstraints = false;
        homeTeam.textAlignment = .left;
        
        flagView.addSubview(team1Flag);
        flagView.addSubview(team2Flag);
        flagView.addSubview(scoreDisplay);
        flagView.addSubview(homeTeam);
        flagView.addSubview(awayTeam);
        
        addSubview(flagView);
  
        centerElementX(item: title);
        centerElementX(item: displayDate);
        
        addConstraint(NSLayoutConstraint(item: title, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 33))
        addConstraint(NSLayoutConstraint(item: displayDate, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20));
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]-10-[v1]-20-[v2]|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: ["v0":title,"v1":displayDate, "v2":flagView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-49-[v0]-40-|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: ["v0":flagView]));
        
        flagView.addElementConstraints(format: "H:|-5-[v0(50)][v1][v2(50)]|", views: team1Flag, scoreDisplay,team2Flag);
        flagView.addElementConstraints(format: "H:|[v0]-10-[v1]|", views: homeTeam, awayTeam);
        flagView.addElementConstraints(format: "V:|-10-[v0(50)][v1]|", views:team2Flag, awayTeam);
        flagView.addElementConstraints(format: "V:|-12-[v0(50)]-15-|", views:scoreDisplay);
        flagView.addElementConstraints(format: "V:|-10-[v0(50)][v1]|", views:team1Flag, homeTeam);
        
    }
}
/***
 SD: Extend all UIView. Gives all UIView types helper function for alignment purposes
 
 ***/
extension UIView {
    
    func centerElementY(item:UIView) {
        addConstraint(NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0));
    }
    
    func centerElementX(item:UIView) {
        addConstraint(NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0));
    }
    
    func addElementConstraintsWithOptions(format:String,options:[NSLayoutConstraint], views:[UIView]) {
        var viewsArr = [String: UIView]();
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsArr[key] = view;
            view.translatesAutoresizingMaskIntoConstraints = false;
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsArr));
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

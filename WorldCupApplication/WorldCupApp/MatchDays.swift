//
//  MatchDays.swift
//  WorldCupApp
//
//  Created by Sebastian DeRossi on 2018-07-30.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import Foundation
import UIKit

//SD: Could remove an place in separate file
struct ListItem:Decodable {
    var name: String;
    var rounds:[MatchDay];
}

struct MatchDay:Decodable {
    var name:String;
    var matches:[MatchDetail]?
}

struct MatchDetail:Decodable {
    var num:Int;
    var date:String;
    var time:String;
    var team1:TeamInfo;
    var team2:TeamInfo;
    var score1:Int;
    var score2:Int;
    var score1i:Int;
    var score2i:Int;
    var goals1:[GoalInfo]?;
    var goals2:[GoalInfo]?;
    var group:String?;
    var stadium:StadiumInfo;
    var city:String;
    var timezone:String;
}

struct TeamInfo:Decodable {
    var name:String;
    var code:String;
}

struct GoalInfo:Decodable {
    var name:String?;
    var minute:Int?;
    var offset:Int?;
    var score1:Int?;
    var score2:Int?;
}

struct StadiumInfo:Decodable {
    var key:String;
    var name:String;
}

class MatchDays: UITableViewController {
    
    var model = [ListItem]();
    var rounds = [MatchDay]();
    
    var cellDarkColor = UIColor(red: 30/255, green: 39/255, blue: 61/255, alpha: 1.0);
    var cellLighColor = UIColor(red: 51/255, green: 57/255, blue: 84/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let label = UILabel();
        label.text = "World Cup 2018";
        label.font = UIFont(name:"Dusha V5", size: 21.0);
        label.textColor = .white;
        self.navigationItem.titleView = label;
        
        loadData();
    }
    
    private func loadData() {
        self.model = _loadData(file:"worldcup");
        self.navigationItem.title = self.model[0].name;
        
        self.rounds = self.model[0].rounds;
    }
    
    func _loadData(file:String) -> [ListItem]{
        //SD: Find data source
        let path = Bundle.main.path(forResource: file, ofType: "json");
        
        do {
            //SD:Parse JSON file
            if let urlPath = path {
                let data = try Data(contentsOf: URL(fileURLWithPath: urlPath), options: .mappedIfSafe)
                
                return try JSONDecoder().decode([ListItem].self, from: data);
                
            }else {
                return [];
            }
            
        }catch {
            print("ERROR", error.localizedDescription, error);
        }
        return []
    }
    
    //SD: Set up table count of visible cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count;
    }
    
    //SD: Set cell row size
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    //SD: Define the cell being used within table view. Load cell information
    //SD: TODO: Break this into a cell class
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "matchCell", for:indexPath);
        let selectedData = self.rounds[indexPath.row];
        cell.textLabel?.text = selectedData.name;
        cell.textLabel?.textColor = UIColor(red: 231/255, green: 154/255, blue: 108/255, alpha: 1.0);
        cell.detailTextLabel?.textColor = UIColor(red: 192/255, green: 194/255, blue: 202/255, alpha: 1.0);
        let bg = UIView();
        bg.backgroundColor = self.cellDarkColor;
        cell.selectedBackgroundView = bg;
        let count = selectedData.matches!.count;
        cell.accessoryType = .disclosureIndicator;
        cell.detailTextLabel?.text = "Match Count( \(count))";//"Match count: (" + String(count) +")"
        return cell;
    }
    
    //SD:Add animation to each cell
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var view = cell.contentView;
        var frame = view.frame;
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseInOut, animations: {
            frame.origin.x = 500;
            view.frame = frame;
            
        }, completion: {(complete) in
            frame.origin.x = 0;
            view.frame = frame;
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow!;
        //SD:
        let matchDetails = segue.destination as! ViewController;
        
        let selectedData = self.rounds[indexPath.row];
        if let _details = selectedData.matches {
            matchDetails.rounds = _details;
        }
    }
}

//
//  ListItem.swift
//  ToDoList
//
//  Created by Sebastian DeRossi on 2018-07-22.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import Foundation

struct ListItem:Decodable {
    let title:String;
    var hasComplete:Bool;
    var tasks:[Task];
}

struct Task: Decodable {
    let title: String;
    var details:Detail;
    var hasComplete: Bool;
}

struct Detail:Decodable {
    var date:String;
    var notes:String;
}

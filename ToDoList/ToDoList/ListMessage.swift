//
//  ListMessage.swift
//  ToDoList
//
//  Created by Sebastian DeRossi on 2018-07-25.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import Foundation

struct ListMessage:Decodable {
    var title:String;
    var subTitle:String;
    var isComplete:Bool;
}

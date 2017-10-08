//
//  ToDoItem.swift
//  三鹿
//
//  Created by 魏森 on 2017/10/5.
//  Copyright © 2017年 V3. All rights reserved.
//

import UIKit
import CoreData

class ToDoItem: NSManagedObject {
    
    class func createToDoItem(with thing: String, in context: NSManagedObjectContext) -> ToDoItem {
        let toDoItem = ToDoItem(context: context)
        toDoItem.thing = thing
        return toDoItem
    }
    
}

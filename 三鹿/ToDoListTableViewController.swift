//
//  ToDoListTableViewController.swift
//  三鹿
//
//  Created by 魏森 on 2017/10/5.
//  Copyright © 2017年 V3. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: FetchedResultsTableViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        updateUI()
    }
    
    @IBOutlet weak var toDoThing: UITextField!
    
    private var thing : String? {
        return toDoThing?.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //如此在return后键盘会自动收起
        updateDatabase(with: thing!)
        updateUI()
        return true
    }
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<ToDoItem>?
    
    private func updateDatabase(with item: String) {
        container?.performBackgroundTask { [weak self] context in
            _ = ToDoItem.createToDoItem(with: item, in: context) // didn't need the return value
            try? context.save()
            self?.printDatabaseStatistics() // now it's off the main queue
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if let count = try? context.count(for: ToDoItem.fetchRequest()) { // better
                    print("count: \(count)")
                }
            }
        }
    }
    
    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
            request.sortDescriptors = []
            fetchedResultsController =  NSFetchedResultsController<ToDoItem>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            print("number: \(sections[0].numberOfObjects)") // 有问题，有时候会有迟滞
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        if let toDoItem = fetchedResultsController?.object(at: indexPath){
            cell.textLabel?.text = toDoItem.thing
        }
        
        return cell
    }
    
}

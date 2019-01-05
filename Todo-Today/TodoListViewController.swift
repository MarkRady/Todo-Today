//
//  ViewController.swift
//  Todo-Today
//
//  Created by Mark Rady on 1/5/19.
//  Copyright © 2019 Mark Rady. All rights reserved.
//

import UIKit;

class TodoListViewController: UITableViewController {
    
    //Variables
    
    let elements = ["hello1", "hello2", "hello3"];
    
    //@IBOutlet
    @IBOutlet var tableViewElement: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableViewElement.delegate = self;
        self.tableViewElement.dataSource = self;
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.elements.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let el = self.elements[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        cell.textLabel?.text = el;
        return cell;
    }
    
    //MARK - TableView delegate selected row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        }
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
////        tableView.deselectRow(at: indexPath, animated: true);
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none;
//    }
//
}


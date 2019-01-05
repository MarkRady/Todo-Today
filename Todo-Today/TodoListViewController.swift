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
    
    var todoTasks = ["hello1", "hello2", "hello3"] {
        didSet {
            self.tableViewElement.reloadData();
        }
    };
    
    //@IBOutlet
    @IBOutlet var tableViewElement: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableViewElement.delegate = self;
        self.tableViewElement.dataSource = self;
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoTasks.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let el = self.todoTasks[indexPath.row];
        
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
    }
    
    //MARK - Add new elements
    
    
    @IBAction func createTaskPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            
            self.todoTasks.append(textField.text!);
        }
        
        alert.addTextField { (localTextField) in
            localTextField.placeholder = "Add new task";
            textField = localTextField;
        }
        
        alert.addAction(action);
        self.present(alert, animated: true, completion: nil);
        
    }
    
}


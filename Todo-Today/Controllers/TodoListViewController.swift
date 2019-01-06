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
    
    var todoTasks = [TaskModel]();
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("tasks.plist");
    
//    let defaults = UserDefaults.standard;
    
    //@IBOutlet
    @IBOutlet var tableViewElement: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableViewElement.delegate = self;
        self.tableViewElement.dataSource = self;
        
        
        let newTask1 = TaskModel()
        newTask1.title = "h1";
        newTask1.isChecked = false;
        self.todoTasks.append(newTask1);
        
        let newTask2 = TaskModel()
        newTask2.title = "h1";
        newTask2.isChecked = false;
        self.todoTasks.append(newTask2);
        
        let newTask3 = TaskModel()
        newTask3.title = "h1";
        newTask3.isChecked = false;
        self.todoTasks.append(newTask3);
        
        
  
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoTasks.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = self.todoTasks[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        
        cell.textLabel?.text = task.title;
        cell.accessoryType = task.isChecked ? .checkmark : .none;
        
        return cell;
    }
    
    //MARK - TableView delegate selected row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.todoTasks[indexPath.row];
        task.isChecked = !task.isChecked;
        tableView.deselectRow(at: indexPath, animated: true);
        self.saveTasks();
    }
    
    //MARK - Add new elements
    
    
    @IBAction func createTaskPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            let newTask = TaskModel()
            newTask.title = textField.text!;
            newTask.isChecked = false;
            self.todoTasks.append(newTask);
            self.saveTasks();
//            self.defaults.set(self.todoTasks, forKey: "todoList");
            
            
        }
        
        alert.addTextField { (localTextField) in
            localTextField.placeholder = "Add new task";
            textField = localTextField;
        }
        
        alert.addAction(action);
        self.present(alert, animated: true, completion: nil);
        
    }
    
    
    func saveTasks() {
        let encoder = PropertyListEncoder();
        do {
            let data = try encoder.encode(self.todoTasks);
            try data.write(to: self.dataFilePath!);
            //                data.write(
        } catch {
            print("Error has been occured #1")
        }
        
        self.tableViewElement.reloadData();
    }
    
}


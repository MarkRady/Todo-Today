//
//  ViewController.swift
//  Todo-Today
//
//  Created by Mark Rady on 1/5/19.
//  Copyright © 2019 Mark Rady. All rights reserved.
//

import UIKit;
import CoreData;

class TodoListViewController: UITableViewController {
    
    //Variables
    
    var todoTasks = [Task]();
    
    var selectedCategory: Category? {
        didSet {
            self.loadData();
            self.title = selectedCategory!.name;
        }
    };
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("tasks.plist");
    
//    let defaults = UserDefaults.standard;
    
    //@IBOutlet
    @IBOutlet var tableViewElement: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        self.tableViewElement.delegate = self;
//        self.tableViewElement.dataSource = self;
//
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        
//        self.searchBar.delegate = self;
        self.loadData();

  
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
            let newTask = Task(context: self.context)
            newTask.title = textField.text!;
            newTask.isChecked = false;
            newTask.category = self.selectedCategory;
            self.todoTasks.append(newTask);
            self.saveTasks();
        }
        
        alert.addTextField { (localTextField) in
            localTextField.placeholder = "Add new task";
            textField = localTextField;
        }
        
        alert.addAction(action);
        self.present(alert, animated: true, completion: nil);
        
    }
    
    
    
    func loadData(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", self.selectedCategory!.name!);
        
        var predicates: [NSPredicate] = [categoryPredicate];
        
        if let searchQuery = predicate {
            predicates.append(searchQuery)
        }
        
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates);
        
        do {
            self.todoTasks = try self.context.fetch(request);
            self.tableView.reloadData();
        } catch {
            print("Error has been occured #2");
        }
        
    }
    
    
    func saveTasks() {
        do {
            try self.context.save();
        } catch {
            print("Error has been occured #1")
        }
        
        self.tableViewElement.reloadData();
    }
    
    
    
}


extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchAlgo(text: searchBar.text!);
        if searchBar.text?.count == 0 {
            self.loadData();
        }else {
            self.searchAlgo(text: searchBar.text!);
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            self.loadData();
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }else {
            self.searchAlgo(text: searchBar.text!);
        }
    }
    
    func searchAlgo(text: String){
        let request: NSFetchRequest<Task> = Task.fetchRequest();
        
        let predict = NSPredicate(format: "title CONTAINS[cd] %@", text);
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true);
        
//        request.predicate = predict;
        request.sortDescriptors = [sortDescriptor];
        self.loadData(with: request, predicate: predict);
    }
}

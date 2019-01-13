//
//  TaskCategoriesViewController.swift
//  Todo-Today
//
//  Created by Mark Rady on 1/10/19.
//  Copyright © 2019 Mark Rady. All rights reserved.
//

import UIKit
import CoreData;

class TaskCategoriesViewController: UITableViewController {
    
    var categories = [Category]();
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    @IBOutlet var categoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.categoryTableView.delegate = self;
        self.categoryTableView.dataSource = self;
        
        self.loadData();
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = self.categories[indexPath.row];
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = category.name;

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goTasks", sender: self);
    }

    @IBAction func createBtnPressed(_ sender: UIBarButtonItem) {
        
        var customTextField = UITextField();
        
        let alert = UIAlertController(title: "Add category", message: "Enter category name", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context);
            newCategory.name = customTextField.text ?? "testp";
            self.categories.append(newCategory);
            self.saveCategories();
            print(self.categories.count);
            
        }
        
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Enter category name";
            customTextField = categoryTextField;
        }
        
        alert.addAction(action);
        self.present(alert, animated: true, completion: nil);
        
    }
    
    
    func saveCategories() {
        do {
            try self.context.save();
        } catch {
            print("error number #2");
        }
        self.categoryTableView.reloadData();
    }
    

    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            self.categories = try self.context.fetch(request);
            self.categoryTableView.reloadData();
        } catch {
            print("Error number #3");
        }
    }
    

}
// handle redirection
extension TaskCategoriesViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController;
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categories[indexPath.row];
        }
    }
}

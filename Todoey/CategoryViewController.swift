//
//  CategoryViewController.swift
//  Todoey
//
//  VISHAL.K.CHANCHLANI
//  301090878
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var array = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.rowHeight = 70
        loadItems()
    }

    
    @IBAction func addbuttonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController(title: "Add new TASK", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new", style: .default) { (action) in
            let newItem = Category(context: self.context)
            newItem.name = textFeild.text
            self.array.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new Task "
            textFeild = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - TableView dataSource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = array[indexPath.row]
        }
    }
    //MARK: - Data manipultion methods
    func loadItems() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            try array = context.fetch(request)
        }
        catch{
            print("Error fetching contents \(error)")
        }
        tableView.reloadData()
    }
    func saveItems() {
        do{
            try context.save()
        }catch{
            print("Error saving data \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            array.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
}

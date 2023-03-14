//
//  ViewController.swift
//  FoodListApp
//
//  Created by Mohit Sharma on 12/03/23.
//

import UIKit

class FoodViewController: UIViewController {

    @IBOutlet weak var foodItemsTableView: UITableView!
    
    var foodListArray = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configuration()
    }

    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        self.foodConfiguration(isAdd: true)
    }
    
}

extension FoodViewController{
    
    func configuration(){
        self.foodItemsTableView.dataSource = self
        self.foodItemsTableView.delegate = self
        self.foodItemsTableView.isEditing = true
        foodItemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "foodCell")
        foodListArray = DatabaseHelper.shared.getAllFooditems()
    }
    
    func foodConfiguration(isAdd: Bool, index: Int = 0){
        
        let alertController = UIAlertController(title: isAdd ? "Add Food" : "Update Food", message: isAdd ? "Please enter food name & its type." : "Please update food name & its type.", preferredStyle: .alert)
        let save = UIAlertAction(title: isAdd ? "Save" : "Update", style: .default){ _ in
            if let foodname = alertController.textFields?.first?.text,
               let subtitleDetails = alertController.textFields?[1].text{
                print(foodname, subtitleDetails)
                let foodDetails = Food(foodName: foodname, subtitle: subtitleDetails)
                
                if isAdd {
                    self.foodListArray.append(foodDetails)
                    DatabaseHelper.shared.saveFoodDetails(foodItem: foodDetails)
                }else{
//                    self.foodListArray[index] = foodDetails
                    DatabaseHelper.shared.updateDetails(oldDetails: self.foodListArray[index], newDetails: foodDetails)
                }
                self.foodItemsTableView.reloadData()
            }
            
            }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        
        alertController.addTextField { foodnameField in

            foodnameField.placeholder = isAdd ? "Enter food item name" : self.foodListArray[index].foodName
        }
        alertController.addTextField { typenameField in

            typenameField.placeholder = isAdd ? "Enter food type" : self.foodListArray[index].subtitle
        }
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)

        
    }
}

extension FoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") else{
            return UITableViewCell()
        }
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "foodCell")
        cell.textLabel?.text = foodListArray[indexPath.row].foodName
        cell.detailTextLabel?.text = foodListArray[indexPath.row].subtitle
        
        
        return cell
    }
}

extension FoodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.foodConfiguration(isAdd: false, index: indexPath.row)
                
        }
        edit.backgroundColor = .systemYellow
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            DatabaseHelper.shared.deleteFoodDetail(foodItem: self.foodListArray[indexPath.row])
            self.foodListArray.remove(at: indexPath.row)
            self.foodItemsTableView.reloadData()
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit,delete])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        self.foodListArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        let selectedPathData = self.foodListArray[sourceIndexPath.row]
        let destinationPath = self.foodListArray[destinationIndexPath.row]
        let dict1:[String:Any] = ["foodName":selectedPathData.foodName, "subtitle":selectedPathData.subtitle]
        let dict2:[String:Any] = ["foodName":destinationPath.foodName, "subtitle":destinationPath.subtitle]

        DatabaseHelper.shared.updateRow(destinationPath, with: dict1)
        
        DatabaseHelper.shared.updateRow(selectedPathData, with: dict2)
        
        self.foodItemsTableView.reloadData()
    }
}

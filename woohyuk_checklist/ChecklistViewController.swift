//
//  ViewController.swift
//  woohyuk_checklist
//
//  Created by user on 01/04/2019.
//  Copyright © 2019 woohyuk. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate{
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder){
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item.text = "Wwwwwwalk the dog"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = true
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = true
        items.append(row4item)
        
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        return items.count
    }

    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked{
            label.text = "√"
        }
        else{
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item:ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text=item.text
    }
    
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",for: indexPath)
       /* let label = cell.viewWithTag(1000) as! UILabel
        if indexPath.row % 5 == 0 {
            label.text = "Walk the dog"
        } else if indexPath.row % 5 == 1 {
            label.text = "Brush my teeth"
        } else if indexPath.row % 5 == 2 {
            label.text = "Learn iOS development"
        } else if indexPath.row % 5 == 3 {
            label.text = "Soccer practice"
        } else if indexPath.row % 5 == 4 {
            label.text = "Eat ice cream"
        }*/
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            /*if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }*/
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
        
    }
    /*@IBAction func addItem(){
        let newRowIndex = items.count
        
        let item = ChecklistItem()
        item.text = "I am a new row"
        item.checked = false
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }*/
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths,with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistItem){
        if let index = items.firstIndex(of:item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at:indexPath){
                configureText(for: cell,with: item)
            }
        }
        navigationController?.popViewController(animated:true)
        
        saveChecklistItems()
    }
    
    /*delete Row*/
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveChecklistItems()
    }
    
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController){
        navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem"{
            let controller =  segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    /* File I/O*/
    func documentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL{
        return documentsDirectory().appendingPathComponent("woohyuk_checklists.plist")
    }
    /*Saving the file*/
    func saveChecklistItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch{
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    /*Loading the file*/
    func loadChecklistItems(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do{
                items = try decoder.decode([ChecklistItem].self,from: data)
            }
            catch{
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}



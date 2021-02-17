//
//  CheckUpViewController.swift
//  ZotCovidCare
//
//  Created by Susie Liu on 2/3/21.
//

import UIKit

class CheckUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    let symptoms = ["Fever","Cough","Breathing Difficulty","Loss of Smell/Taste","Headache","Diarrhea","Muscle Pain","None"]

    //initialize cells based on number of symptoms
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return symptoms.count
    }
    //fill each cell with corresponding value of array index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = symptoms[indexPath.row]
        return cell
    }
    
    //when cell is tapped, place checkmark if cell is unchecked, remove checkmark if cell is checked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
    }
    
    

    @IBOutlet var field: UITextField!
    public var completionHandler: ((String?)->Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func didTapSubmit(){
        completionHandler?(field.text)
        dismiss(animated: true, completion: nil)
    }
    
}

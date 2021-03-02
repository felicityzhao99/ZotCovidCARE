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
    

    @IBOutlet var field: UITextField!
    public var completionHandler: ((String?,[Int]?)->Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func didTapSubmit(){
        var arr:[Int] = []
        let cells = self.tableView.visibleCells
        
        for cell in cells {
            if cell.accessoryType.rawValue > 0{
                arr.append(1)
            }
            else{
                arr.append(0)
            }
        }
        
        completionHandler?(field.text, arr)
        dismiss(animated: true, completion: nil)
    }
    
}

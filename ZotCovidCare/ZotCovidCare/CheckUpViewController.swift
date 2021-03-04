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
    public var completionHandler: ((String?,[Int]?)->Void)?
    //dict which records config.json whether to determine whether darkmode is on/off
    var config = ["darkmode" : 0, "notification" : 0]
    
    @IBOutlet weak var symptomCheck: UILabel!
    @IBOutlet weak var temperatureCheck: UILabel!
    @IBOutlet weak var submit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeInitialization()
        tableView.delegate = self
        tableView.dataSource = self
    }
    //For reading config json whether to determine whether darkmode is on/off
    func darkModeInitialization()
    {
        guard let path = Bundle.main.path(forResource: "config", ofType: "json") else {return}

        let url = URL(fileURLWithPath: path)
        
        do {
            
            let data = try Data(contentsOf: url)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictFromJSON = jsonData as? [String : Int]{
                config["darkmode"] = dictFromJSON["darkmode"]
                config["notification"] = dictFromJSON["notification"]
            } else {
                print("json convert fail\n")
            }
            if config["darkmode"] == 1{
                setBlack()
            }else{
                setWhite()
            }
            return
        } catch {}
    }
    
    func setBlack()
    {
        view.backgroundColor = UIColor.darkGray
        submit.setTitleColor(UIColor.white, for: .normal)
        temperatureCheck.textColor = UIColor.white
        symptomCheck.textColor = UIColor.white
        tableView.backgroundColor = UIColor(red:0.36078431370000003, green:0.38823529410000002, blue:0.4039215686, alpha:1.0)
        let cells = tableView.visibleCells
        for cell in cells{
            cell.accessoryView?.backgroundColor = UIColor.green
        }
    }
    func setWhite()
    {
        view.backgroundColor = UIColor.white
        submit.setTitleColor(UIColor.blue, for: .normal)
        temperatureCheck.textColor = UIColor.black
        view.backgroundColor = UIColor(red:0.5, green:0.71397772293849049, blue:0.75263522360999191, alpha:1.0)
        symptomCheck.textColor = UIColor.black
    }
    
    //Keep checking Dark mode status even if this page doesn't receive any user actions.
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        darkModeInitialization()
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
        darkModeInitialization()
        dismiss(animated: true, completion: nil)
    }
    
}

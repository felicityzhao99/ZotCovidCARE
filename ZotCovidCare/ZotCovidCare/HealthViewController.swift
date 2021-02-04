//
//  HealthViewController.swift
//  ZotCovidCare
//
//  Created by Susie Liu on 2/3/21.
//

import UIKit

class HealthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableViewHealth: UITableView!
    let healthArr = ["Sleep", "Workout", "Mood"]
    
    func tableView(_ tableViewHealth: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthArr.count
    }
    
    func tableView(_ tableViewHealth: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellHealth = tableViewHealth.dequeueReusableCell(withIdentifier: "cellHealth", for: indexPath)
        cellHealth.textLabel?.text = healthArr[indexPath.row]
        return cellHealth
    }

    
    

    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewHealth.delegate = self
        tableViewHealth.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapButtonCheckUp(){
        let vcCheckup = storyboard?.instantiateViewController(identifier: "checkup") as! CheckUpViewController
        vcCheckup.modalPresentationStyle = .fullScreen
        vcCheckup.completionHandler = { text in
            self.label.text = "temperature: " + text!
        }
        present(vcCheckup,animated: true)
        
    }
}

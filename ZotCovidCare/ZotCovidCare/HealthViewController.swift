//
//  HealthViewController.swift
//  ZotCovidCare
//
//  Created by Susie Liu on 2/3/21.
//
import UIKit
import HealthKit

//struct ContentView: View{
//    private var healthStore: HealthStore?
//    init(){
//        healthStore = HealthStore()
//    }
//}

let healthKitStore:HKHealthStore = HKHealthStore()

class HealthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableViewHealth: UITableView!
    
    
    let healthArr = ["Sleep", "Steps", "Exercise Minutes"]
    
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
        vcCheckup.completionHandler = { text,arr in
//            self.label.text = "Temperature: " + text! + "°F\nSymptoms: Fever, Cough\nRisk: High Risk\n\nSuggestion:\n1.Take a fever reducer.\n2.Drink warm beverages, Breathe in steam.\n\nClosest Testing Center:\n3850 Barranca Pkwy KL, Irvine, CA 92606"
//            self.label.text = "Temperature: " + text! + "°F\nSymptoms: None\nRisk: Low Risk\n\nSuggestion:\n1.Stay home and keep 6ft from others" + String(arr![0])
            let symptoms = ["Fever","Cough","Breathing Difficulty","Loss of Smell/Taste","Headache","Diarrhea","Muscle Pain","None"]

            let a = String(arr![0])
            let b = String(arr![1])
            let c = String(arr![2])
            let d = String(arr![3])
            let e = String(arr![4])
            let f = String(arr![5])
            let g = String(arr![6])
            let h = String(arr![7])
            
            
            
            self.label.text = "Temperature: " + text! + "°F\nSymptoms: None\nRisk: Low Risk\n\nSuggestion:\n1.Stay home and keep 6ft from others\n" + a + b + c + d + e + f + g + h
            
            self.label.textAlignment = .left
            self.label.textColor = .systemGreen
            
        }
        present(vcCheckup,animated: true)
        
    }
    
    
    
    
}

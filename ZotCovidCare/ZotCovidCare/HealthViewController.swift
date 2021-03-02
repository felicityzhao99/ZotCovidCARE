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
    
    
    
    
    /*functions for recommendation system*/
    let symptomsName = ["Fever","Cough","Breathing Difficulty","Loss of Smell/Taste","Headache","Diarrhea","Muscle Pain","None"]
    
    
    //TODO: need to add personal model and health data as parameter
    
    //TODO: if we have time, add activities checklist
    //www.texmed.org/uploadedFiles/Current/2016_Public_Health/Infectious_Diseases/309193%20Risk%20Assessment%20Chart%20V2_FINAL.pdf
    
    func predictRisk(temperature: String, symptoms: [Int])-> Int{
        //TODO: add Fahrenheit vs Celsius check
        let floatTemp = Float(temperature)
        
        //high risk
        if (floatTemp!>=100 && symptoms[1]==1 && symptoms[2]==1 && symptoms[3]==1){
            return 1
        }
        //medium risk
        else if (floatTemp!>=100 || symptoms[0]==1 || symptoms[1]==1 || symptoms[2]==1 || symptoms[3]==1 || symptoms[4]==1 || symptoms[5]==1 || symptoms[6]==1){
            return 2
        }
        //low risk
        else{
            return 3
        }
        
        
    }
    
    func giveSuggestion(symptoms: [Int], risk: Int)-> String{
        
        
        
        return ""
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
            
            //default text setting
            self.label.textAlignment = .left
            
            //predict risk, set text color according to risk
            let risk = self.predictRisk(temperature: text!, symptoms: arr!)
            if (risk==1){
                self.label.textColor = .systemRed
            }
            else if (risk==2){
                self.label.textColor = .systemYellow
            }
            else if (risk==3){
                self.label.textColor = .systemGreen
            }
            
            
            
            
            
            
//            self.label.text = "Temperature: " + text! + "°F\nSymptoms: Fever, Cough\nRisk: High Risk\n\nSuggestion:\n1.Take a fever reducer.\n2.Drink warm beverages, Breathe in steam.\n\nClosest Testing Center:\n3850 Barranca Pkwy KL, Irvine, CA 92606"
//            self.label.text = "Temperature: " + text! + "°F\nSymptoms: None\nRisk: Low Risk\n\nSuggestion:\n1.Stay home and keep 6ft from others" + String(arr![0])
            

            let a = String(arr![0])
            let b = String(arr![1])
            let c = String(arr![2])
            let d = String(arr![3])
            let e = String(arr![4])
            let f = String(arr![5])
            let g = String(arr![6])
            let h = String(arr![7])
            
            
            
            self.label.text = "Temperature: " + text! + "°F\nSymptoms: None\nRisk: Low Risk\n\nSuggestion:\n1.Stay home and keep 6ft from others\n" + a + b + c + d + e + f + g + h
            
            
            
        }
        present(vcCheckup,animated: true)
        
    }
    
    
    
    
}

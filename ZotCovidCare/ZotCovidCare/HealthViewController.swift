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
    @IBOutlet weak var checkUp: UILabel!
    @IBOutlet weak var healthData: UILabel!
    @IBOutlet weak var newCheckup: UIButton!
    //dict which records config.json whether to determine whether darkmode is on/off
    var config = ["darkmode" : 0, "notification" : 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewHealth.delegate = self
        tableViewHealth.dataSource = self

        // Do any additional setup after loading the view.
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
        checkUp.textColor = UIColor.white
        healthData.textColor = UIColor.white
        newCheckup.setTitleColor(UIColor.cyan, for: .normal)
    }
    
    func setWhite()
    {
        view.backgroundColor = UIColor.white
        checkUp.textColor = UIColor.black
        healthData.textColor = UIColor.black
        newCheckup.setTitleColor(UIColor.cyan, for: .normal)
    }
    
    //Keep checking Dark mode status even if this page doesn't receive any user actions.
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        darkModeInitialization()
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
        darkModeInitialization()
        present(vcCheckup,animated: true)
        
    }
    
    
    
    
}

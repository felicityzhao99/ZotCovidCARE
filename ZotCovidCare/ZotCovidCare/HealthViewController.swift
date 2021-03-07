//
//  HealthViewController.swift
//  ZotCovidCare
//
//  Created by Susie Liu on 2/3/21.
//
import UIKit
import HealthKit



class HealthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewHealth.delegate = self
        tableViewHealth.dataSource = self
        darkModeInitialization()
        authorizeHealthKit()
    }
    

    let healthStore = HKHealthStore()
    //global variable to store health information retrieved, used later in tableview
    var sleep = ""
    var steps = ""
    var exercise = ""
    
    // healthkit authorization
    func authorizeHealthKit(){
        let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!,
                        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
                        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
                        HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                        HKObjectType.characteristicType(forIdentifier: .biologicalSex)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!,
                         HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
                         HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        
        healthStore.requestAuthorization(toShare: share, read: read) {(chk,error) in
            if (chk){
                print("permission granted")

                self.getSteps { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        self.steps = String(stepCount) + " steps"
                        //reload table view to display newest health info
                        self.tableViewHealth.reloadData()
                    }
                }
                self.getExerciseMinutes{ (result) in
                    DispatchQueue.main.async {
                        let exerciseMinutes = Double(result)
                        self.exercise = String(exerciseMinutes) + " minutes"
                        //reload table view to display newest health info
                        self.tableViewHealth.reloadData()
                    }
                }
                
                
            }
        }
    }
    
    
    func getSteps(completion: @escaping (Double) -> Void){
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

        // get the start of the day
        let date = Date()
        let startDate = Calendar.current.startOfDay(for: date)

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(
            quantityType: stepsCount!,
            quantitySamplePredicate: predicate,
            options: [.cumulativeSum],
            anchorDate: startDate as Date,
            intervalComponents:interval
        )

        query.initialResultsHandler = { query, results, error in
            if error != nil { // handle error
                return
            }

            if let sum = results{
                sum.enumerateStatistics(from: startDate, to: date) {
                    statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let steps = quantity.doubleValue(for: HKUnit.count())//count is unit for steps
                        print("Steps = \(steps)")
                        completion(steps)
                    }
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func getExerciseMinutes(completion: @escaping (Double) -> Void){
        let exerciseMinutes = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)

        // get the start of the day
        let date = Date()
        let startDate = Calendar.current.startOfDay(for: date)

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(
            quantityType: exerciseMinutes!,
            quantitySamplePredicate: predicate,
            options: [.cumulativeSum],
            anchorDate: startDate as Date,
            intervalComponents:interval
        )

        query.initialResultsHandler = { query, results, error in
            if error != nil { // handle error
                return
            }

            if let sum = results{
                sum.enumerateStatistics(from: startDate, to: date) {
                    statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let steps = quantity.doubleValue(for: HKUnit.minute()) //minute is unit for exercise minutes
                        print("Steps = \(steps)")
                        completion(steps)
                    }
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    
    
    // health tableview
    
    @IBOutlet var tableViewHealth: UITableView!
   
    let healthArr = ["Sleep", "Steps", "Exercise Minutes"]
    
    func tableView(_ tableViewHealth: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthArr.count
    }
    
    func tableView(_ tableViewHealth: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellHealth = tableViewHealth.dequeueReusableCell(withIdentifier: "cellHealth", for: indexPath)
        if (indexPath.row==0){
            cellHealth.textLabel?.text = healthArr[indexPath.row] + ": " + self.sleep
            return cellHealth
        }
        else if (indexPath.row==1){
            cellHealth.textLabel?.text = healthArr[indexPath.row] + ": " + self.steps
            return cellHealth
        }
        else{
            cellHealth.textLabel?.text = healthArr[indexPath.row] + ": " + self.exercise
            return cellHealth
        }
        
        
    }
    
    
    
    
    
    
    
    /*functions for recommendation system*/
    
    
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
    
    
    //example: "Temperature: " + text! + "°F\nSymptoms: Fever, Cough\nRisk: High Risk\n\nSuggestion:\n1.Take a fever reducer.\n2.Drink warm beverages, Breathe in steam.\n\nClosest Testing Center:\n3850 Barranca Pkwy KL, Irvine, CA 92606"

    func giveSuggestion(temperature: String, symptoms: [Int], risk: Int)-> String{
        let symptomsName = ["Fever",
                            "Cough",
                            "Breathing Difficulty",
                            "Loss of Smell/Taste",
                            "Headache",
                            "Diarrhea",
                            "Muscle Pain",
                            "None"]
        //www.umms.org/coronavirus/what-to-know/treat-covid-at-home
        //www.medicalnewstoday.com/articles/coronavirus-home-remedies#is-home-treatment-effective
        let suggestions = ["Take a fever reducer.",
                           "Drink warm beverages throughout the day.",
                           "Take slow breaths, Try meditation.",
                           "Sniff prescribed odors if possible.",
                           "Get enough sleep, Take pain reliever if necessary.",
                           "Drink more water, Avoid fatty or fried foods.",
                           "Stretch, Use ice pack, Take pain reliever if necessary.",
                           "Wash hands often, Keep 6ft away from others."]
        
        var output = ""
        var symptomText = ""
        var suggestionText = ""
        var i = 0;
        var num = 1;
        
        //add temperature to output
        //TODO: add Fahrenheit vs Celsius check
        output += "Temperature: " + temperature + "°F" + "\n"
        
        //loop through all symptoms, if symptom==1, add to symptoms and add Corresponding Suggestion
        for (i, symptom) in symptoms.enumerated(){
            if(symptom == 1){
                if (num != 1){
                    symptomText += ", "
                    suggestionText += "\n"
                }
                symptomText += symptomsName[i]
                suggestionText += String(num) + ". " + suggestions[i]
                num+=1
            }
        }
        
        //combine symptom to output
        output += "Symptoms: " + symptomText + "\n\n"
        
        //add risk
        if (risk==1){
            output += "Risk: HIGH RISK\n"
        }
        else if (risk==2){
            output += "Risk: Medium Risk\n"
        }
        else if (risk==3){
            output += "Risk: Low Risk\n"
        }
        
        //combine suggestion to output
        output += "Suggestions:\n" + suggestionText + "\n\n"
        
        return output
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
            
            
            //give recommendation
            self.label.text = self.giveSuggestion(temperature: text!, symptoms: arr!, risk: risk)
            
            
            
        }
        darkModeInitialization()
        present(vcCheckup,animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //dark mode
    @IBOutlet var label: UILabel!
    @IBOutlet weak var checkUp: UILabel!
    @IBOutlet weak var healthData: UILabel!
    @IBOutlet weak var newCheckup: UIButton!
    //dict which records config.json whether to determine whether darkmode is on/off
    var config = ["darkmode" : 0, "notification" : 0]
    

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
    
    
    
    
}

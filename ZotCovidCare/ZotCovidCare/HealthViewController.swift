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
    var sleep = "0"
    var steps = "0"
    var distance = "0"
    var age = ""
    var sex = ""
    
    var tempMode = 0
    
    // healthkit authorization
    func authorizeHealthKit(){
        let read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!,
                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
                        HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                        HKObjectType.characteristicType(forIdentifier: .biologicalSex)!])
        
        healthStore.requestAuthorization(toShare: nil, read: read) {(chk,error) in
            if (chk){
                print("permission granted")
                self.buildPersonalModel()

                self.getSteps { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        self.steps = String(stepCount)
                        //reload table view to display newest health info
                        self.tableViewHealth.reloadData()
                    }
                }
                self.getDistance{ (result) in
                    DispatchQueue.main.async {
                        let distanceWR = Double(result)
                        self.distance = String(distanceWR)
                        //reload table view to display newest health info
                        self.tableViewHealth.reloadData()
                    }
                }
                self.getSleep{ (result) in
                    DispatchQueue.main.async {
                        self.sleep = String(Double(result))
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
            if (error != nil) { // handle error
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
    
    func getDistance(completion: @escaping (Double) -> Void){
        let distance = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)

        // get the start of the day
        let date = Date()
        let startDate = Calendar.current.startOfDay(for: date)

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(
            quantityType: distance!,
            quantitySamplePredicate: predicate,
            options: [.cumulativeSum],
            anchorDate: startDate as Date,
            intervalComponents:interval
        )

        query.initialResultsHandler = { query, results, error in
            if (error != nil) { // handle error
                return
            }

            if let sum = results{
                sum.enumerateStatistics(from: startDate, to: date) {
                    statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let d = quantity.doubleValue(for: HKUnit.mile()) //mile is unit for distance
                        print("Distance = \(d)")
                        completion(d)
                    }
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func getSleep(completion: @escaping (Double) -> Void){
        guard let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else {
            return }

        let endDate = Date() //today
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) //start from the last day

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)//sorted from latest to earliest

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) {
                        (query, samples, error) in
                guard error == nil, samples == samples as? [HKCategorySample] else {
                    return
            }
            //if no sleep data is available
            if samples!.count == 0{
                return
            }
            //get the last sleep data
//            let hours = samples![0].endDate.timeIntervalSince(samples![0].startDate) / 60 / 60
            let seconds = samples![0].endDate.timeIntervalSince(samples![0].startDate)
            print("Sleep = \(seconds)")
            completion(seconds)

        }
        healthStore.execute(query)
    }
    
    func buildPersonalModel() {
        // Biological Sex
        if try! healthStore.biologicalSex().biologicalSex == HKBiologicalSex.female {
            self.sex = "female"
        } else if try! healthStore.biologicalSex().biologicalSex == HKBiologicalSex.male {
            self.sex = "male"
        } else if try! healthStore.biologicalSex().biologicalSex == HKBiologicalSex.other {
            self.sex = ""
        }
        
        // Date of Birth
        if #available(iOS 10.0, *) {
            do{
                let birthdayComponents =  try healthStore.dateOfBirthComponents()
                print(birthdayComponents)
                //calculate age
                let today = Date()
                let calendar = Calendar.current
                let todayDateComponents = calendar.dateComponents([.year], from: today)
                let thisYear = todayDateComponents.year!
                let age = thisYear - birthdayComponents.year!
                self.age = String(age)
            }
            catch let error {
                print("There was a problem fetching your data: \(error)")
                print("Date of Birth info need to be added in Health for a comprehensive model.")
            }
        }
    }
    
    
    
    
    
    
    // health tableview
    
    @IBOutlet var tableViewHealth: UITableView!
   
    let healthArr = ["Sleep", "Steps", "Distance"]
    
    func tableView(_ tableViewHealth: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthArr.count
    }
    
    func tableView(_ tableViewHealth: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellHealth = tableViewHealth.dequeueReusableCell(withIdentifier: "cellHealth", for: indexPath)
        if (indexPath.row==0){
            let seconds = Double(self.sleep)
            //convert to hours and minutes
            let hours = Int(seconds!) / 3600
            let minutes = Int(seconds!) % 3600 / 60
            let sleep_str = String(hours) + " hours " + String(minutes) + " minutes"
            cellHealth.textLabel?.text = healthArr[indexPath.row] + ": " + sleep_str
            return cellHealth
        }
        else if (indexPath.row==1){
            cellHealth.textLabel?.text = healthArr[indexPath.row] + ": " + self.steps + " steps"
            return cellHealth
        }
        else{
            cellHealth.textLabel?.text = healthArr[indexPath.row] + ": " + self.distance + " miles"
            return cellHealth
        }
        
        
    }
    
    
    
    
    
    
    
    /*functions for recommendation system*/
    
    
    func predictRisk(temperature: String, symptoms: [Int])-> Int{
        
        var floatTemp = Float(temperature) ?? 98.0
        
        //Fahrenheit vs Celsius check
        //convert celsius to fahrenheit
        if (self.tempMode==1 && temperature != ""){
            floatTemp = (floatTemp * 9/5) + 32
        }
        
        
        //high risk
        if (floatTemp>=100 && symptoms[1]==1 && symptoms[2]==1 && symptoms[3]==1){
            return 1
        }
        //medium risk
        else if (floatTemp>=100 || symptoms[0]==1 || symptoms[1]==1 || symptoms[2]==1 || symptoms[3]==1 || symptoms[4]==1 || symptoms[5]==1 || symptoms[6]==1){
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
        var num = 1;
        
        //add temperature to output
        //empty string check
        if (temperature == ""){
            output += "Temperature: N/A \n"
        }
        //Fahrenheit vs Celsius check
        else if (self.tempMode==0){
            output += "Temperature: " + temperature + "°F" + "\n"
        }
        else{
            output += "Temperature: " + temperature + "°C" + "\n"
        }
        
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
        
        //combine health info to suggestion
        let seconds = Double(self.sleep)
        let hours = Int(seconds!) / 3600
        if (hours<6){
            suggestionText += "\n" + String(num) + ". " + "Get more sleep."
            num+=1
        }
        if (Int(self.steps)!<500){
            suggestionText += "\n" + String(num) + ". " + "Get more exercise."
            num+=1
        }
        
        //combine suggestion to output
        output += "Suggestions:\n" + suggestionText + "\n\n"
        
        //vaccine suggestion based on personal model: age
        if (self.age != ""){
            if (Int(self.age)!>=65){
                output += "You are eligible for Coronavirus Vaccine!"
            }
            else if (Int(self.age)!>=50){
                output += "You can register for Coronavirus Vaccine on March 15th!"
            }
        }
        
        
        
        return output
    }
    
    
    @IBAction func didTapButtonCheckUp(){
        let vcCheckup = storyboard?.instantiateViewController(identifier: "checkup") as! CheckUpViewController
        vcCheckup.modalPresentationStyle = .fullScreen
        vcCheckup.completionHandler = { text,arr,tempFC in
            //set global temperature mode as index returned by switch
            self.tempMode = tempFC!
//            print(self.tempMode)
            
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
        view.backgroundColor = UIColor(red:0.87193454041772955, green:0.95800065021125635, blue:1, alpha:0.90000000000000002)
        checkUp.textColor = UIColor.black
        healthData.textColor = UIColor.black
        newCheckup.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    
    //Keep checking Dark mode status even if this page doesn't receive any user actions.
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        darkModeInitialization()
    }
    
    
    
    
}

//
//  GeneralViewController.swift
//  ZotCovidCare
//
//  Created by Qian Zhao on 2/18/21.
//

import UIKit
import WebKit

class GeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var StatisticsLabel: UILabel!
    @IBOutlet weak var LatestNewsLabel: UILabel!
    @IBOutlet weak var IrvineCasesLabel: UILabel!
    @IBOutlet weak var UCIrvineDashboardLabel: UILabel!
    
    @IBOutlet weak var ContentView: UIView!
    
    @IBOutlet weak var NewsOneButton: UIButton!
    @IBOutlet weak var NewsTwoButton: UIButton!
    
    @IBOutlet weak var NewsOneLabel: UILabel!
    @IBOutlet weak var NewsTwoLabel: UILabel!
    
    @IBOutlet weak var ViewMoreButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var DashboardView: WKWebView!
    
    let IrvineCases = ["Total Positive Cases: ", "Daily Positive Cases: ", "Total Deaths Cases: ", "Daily Deaths Cases:  ", "Total Recovered Cases: "]
    
    var numbers = [0, 0, 0, 0, 0]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IrvineCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.layer.cornerRadius = 20.0
        cell.textLabel?.text = IrvineCases[indexPath.row] + String(numbers[indexPath.row])
        return cell
    }
    
    //dict which records config.json whether to determine whether darkmode is on/off
    var config = ["darkmode" : 0, "notification" : 0]
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeInitialization()
        // [Statistics Part]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10.0
        DashboardView.layer.cornerRadius = 10.0
        
        FetchingInformation()
        
        let url = URL(string: "https://uci.edu/coronavirus/dashboard/index.php")
        let request = URLRequest(url: url!)

        DashboardView.load(request)

        // [Latest News Part]
        
        //Round corners
        NewsOneButton.layer.cornerRadius = 20.0
        NewsTwoButton.layer.cornerRadius = 20.0
        
        NewsOneLabel.layer.cornerRadius = 10.0
        NewsTwoLabel.layer.cornerRadius = 10.0
        
        //Set the label text
        NewsOneLabel.text = "COVID-19 Vaccines @UCI"
        NewsTwoLabel.text = "Understanding a Virus"
        
        //View More Button to Search Page
        ViewMoreButton.addTarget(self, action: #selector(tapOnViewMoreButton), for: .touchUpInside)
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
        ContentView.backgroundColor = UIColor.darkGray
        StatisticsLabel.textColor = UIColor.white
        LatestNewsLabel.textColor = UIColor.white
        IrvineCasesLabel.textColor = UIColor.white
        UCIrvineDashboardLabel.textColor = UIColor.white
        
    }
    func setWhite()
    {
        view.backgroundColor = UIColor(red:0.5, green:0.71397772293849049, blue:0.75263522360999191, alpha:1.0)
        ContentView.backgroundColor = UIColor(red:0.5, green:0.71397772293849049, blue:0.75263522360999191, alpha:1.0)
        StatisticsLabel.textColor = UIColor.black
        LatestNewsLabel.textColor = UIColor.black
        IrvineCasesLabel.textColor = UIColor.black
        UCIrvineDashboardLabel.textColor = UIColor.black
    }
    
    //Keep checking Dark mode status even if this page doesn't receive any user actions.
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        darkModeInitialization()
    }
    
    
    @IBAction func NewsOneButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.ucihealth.org/covid-19")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func NewsTwoButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.ucihealth.org/blog/2020/11/understanding-covid19")! as URL, options: [:], completionHandler: nil)
    }
    //Without Navigation Method
    @objc func tapOnViewMoreButton() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    //With Navigation Method
//    @objc func tapOnViewMoreButton() {
//        let story = UIStoryboard(name: "Main", bundle: nil)
//        let controller = story.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
//        let navigation = UINavigationController(rootViewController: controller)
//        self.view.addSubview(navigation.view)
//        self.addChild(navigation)
//        navigation.didMove(toParent: self)
//    }
    
    // Irvine Json data to front-end
    func FetchingInformation() {
        // Note that on the left panel, the oc_json.json is just a reference,
        // and it actually points to the file in CovidCrawler folder.
        guard let path = Bundle.main.path(forResource: "oc_json", ofType: "json") else {return}
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(json)
            
            guard let caseDict = json as? [String: Any] else {return}
            guard let daily_deaths_cases = caseDict["daily_deaths_cases"] as? Int else {return}
            guard let daily_pos_cases = caseDict["daily_pos_cases"] as? Int else {return}
            guard let total_deaths_cases = caseDict["total_deaths_cases"] as? Int else {return}
            guard let total_pos_cases = caseDict["total_pos_cases"] as? Int else {return}
            guard let total_recovered_cases = caseDict["total_recovered_cases"] as? Int else {return}
            
            numbers[0] = total_pos_cases
            numbers[1] = daily_pos_cases
            numbers[2] = total_deaths_cases
            numbers[3] = daily_deaths_cases
            numbers[4] = total_recovered_cases
            
        } catch {
            print(error)
        }
    }
    
}


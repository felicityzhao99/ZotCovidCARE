//
//  GeneralViewController.swift
//  ZotCovidCare
//
//  Created by Felicity Zhao on 2/18/21.
//

import UIKit
import WebKit

class GeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var NewsOneButton: UIButton!
    @IBOutlet weak var NewsTwoButton: UIButton!
    
    @IBOutlet weak var NewsOneLabel: UILabel!
    @IBOutlet weak var NewsTwoLabel: UILabel!
    
    @IBOutlet weak var ViewMoreButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var DashboardView: WKWebView!
    
    let IrvineCases = ["Total Positive Cases: ", "Daily Positive Cases: ", "Total Deaths Cases: ", "Daily Deaths Cases:  ", "Total Recovered Cases: "]
    
    let numbers = [245460, 325, 3848, 0, 227622]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IrvineCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.layer.cornerRadius = 20.0
        cell.textLabel?.text = IrvineCases[indexPath.row] + String(numbers[indexPath.row])
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [Statistics Part]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10.0
        DashboardView.layer.cornerRadius = 10.0
        
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
    

}


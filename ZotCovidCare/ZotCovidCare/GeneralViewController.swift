//
//  GeneralViewController.swift
//  ZotCovidCare
//
//  Created by Felicity Zhao on 2/18/21.
//

import UIKit

class GeneralViewController: UIViewController {
    
    @IBOutlet weak var NewsOneButton: UIButton!
    @IBOutlet weak var NewsTwoButton: UIButton!
    
    @IBOutlet weak var NewsOneLabel: UILabel!
    @IBOutlet weak var NewsTwoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // [Latest News Part]
        
        //Round corners
        NewsOneButton.layer.cornerRadius = 20.0
        NewsTwoButton.layer.cornerRadius = 20.0
        
        NewsOneLabel.layer.cornerRadius = 10.0
        NewsTwoLabel.layer.cornerRadius = 10.0
        
        //Set the label text
        NewsOneLabel.text = "COVID-19 Vaccines @UCI"
        NewsTwoLabel.text = "Understanding a Virus"
    }
    
    
    @IBAction func NewsOneButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.ucihealth.org/covid-19")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func NewsTwoButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.ucihealth.org/blog/2020/11/understanding-covid19")! as URL, options: [:], completionHandler: nil)
    }
    
//    @IBAction func ViewMoreButtonPressed(_ sender: Any) {
//        self.performSegue(withIdentifier: "SearchSegue", sender: self)
//    }
}

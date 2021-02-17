//
//  GeneralViewController.swift
//  ZotCovidCare
//
//  Created by Qian Zhao on 2/3/21.
//

import UIKit
import Charts

class GeneralViewController: UIViewController {

    @IBOutlet weak var IrvineTotalCasesLabel: UILabel!
    @IBOutlet weak var UCIrvineTotalCasesLabel: UILabel!
    
    @IBOutlet var IrvineCasesPieChart: PieChartView!
    @IBOutlet var UCIrvineCasesPieChart: PieChartView!
    
    @IBOutlet weak var NewsOneButton: UIButton!
    @IBOutlet weak var NewsTwoButton: UIButton!
    
    @IBOutlet weak var NewsOneLabel: UILabel!
    @IBOutlet weak var NewsTwoLabel: UILabel!
    
    //First three for Irvine cases; last three for UCI cases
    var activeDataEntry = PieChartDataEntry(value: 0)
    var recoveredDataEntry = PieChartDataEntry(value: 0)
    var deathsDataEntry = PieChartDataEntry(value: 0)
    
    var activeDataEntry2 = PieChartDataEntry(value: 0)
    var recoveredDataEntry2 = PieChartDataEntry(value: 0)
    var deathsDataEntry2 = PieChartDataEntry(value: 0)
    
    var numOfDataEntries = [PieChartDataEntry]()
    var numOfDataEntries2 = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [Statistics Part]
        //Need to change the random value of Irvine cases
        let IrvineCases = Int.random(in: 2000000...4000000)
        IrvineTotalCasesLabel.text = "Irvine: " + String(IrvineCases) + " Total Cases"
        
        //Need to change the random value of UCI cases
        let UCICases = Int.random(in: 680...700)
        UCIrvineTotalCasesLabel.text = "UC Irvine: " + String(UCICases) + " Total Cases"
        
        //Pie Chart value should be changed
        IrvineCasesPieChart.chartDescription?.text = ""
        UCIrvineCasesPieChart.chartDescription?.text = ""
        
        //Data scraped from occovid19.ochealthinfo.com
        activeDataEntry.value = 242505
        recoveredDataEntry.value = 213158
        deathsDataEntry.value = 3577
        
        activeDataEntry.label = "Active"
        recoveredDataEntry.label = "Recovered"
        deathsDataEntry.label = "Deaths"
        
        numOfDataEntries = [activeDataEntry, recoveredDataEntry, deathsDataEntry]
        
        //Data scraped from uci.edu/coronavirus/dashboard/index.php
        activeDataEntry2.value = 20
        recoveredDataEntry2.value = 678
        deathsDataEntry2.value = 8  //This one needs to be re-considered
        
        activeDataEntry2.label = "Active"
        recoveredDataEntry2.label = "Recovered"
        deathsDataEntry2.label = "Deaths"
        
        numOfDataEntries2 = [activeDataEntry2, recoveredDataEntry2, deathsDataEntry2]
        
        updateChartData() //For Irvine data
        updateChartData2() //For UCI data
        
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
    
    func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: numOfDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named: "ActiveColor"), UIColor(named: "RecoveredColor"), UIColor(named: "DeathsColor")]
        chartDataSet.colors = colors as! [NSUIColor]
        IrvineCasesPieChart.data = chartData
    }

    func updateChartData2() {
        let chartDataSet2 = PieChartDataSet(entries: numOfDataEntries2, label: nil)
        let chartData2 = PieChartData(dataSet: chartDataSet2)

        let colors2 = [UIColor(named: "ActiveColor"), UIColor(named: "RecoveredColor"), UIColor(named: "DeathsColor")]
        chartDataSet2.colors = colors2 as! [NSUIColor]
        UCIrvineCasesPieChart.data = chartData2
    }
    
    //Events when pressed News Buttons
    @IBAction func NewsOneButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.ucihealth.org/covid-19")! as URL, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func NewsTwoButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.ucihealth.org/blog/2020/11/understanding-covid19")! as URL, options: [:], completionHandler: nil)
        
    }
    
    
    

}

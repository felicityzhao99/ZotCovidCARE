//
//  SettingViewController.swift
//  ZotCovidCare
//
//  Created by Xinyi Ai on 2/16/21.
//

import UIKit

class SettingViewController: UIViewController {
    var config = ["darkmode" : 0, "notification" : 0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeInitialization()
        // Do any additional setup after loading the view.
    }
    
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
                Outlet.setOn(true, animated: false)
            }else if config["darkmode"] == 0{
                setWhite()
            }
            return
        } catch {}
    }
    
    func setWhite(){
        //view.backgroundColor = UIColor.white
        view.backgroundColor = UIColor(red:0.5, green:0.71397772293849049, blue:0.75263522360999191, alpha:1.0)
        label.textColor = UIColor.black
        LabelReceive.textColor = UIColor.black
        VersionNum.textColor = UIColor.black
        versionNumber.textColor = UIColor.black
        AboutLabel.setTitleColor(.black, for: .normal)
        safetyLabel.setTitleColor(.black, for: .normal)
    }
    
    func setBlack(){
        view.backgroundColor = UIColor.darkGray
        //view.backgroundColor = UIColor(red:0.5, green:0.71397772293849049, blue:0.75263522360999191, alpha:1.0)
        label.textColor = UIColor.white
        LabelReceive.textColor = UIColor.white
        versionNumber.textColor = UIColor.white
        VersionNum.textColor = UIColor.white
        AboutLabel.setTitleColor(.white, for: .normal)
        safetyLabel.setTitleColor(.white, for: .normal)
    }
    
    @IBOutlet weak var Outlet: UISwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var LabelReceive: UILabel!
    @IBOutlet weak var AboutLabel: UIButton!
    @IBOutlet weak var safetyLabel: UIButton!
    @IBOutlet weak var VersionNum: UILabel!
    
    @IBOutlet weak var versionNumber: UILabel!
    @IBOutlet weak var settingTitle: UINavigationItem!
    
    
    @IBAction func darkModeAction(){
        
        if Outlet.isOn == true{
            setBlack()
            config["darkmode"] = 1
        }else{
            setWhite()
            config["darkmode"] = 0
        }
        
        guard let path = Bundle.main.path(forResource: "config", ofType: "json") else {return}

        let url = URL(fileURLWithPath: path)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: config, options: .prettyPrinted)
        print(url)
        do {
            try jsonData.write(to: url)
        } catch {
            print("wirte fail")
        }
    }
    
    
    @IBAction func didTapButtonSafety(){
        let vc = UIViewController()
        //Insert text and change text features
        let txt = UILabel(frame: CGRect(x: 20, y: 100, width: 350, height: 600))
        txt.text = "PRIVACY NOTICE LAST UPDATED FEBRUARY 26, 2021.                  Thank you for choosing to be part of our community at ZotCovidCare (COMPANY, WE, US, OUR). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about this privacy notice, or our practices with regards to your personal information, please contact us at ZotCovidCare@gmail.com.When you use our mobile application, as the case may be (the APP) and more generally, use any of our services (the SERVICES, which include the App), we appreciate that you are trusting us with your personal information. We take your privacy very seriously. In this privacy notice, we seek to explain to you in the clearest way possible what information we collect, how we use it and what rights you have in relation to it. We hope you take some time to read through it carefully, as it is important. If there are any terms in this privacy notice that you do not agree with, please discontinue use of our Services immediately."
    
        txt.lineBreakMode = NSLineBreakMode.byWordWrapping
        txt.numberOfLines = 0


        //For dark mode
        if Outlet.isOn == true{
            vc.view.backgroundColor = .darkGray
            txt.textColor = .white
            }
        else{
            vc.view.backgroundColor = .white
            txt.textColor = .black
            }
        
        vc.view.addSubview(txt)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapButtonAbout(){
        let vc = UIViewController()
        //Insert text and change text features
        let txt = UILabel(frame: CGRect(x: 20, y: 150, width: 350, height: 500))
        txt.text = "  Covid-19 has made an enormous impact on everyone’s life, both physically and mentally. As of today, more than 2.9 million cases and almost 30,000 deaths have been reported in the US. Most people do not have experience with how to deal with the spreading of coronavirus. People are unable to accurately identify the risks around them and are not familiar with how to live a healthy, stable life under the pandemic. As a part of the UCI community, our team wants to contribute to a project in order to help more students and staff to stay safe and healthy. Since UCI in-person classes will reopen in fall 2021, the higher density of students on campus will bring a higher risk of Covid-exposure, which means it is more challenging to guarantee each student’s health. In such a case, we aim to provide a comprehensive platform for students to monitor their health status, access the latest Covid information, and get health-related advice."
    
        txt.lineBreakMode = NSLineBreakMode.byWordWrapping
        txt.numberOfLines = 0


        //For dark mode
        if Outlet.isOn == true{
            vc.view.backgroundColor = .darkGray
            txt.textColor = .white
            }
        else{
            vc.view.backgroundColor = .white
            txt.textColor = .black
            }
        
        vc.view.addSubview(txt)
        navigationController?.pushViewController(vc, animated: true)

    }
    
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

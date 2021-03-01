//
//  SettingViewController.swift
//  ZotCovidCare
//
//  Created by Xinyi Ai on 2/16/21.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            view.backgroundColor = UIColor.black
            label.textColor = UIColor.white
            LabelReceive.textColor = UIColor.white
            versionNumber.textColor = UIColor.white
            VersionNum.textColor = UIColor.white
            AboutLabel.setTitleColor(.white, for: .normal)
            safetyLabel.setTitleColor(.white, for: .normal)
            
        }else{
            view.backgroundColor = UIColor.white
            label.textColor = UIColor.black
            LabelReceive.textColor = UIColor.black
            VersionNum.textColor = UIColor.black
            versionNumber.textColor = UIColor.black
            AboutLabel.setTitleColor(.black, for: .normal)
            safetyLabel.setTitleColor(.black, for: .normal)
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
            vc.view.backgroundColor = .black
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
            vc.view.backgroundColor = .black
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

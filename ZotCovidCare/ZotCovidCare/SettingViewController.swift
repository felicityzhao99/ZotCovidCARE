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
    @IBOutlet weak var versionLabel: UIButton!
    
    @IBOutlet weak var settingTitle: UINavigationItem!
    @IBAction func darkModeAction(){
        if Outlet.isOn == true{
            view.backgroundColor = UIColor.black
            label.textColor = UIColor.white
            LabelReceive.textColor = UIColor.white
            AboutLabel.setTitleColor(.white, for: .normal)
            safetyLabel.setTitleColor(.white, for: .normal)
            versionLabel.setTitleColor(.white, for: .normal)
            
        }else{
            view.backgroundColor = UIColor.white
            label.textColor = UIColor.black
            LabelReceive.textColor = UIColor.black
            AboutLabel.setTitleColor(.black, for: .normal)
            safetyLabel.setTitleColor(.black, for: .normal)
            versionLabel.setTitleColor(.black, for: .normal)
        }
    }
    
    
   
    
    
    
    
    @IBAction func didTapButtonSafety(){
        let vc = UIViewController()
        //Insert text and change text features
        let txt = UILabel(frame: CGRect(x: 0, y: 50, width: 300, height: 400))
        txt.text = "Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World "
    
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
    
    @IBAction func didTapButtonVersion(){
        let vc = UIViewController()
        if Outlet.isOn == true{
            vc.view.backgroundColor = .black
            navigationController?.pushViewController(vc, animated: true)}
        else{
            vc.view.backgroundColor = .white
            navigationController?.pushViewController(vc, animated: true)
                
            }

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

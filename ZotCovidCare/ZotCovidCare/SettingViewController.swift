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
    @IBAction func didTapButtonSafety(){
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func didTapButtonAbout(){
        let vc = UIViewController()
        vc.view.backgroundColor = .white
//        vc.view.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapButtonVersion(){
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        
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

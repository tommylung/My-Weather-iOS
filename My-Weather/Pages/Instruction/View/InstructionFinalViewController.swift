//
//  InstructionFinalViewController.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import UIKit

class InstructionFinalViewController: UIViewController {

    @IBOutlet weak var vBackground: UIView!
    
    @IBOutlet weak var vAlertContainer: UIView!
    @IBOutlet weak var lblAlertTitle: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    // MARK: - Core
    private func initUI() {
        #if AUS
        self.vBackground.backgroundColor = AppGlobalManager.shared.colorAus
        #endif
        #if CAN
        self.vBackground.backgroundColor = AppGlobalManager.shared.colorCan
        #endif
    }
    
    // MARK: - Action
    @IBAction func btnDoneClicked(_ sender: Any) {
        // Go to Main
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            AppGlobalManager.shared.getTopMostViewController()?.present(vc, animated: true, completion: nil)
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

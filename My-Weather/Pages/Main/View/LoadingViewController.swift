//
//  LoadingViewController.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    // MARK: - Core
    private func initUI() {
        if AppGlobalManager.shared.bInstruction {
            // Go to Main
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            vc.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                AppGlobalManager.shared.getTopMostViewController()?.present(vc, animated: true, completion: nil)
            }
        } else {
            // Go to Instruction
            let vc = UIStoryboard(name: "Instruction", bundle: nil).instantiateViewController(withIdentifier: "InstructionLocationViewController") as! InstructionLocationViewController
            vc.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                AppGlobalManager.shared.getTopMostViewController()?.present(vc, animated: false, completion: nil)
            }
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

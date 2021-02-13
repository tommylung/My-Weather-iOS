//
//  InstructionLocationViewController.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import RxSwift
import UIKit

enum InstructionStep {
    case initial, final, notAllow
}

class InstructionLocationViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var vAlertContainer: UIView!
    @IBOutlet weak var lblAlertTitle: UILabel!
    @IBOutlet weak var vAlertAllow: UIView!
    @IBOutlet weak var btnAlertBottom: UIButton!
    
    var step: InstructionStep = .initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
    }
    
    // MARK: - Core
    private func initUI() {
        self.view.backgroundColor = AppGlobalManager.shared.colorTheme
        
        self.resetUI()
        self.vAlertContainer.alpha = 0.0
//        self.step = .initial
//        self.updateUI()
//        self.showAlert()
    }
    
    private func bindUI() {
        self.disposeBag = DisposeBag()
        
        LocationManager.shared.psChangedAuthorization.subscribe(onNext: { [weak self] status in
            guard let self = self else { return }
            self.hideAlert()
            if status == .notDetermined {
                self.step = .initial
            } else if status == .authorizedAlways || status == .authorizedWhenInUse {
                self.step = .final
            } else if status == .denied || status == .restricted {
                self.step = .notAllow
            }
            self.updateUI()
            self.showAlert()
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Update UI
    private func resetUI() {
        self.lblAlertTitle.text = ""
        self.vAlertAllow.isHidden = true
        self.btnAlertBottom.setTitle("", for: .normal)
    }
    
    private func updateUI() {
        if self.step == .initial {
            self.lblAlertTitle.text = "We can provide the latest weather of yoour current location. Please let us know your current location."
            self.vAlertAllow.isHidden = false
            self.btnAlertBottom.setTitle("Next", for: .normal)
        } else if self.step == .final {
            self.lblAlertTitle.text = "Enjoy~"
            self.vAlertAllow.isHidden = true
            self.btnAlertBottom.setTitle("Done", for: .normal)
        } else if self.step == .notAllow {
            self.lblAlertTitle.text = "If you want to get current location weather, please allow to use your location on setting."
            self.vAlertAllow.isHidden = true
            self.btnAlertBottom.setTitle("Done", for: .normal)
        }
    }
    
    func showAlert() {
        UIView.animate(withDuration: 0.5, animations: {
            self.vAlertContainer.alpha = 1.0
        })
    }
    
    func hideAlert() {
        UIView.animate(withDuration: 0.5, animations: {
            self.vAlertContainer.alpha = 0.0
        })
    }
    
    // MARK: - Action
    @IBAction func btnAlertBottomClicked(_ sender: Any) {
        if self.step == .initial {
            LocationManager.shared.requestAuthorization()
        } else if self.step == .final || self.step == .notAllow {
            self.goToMain()
        }
    }
    
    func goToMain() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.instruction)
        
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

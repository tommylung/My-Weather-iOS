//
//  MainViewController.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 5/2/2021.
//

import RxSwift
import UIKit



class MainViewController: UIViewController, UIAdaptivePresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var disposeBag = DisposeBag()
    
    // Weather
    @IBOutlet weak var tvWeather: UITableView!
    // Toolbar
    @IBOutlet weak var bbiSearch: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
        self.fetchDta()
    }
    
    // MARK: - Core
    private func initUI() {
        LocationManager.shared.startTracking()
        
        self.tvWeather.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        
        self.tvWeather.reloadData()
    }
    
    private func bindUI() {
        self.disposeBag = DisposeBag()
        
        APIManager.shared.psGotCityInfo.subscribe(onNext: { [weak self] (mCity, isCurrent) in
            guard let self = self else { return }
            if isCurrent {
                mCity.isCurrent = isCurrent
                AppGlobalManager.shared.arrCity.insert(mCity, at: 0)
            }
            self.tvWeather.reloadData()
        }).disposed(by: self.disposeBag)
    }
    
    private func fetchDta() {
        self.getMyCurrentWeather()
    }
    
    // Get Current Location
    func getMyCurrentWeather() {
        if AppGlobalManager.shared.arrCity.filter({ $0.isCurrent == true }).count == 0 {
            if let dLat = LocationManager.shared.getCurrentLocation()?.coordinate.latitude, let dLon = LocationManager.shared.getCurrentLocation()?.coordinate.longitude {
                APIManager.shared.getCityInfo(lat: dLat, lon: dLon, isCurrentLocation: true)
            }
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppGlobalManager.shared.arrCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvWeather.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
            
        if AppGlobalManager.shared.arrCity.count > indexPath.row {
            cell.updateUI(city: AppGlobalManager.shared.arrCity[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tvWeather.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if AppGlobalManager.shared.arrCity[indexPath.row].isCurrent {
                let alert = UIAlertController(title: "Caution", message: "You can delete recently searched locations only.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                AppGlobalManager.shared.arrCity.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchViewController" {
            segue.destination.presentationController?.delegate = self
        }
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.tvWeather.reloadData()
    }
}


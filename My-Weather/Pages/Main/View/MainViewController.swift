//
//  MainViewController.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 5/2/2021.
//

import RxSwift
import UIKit



class MainViewController: UIViewController, UIAdaptivePresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var vm = MainViewModel()
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
        
        // TableView register cell
        self.tvWeather.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        
        // Get arrCity from UserDefault
        self.getCitiesFromUserDefault()
    }
    
    private func bindUI() {
        self.disposeBag = DisposeBag()
        
        self.vm.psGotCityInfo.subscribe(onNext: { [weak self] (mCity, isCurrent) in
            guard let self = self else { return }
            self.vm.strCurrentLocation = mCity.getCityString()
            self.tvWeather.reloadData()
        }).disposed(by: self.disposeBag)
        
        // Get current weather after updated current location
        LocationManager.shared.psUpdatedCurrentLocation.subscribe(onNext: { [weak self] status in
            guard let self = self else { return }
            self.getMyCurrentWeather()
        }).disposed(by: self.disposeBag)
    }
    
    private func fetchDta() {
//        self.getMyCurrentWeather()
    }
    
    // Get Current Location
    func getMyCurrentWeather() {
        if let dLat = LocationManager.shared.getCurrentLocation()?.coordinate.latitude, let dLon = LocationManager.shared.getCurrentLocation()?.coordinate.longitude {
            self.vm.getCityInfo(lat: dLat, lon: dLon, isCurrentLocation: true)
        }
    }
    
    // Cities from UserDefault
    private func getCitiesFromUserDefault() {
        let arrCityString = UserDefaults.standard.object(forKey: UserDefaultsKey.cities) as? [String] ?? [String]()
        self.vm.arrCityString.removeAll()
        self.vm.arrCityString = arrCityString
        self.tvWeather.reloadData()
    }
    
    private func updateCitiesToUserDefault() {
        UserDefaults.standard.set(self.vm.arrCityString, forKey: UserDefaultsKey.cities)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.vm.strCurrentLocation != nil {
            return self.vm.arrCityString.count + 1
        } else {
            return self.vm.arrCityString.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvWeather.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        
        if let strCurrentLocation = self.vm.strCurrentLocation {
            if indexPath.row == 0 {
                cell.vm.getLocation(city: strCurrentLocation)
                cell.vm.getWeather(city: strCurrentLocation)
                cell.imgvNavigation.isHidden = false
            } else {
                cell.vm.getLocation(city: self.vm.arrCityString[indexPath.row - 1])
                cell.vm.getWeather(city: self.vm.arrCityString[indexPath.row - 1])
            }
        } else {
            cell.vm.getLocation(city: self.vm.arrCityString[indexPath.row])
            cell.vm.getWeather(city: self.vm.arrCityString[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tvWeather.reloadData()
        
        let vc = self.storyboard?.instantiateViewController(identifier: "CityDetailViewController") as! CityDetailViewController
        if self.vm.strCurrentLocation != nil {
            if indexPath.row == 0 {
                vc.vm.strCity = self.vm.strCurrentLocation
            } else {
                vc.vm.strCity = self.vm.arrCityString[indexPath.row - 1]
            }
        } else {
            vc.vm.strCity = self.vm.arrCityString[indexPath.row]
        }
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.vm.strCurrentLocation != nil {
                if indexPath.row == 0 {
                    let alert = UIAlertController(title: "Caution", message: "You can delete recently searched locations only.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.vm.arrCityString.remove(at: indexPath.row - 1)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } else {
                self.vm.arrCityString.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            self.updateCitiesToUserDefault()
        }
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchViewController" {
            segue.destination.presentationController?.delegate = self
        }
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.getCitiesFromUserDefault()
    }
}


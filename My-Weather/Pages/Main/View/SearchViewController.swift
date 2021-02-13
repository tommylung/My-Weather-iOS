//
//  SearchViewController.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 11/2/2021.
//

import RxSwift
import UIKit

class SearchViewController: UIViewController, UIAdaptivePresentationControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var vm = SearchViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var tvLocation: UITableView!
    @IBOutlet weak var vNoResult: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
        self.fetchData()
    }
    
    // MARK: - Core
    private func initUI() {
        self.sbSearch.placeholder = "City or zip code"
        self.tvLocation.isHidden = false
        self.vNoResult.isHidden = false
    }
    
    private func bindUI() {
        self.vm.psGotCitiesInfo.subscribe(onNext: { [weak self] arrCity in
            guard let self = self else { return }
            self.vm.arrSearchedCity = arrCity
            
            self.tvLocation.isHidden = (arrCity.count == 0)
            self.vNoResult.isHidden = !(arrCity.count == 0)
            self.tvLocation.reloadData()
        }).disposed(by: self.disposeBag)
    }
    
    private func fetchData() {
        
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let strKeyword = searchBar.text {
            self.vm.getCitiesInfo(keyword: strKeyword)
        } else {
            self.tvLocation.isHidden = true
            self.vNoResult.isHidden = false
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.arrSearchedCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if self.vm.arrSearchedCity.count > indexPath.row {
            var strCity = ""
            if let strName = self.vm.arrSearchedCity[indexPath.row].name {
                strCity += strName
            } else {
                strCity += "nil"
            }
            if let strState = self.vm.arrSearchedCity[indexPath.row].state, strState != "" {
                strCity += ", \(strState)"
            }
            if let strCountry = self.vm.arrSearchedCity[indexPath.row].country {
                strCity += ", \(strCountry)"
            }
                
            cell.textLabel?.text = strCity
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var arrCity = UserDefaults.standard.object(forKey: UserDefaultsKey.cities)
//        arrCity.append(self.vm.arrSearchedCity[indexPath.row])
//        UserDefaults.standard.set(arrCity, forKey: UserDefaultsKey.cities)
//        UserDefaults.standard.synchronize()
        
        var strCity = ""
        if let strName = self.vm.arrSearchedCity[indexPath.row].name {
            strCity += strName
        }
        if let strState = self.vm.arrSearchedCity[indexPath.row].state, strState != "" {
            strCity += ",\(strState)"
        }
        if let strCountry = self.vm.arrSearchedCity[indexPath.row].country {
            strCity += ",\(strCountry)"
        }
        
        var arrCity = UserDefaults.standard.object(forKey: UserDefaultsKey.cities) as? [String] ?? [String]()
        arrCity.append(strCity)
        UserDefaults.standard.set(arrCity, forKey: UserDefaultsKey.cities)
        
        self.presentationController?.delegate?.presentationControllerDidDismiss?(self.presentationController!)
        self.dismiss(animated: true)
    }

}

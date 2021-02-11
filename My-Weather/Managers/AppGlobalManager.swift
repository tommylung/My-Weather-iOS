//
//  AppGlobalManager.swift
//  My-Weather
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import Foundation
import UIKit

class AppGlobalManager {
    static let shared = AppGlobalManager()
    
    // Global Id
    let appid = "95d190a434083879a6398aafd54d9e73"
    
    // Global Color
    let colorAus = UIColor.init(hex: "#3E92C7FF")
    let colorCan = UIColor.init(hex: "#F08C83FF")
    
    // Instruction
    var bInstruction = false
    
    // Cities
    var arrCity = [CityModel]()
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
}

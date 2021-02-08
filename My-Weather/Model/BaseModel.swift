//
//  BaseModel.swift
//  My-Weather-AUS
//
//  Created by Ngan Chak Lung on 8/2/2021.
//

import Foundation
import SwiftyJSON

protocol BaseModel: CustomStringConvertible {
      associatedtype T
      var description: String { get }
      static func parse(json: JSON) -> T
      static func parseArray(jsonArray: [JSON]) -> [T]
}

extension BaseModel {
    var description: String { return "" }

    static func parseArray(jsonArray: [JSON]) -> [T] {
        var array = [T]()
        for json in jsonArray {
            let obj = parse(json: json)
            array.append(obj)
        }
        return array
    }
}

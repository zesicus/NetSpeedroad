//
//  Else.swift
//  CashBox
//
//  Created by Sunny on 2018/8/30.
//  Copyright © 2018 Nuggets. All rights reserved.
//

import UIKit
import CoreTelephony

let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
typealias JSONObject = [String: Any]

class Utils {
    
    // JSON解析
    static func decodeJSON(data: Data) -> JSONObject? {
        if data.count > 0 {
            guard let result = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) else {
                return JSONObject()
            }
            if let dictionary = result as? JSONObject {
                return dictionary
            } else if let array = result as? [JSONObject] {
                return ["data": array]
            } else {
                return JSONObject()
            }
        } else {
            return JSONObject()
        }
    }
    
}

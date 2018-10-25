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
    
    // 获取运营商信息
    
    static func getCarrierName() -> (carrierName: String, countryCode: String, networkType: String)? {
        let info = CTTelephonyNetworkInfo()
        if let carrier = info.subscriberCellularProvider {
            let currentRadioTech = info.currentRadioAccessTechnology!
            print("数据业务信息：\(currentRadioTech)")
            print("网络制式：\(Utils.getNetworkType(currentRadioTech: currentRadioTech))")
            print("运营商名字：\(carrier.carrierName ?? "unknown")")
            print("移动国家码(MCC)：\(carrier.mobileCountryCode ?? "unknown")")
            print("移动网络码(MNC)：\(carrier.mobileNetworkCode ?? "unknown")")
            print("ISO国家代码：\(carrier.isoCountryCode ?? "unknown")")
            print("是否允许VoIP：\(carrier.allowsVOIP)")
            return (carrier.carrierName ?? "unknown", carrier.mobileCountryCode ?? "unknown", Utils.getNetworkType(currentRadioTech: currentRadioTech))
        }
        return nil
    }
    
    static func getNetworkType(currentRadioTech: String) -> String {
        var networkType = ""
        switch currentRadioTech {
        case CTRadioAccessTechnologyGPRS:
            networkType = "2G"
            break
        case CTRadioAccessTechnologyEdge:
            networkType = "2G"
            break
        case CTRadioAccessTechnologyeHRPD:
            networkType = "3G"
            break
        case CTRadioAccessTechnologyHSDPA:
            networkType = "3G"
            break
        case CTRadioAccessTechnologyCDMA1x:
            networkType = "2G"
            break
        case CTRadioAccessTechnologyLTE:
            networkType = "4G"
            break
        case CTRadioAccessTechnologyCDMAEVDORev0:
            networkType = "3G"
            break
        case CTRadioAccessTechnologyCDMAEVDORevA:
            networkType = "3G"
            break
        case CTRadioAccessTechnologyCDMAEVDORevB:
            networkType = "3G"
            break
        case CTRadioAccessTechnologyHSUPA:
            networkType = "3G"
            break
        default:
            break
        }
        return networkType
    }
    
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

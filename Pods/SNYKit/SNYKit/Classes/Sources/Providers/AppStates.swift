//
//  AppStates.swift
//  CashBox
//
//  Created by Sunny on 2018/7/16.
//  Copyright © 2018 Nuggets. All rights reserved.
//

import UIKit

public struct AppStates {
    
    public static let shared = AppStates()
    
    public var isForeground: Bool {
        let state = UIApplication.shared.applicationState
        return state == .active
    }
    
    public var isBackground: Bool {
        let state = UIApplication.shared.applicationState
        return state == .background
    }
    
    public var isInactive: Bool {
        let state = UIApplication.shared.applicationState
        return state == .inactive
    }
}

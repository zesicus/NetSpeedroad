//
//  NavigationController.swift
//  NetSpeedroad
//
//  Created by Nuggets on 2018/11/6.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
}

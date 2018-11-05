//
//  TempViewController.swift
//  NetSpeedroad
//
//  Created by Nuggets on 2018/11/5.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import SNYKit

class MainViewController: UIViewController {

    @IBOutlet weak var meterView: MeterView!
    @IBOutlet weak var startBtn: UIButton!
    lazy var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 34, g: 37, b: 48)
        meterView.setupMeter()
        startBtn.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        startBtn.layer.cornerRadius = 17.5
        startBtn.layer.borderColor = UIColor.white.cgColor
        startBtn.layer.borderWidth = 1.0
        startBtn.layer.masksToBounds = true
    }

    @IBAction func startAction(_ sender: UIButton) {
        
    }
    
}

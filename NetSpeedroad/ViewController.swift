//
//  ViewController.swift
//  NetSpeedroad
//
//  Created by Sunny on 2018/10/24.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    lazy var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.downloadCompleteHandler = { [weak self] in
            self?.btn.isEnabled = true
            self?.btn.setTitle("开始测速", for: .normal)
        }
    }

    @IBAction func btnAction(_ sender: UIButton) {
        viewModel.startTest()
        btn.setTitle("测速中...", for: .normal)
        btn.isEnabled = false
    }
    
    
    
}


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
    @IBOutlet weak var elseBtn: UIButton!
    lazy var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.downloadCompleteHandler = { [weak self] in
            self?.btn.isEnabled = true
            self?.elseBtn.isEnabled = true
            self?.btn.setTitle("下载测速", for: .normal)
            self?.elseBtn.setTitle("上传测速", for: .normal)
        }
    }

    @IBAction func btnAction(_ sender: UIButton) {
        viewModel.startTest(testMode: .download)
        btn.setTitle("测速中...", for: .normal)
        btn.isEnabled = false
        elseBtn.isEnabled = false
    }
    
    @IBAction func elseBtnAction(_ sender: UIButton) {
        viewModel.startTest(testMode: .upload)
        elseBtn.setTitle("测速中...", for: .normal)
        elseBtn.isEnabled = false
        btn.isEnabled = false
    }
    
    
}


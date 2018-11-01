//
//  ViewController.swift
//  NetSpeedroad
//
//  Created by Sunny on 2018/10/24.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var downMaxLabel: UILabel!
    @IBOutlet weak var downMinLabel: UILabel!
    @IBOutlet weak var downAvgLabel: UILabel!
    @IBOutlet weak var downCurLabel: UILabel!
    @IBOutlet weak var upMaxLabel: UILabel!
    @IBOutlet weak var upMinLabel: UILabel!
    @IBOutlet weak var upAvgLabel: UILabel!
    @IBOutlet weak var upCurLabel: UILabel!
    @IBOutlet weak var testBtn: UIButton!
    
    lazy var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHandler()
    }
    
    func setupView() {
        downMaxLabel.attributedText = "最大速度\n0.0 MB/s".getLineSpacing()
        downMinLabel.attributedText = "最小速度\n0.0 MB/s".getLineSpacing()
        downAvgLabel.attributedText = "平均速度\n0.0 MB/s".getLineSpacing()
        downCurLabel.attributedText = "当前速度\n0.0 MB/s".getLineSpacing()
        upMaxLabel.attributedText = "最大速度\n0.0 MB/s".getLineSpacing()
        upMinLabel.attributedText = "最小速度\n0.0 MB/s".getLineSpacing()
        upAvgLabel.attributedText = "平均速度\n0.0 MB/s".getLineSpacing()
        upCurLabel.attributedText = "当前速度\n0.0 MB/s".getLineSpacing()
    }
    
    func setupHandler() {
        viewModel.testCompleteHandler = { [weak self] in
            self?.testBtn.isEnabled = true
            self?.testBtn.setTitle("重新测速", for: .normal)
            self?.setupView()
        }
        
        viewModel.downloadExecutingHandler = { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.testBtn.setTitle("下载测速中", for: .normal)
            weakSelf.downMaxLabel.attributedText = String(format: "最大速度\n%.2f MB/s", weakSelf.viewModel.downlinkMaxSpeed).getLineSpacing()
            weakSelf.downMinLabel.attributedText = String(format: "最小速度\n%.2f MB/s", weakSelf.viewModel.downlinkMinSpeed).getLineSpacing()
            weakSelf.downAvgLabel.attributedText = String(format: "平均速度\n%.2f MB/s", weakSelf.viewModel.downlinkAvgSpeed).getLineSpacing()
            weakSelf.downCurLabel.attributedText = String(format: "当前速度\n%.2f MB/s", weakSelf.viewModel.downlinkCurSpeed).getLineSpacing()
        }
        
        viewModel.uploadExecutingHandler = { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.testBtn.setTitle("上传测速中", for: .normal)
            weakSelf.upMaxLabel.attributedText = String(format: "最大速度\n%.2f MB/s", weakSelf.viewModel.uplinkMaxSpeed).getLineSpacing()
            weakSelf.upMinLabel.attributedText = String(format: "最小速度\n%.2f MB/s", weakSelf.viewModel.uplinkMinSpeed).getLineSpacing()
            weakSelf.upAvgLabel.attributedText = String(format: "平均速度\n%.2f MB/s", weakSelf.viewModel.uplinkAvgSpeed).getLineSpacing()
            weakSelf.upCurLabel.attributedText = String(format: "当前速度\n%.2f MB/s", weakSelf.viewModel.uplinkCurSpeed).getLineSpacing()
        }
    }
    
    @IBAction func testAction(_ sender: UIButton) {
        
        viewModel.startTest()
        testBtn.isEnabled = false
    }
    
}


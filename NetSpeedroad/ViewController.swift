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
    @IBOutlet weak var elapseLabel: UILabel!
    @IBOutlet weak var bandwidthLabel: UILabel!
    
    lazy var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHandler()
    }
    
    func setupView() {
        titleLabel.text = viewModel.connectionType
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
        
        viewModel.pingExecutingHandler = { [weak self] elaspe in
            self?.elapseLabel.text = "\(elaspe) ms"
        }
        
        viewModel.pingCompletehandler = { [weak self] elaspe in
            self?.elapseLabel.text = "\(elaspe) ms"
        }
        
        viewModel.testCompleteHandler = { [weak self] in
            guard let weakSelf = self else {return}
            self?.testBtn.isEnabled = true
            self?.bandwidthLabel.text = "\(Int(weakSelf.viewModel.downlinkAvgSpeed * 8.0)) M"
            self?.testBtn.setTitle("重新测速", for: .normal)
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
        setupView()
        elapseLabel.text = "0 ms"
        bandwidthLabel.text = "0 M"
        viewModel.startTest()
        testBtn.isEnabled = false
        testBtn.setTitle("检测延迟中", for: .normal)
    }
    
}



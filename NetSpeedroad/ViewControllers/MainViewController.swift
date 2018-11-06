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

    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var meterBackView: UIView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    var meterView: MeterView!
    lazy var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 34, g: 37, b: 48)
        
        meterView = Bundle.main.loadNibNamed("MeterView", owner: nil, options: nil)?.last as? MeterView
        meterView.frame = meterBackView.bounds
        meterBackView.addSubview(meterView)
        meterView.setupMeter()
        
        networkLabel.text = "网络类型：\(viewModel.connectionType)"
        
        startBtn.layer.cornerRadius = 17.5
        startBtn.layer.borderColor = UIColor.white.cgColor
        startBtn.layer.borderWidth = 1.0
        startBtn.layer.masksToBounds = true
        startBtn.setBackgroundImage(UIColor.white.withAlphaComponent(0.1).getImage(), for: .normal)
        startBtn.setBackgroundImage(UIColor.white.withAlphaComponent(0.3).getImage(), for: .highlighted)
        
        setupHandler()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func startAction(_ sender: UIButton) {
        sender.isEnabled = false
        sender.setTitle("执行中", for: .normal)
        sender.setTitleColor(UIColor.lightGray, for: .normal)
        
        viewModel.startTest()
    }
    
}

extension MainViewController {
    
    func setupHandler() {
        
        viewModel.pingExecutingHandler = { [weak self] elaspe in
            self?.meterView.label.text = "\(elaspe)"
            self?.meterView.unitLabel.text = "ms"
            self?.statusLabel.text = "延迟检测中"
        }
        
        viewModel.pingCompletehandler = { elaspe in
            dprint("Ping完成")
        }
        
        viewModel.downloadExecutingHandler = { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.statusLabel.text = "下载测速中..."
            weakSelf.meterView.label.text = "\(weakSelf.viewModel.downlinkCurSpeed)"
            weakSelf.meterView.unitLabel.text = "MB/s"
            weakSelf.meterView.draw(progress: CGFloat(weakSelf.viewModel.downlinkCurSpeed) / 10.0)
        }
        
        viewModel.uploadExecutingHandler = { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.statusLabel.text = "上传测速中..."
            weakSelf.meterView.label.text = "\(weakSelf.viewModel.uplinkCurSpeed)"
            weakSelf.meterView.unitLabel.text = "MB/s"
            weakSelf.meterView.draw(progress: CGFloat(weakSelf.viewModel.uplinkCurSpeed) / 10.0)
        }
        
        viewModel.testCompleteHandler = { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.meterView.unitLabel.text = "MB/s"
            weakSelf.statusLabel.text = ""
            weakSelf.startBtn.isEnabled = true
            weakSelf.startBtn.setTitle("开始", for: .normal)
            weakSelf.startBtn.setTitleColor(UIColor.white, for: .normal)
            weakSelf.meterView.draw(progress: 0)
            
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.viewModel = DetailViewModel.init(connectionType: "\(weakSelf.viewModel.connectionType)",
                                                avgPing: weakSelf.viewModel.avgPing,
                                                uplinkMaxSpeed: weakSelf.viewModel.uplinkMaxSpeed,
                                                uplinkMinSpeed: weakSelf.viewModel.uplinkMinSpeed,
                                                uplinkAvgSpeed: weakSelf.viewModel.uplinkAvgSpeed,
                                                uplinkCurSpeed: 0.0,
                                                downlinkMaxSpeed: weakSelf.viewModel.downlinkMaxSpeed,
                                                downlinkMinSpeed: weakSelf.viewModel.downlinkMinSpeed,
                                                downlinkAvgSpeed: weakSelf.viewModel.downlinkAvgSpeed,
                                                downlinkCurSpeed: 0.0,
                                                bandwidth: weakSelf.viewModel.bandwidth)
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

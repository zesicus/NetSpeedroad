//
//  ViewController.swift
//  NetSpeedroad
//
//  Created by Sunny on 2018/10/24.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var downMaxLabel: UILabel!
    @IBOutlet weak var downMinLabel: UILabel!
    @IBOutlet weak var downAvgLabel: UILabel!
    @IBOutlet weak var upMaxLabel: UILabel!
    @IBOutlet weak var upMinLabel: UILabel!
    @IBOutlet weak var upAvgLabel: UILabel!
    @IBOutlet weak var testBtn: UIButton!
    @IBOutlet weak var elapseLabel: UILabel!
    @IBOutlet weak var bandwidthLabel: UILabel!
    
    var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(r: 34, g: 37, b: 48)
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIColor(r: 34, g: 37, b: 48).getImage(), for: .any, barMetrics: .default)
        
        titleLabel.text = "您的网络: \(viewModel.connectionType)"
        downMaxLabel.attributedText = String(format: "最大速度\n%.1f MB/s", viewModel.downlinkMaxSpeed).getLineSpacing()
        downMinLabel.attributedText = String(format: "最小速度\n%.1f MB/s", viewModel.downlinkMinSpeed).getLineSpacing()
        downAvgLabel.attributedText = String(format: "平均速度\n%.1f MB/s", viewModel.downlinkAvgSpeed).getLineSpacing()
        upMaxLabel.attributedText = String(format: "最大速度\n%.1f MB/s", viewModel.uplinkMaxSpeed).getLineSpacing()
        upMinLabel.attributedText = String(format: "最小速度\n%.1f MB/s", viewModel.uplinkMinSpeed).getLineSpacing()
        upAvgLabel.attributedText = String(format: "平均速度\n%.1f MB/s", viewModel.uplinkAvgSpeed).getLineSpacing()
        elapseLabel.text = "\(viewModel.avgPing)ms"
        bandwidthLabel.text = "\(viewModel.bandwidth)M"
    }
    
}



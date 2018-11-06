//
//  MeterView.swift
//  NetSpeedroad
//
//  Created by Sunny on 2018/10/31.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit

class MeterView: UIView {
    
    //表盘
    var meterPan: CAShapeLayer!
    
    //表盘中心
    var panCenter: CGPoint!
    
    //表盘开始角度
    var startAngle: CGFloat!
    
    //表盘结束角度
    var endAngle: CGFloat!
    
    //表盘当前角度
    var currentAngle: CGFloat!
    
    //表盘总角度
    var totalAngle: CGFloat!
    
    //表盘宽度
    let panWidth: CGFloat = 20.0
    
    //表盘外圈半径
    var panOutsideRadius: CGFloat!
    
    //表盘内圈半径
    var panInsideRadius: CGFloat!
    
    //进度Layer
    var progressLayer: CAShapeLayer!
    var progressThenLayer: CAShapeLayer!
    
    //读数
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30.0, weight: .medium)
        unitLabel.textColor = .white
        unitLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    override var frame: CGRect {
        didSet {
            panCenter = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
            panOutsideRadius = frame.size.width / 2
            panInsideRadius = frame.size.width / 2 - 15
        }
    }
    
    //设置表盘
    func setupMeter(startAngle: CGFloat = 3 * CGFloat.pi / 4) {
        drawPan(startAngle: startAngle)
    }
    
    //画进度
    func draw(progress: CGFloat) {
        label.text = String(format: "%.1f", progress * 10)
        progressLayer.strokeEnd = progress
        progressThenLayer.strokeEnd = progress
    }
    
}

extension MeterView {
    
    fileprivate func drawPan(startAngle: CGFloat = 3 * CGFloat.pi / 4) {
        self.startAngle = startAngle
        self.endAngle = 3 * CGFloat.pi - startAngle > 2 * CGFloat.pi ? CGFloat.pi - startAngle : 3 * CGFloat.pi - startAngle
        self.totalAngle = endAngle - startAngle < 0 ? 2 * CGFloat.pi - startAngle : endAngle - startAngle
        
        let panPath = UIBezierPath(arcCenter: panCenter, radius: panInsideRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let panLayer = CAShapeLayer()
        panLayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        panLayer.lineWidth = panWidth
        panLayer.fillColor = UIColor.clear.cgColor
        panLayer.lineCap = .square
        panLayer.path = panPath.cgPath
        self.layer.addSublayer(panLayer)
        
        let progressPath = UIBezierPath(arcCenter: panCenter, radius: panInsideRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer = CAShapeLayer()
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = panWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .square
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeEnd = 0.0
        self.layer.addSublayer(progressLayer)
        
        let progressThinPath = UIBezierPath(arcCenter: panCenter, radius: panOutsideRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressThenLayer = CAShapeLayer()
        progressThenLayer.strokeColor = UIColor.white.cgColor
        progressThenLayer.lineWidth = 3.0
        progressThenLayer.fillColor = UIColor.clear.cgColor
        progressThenLayer.lineCap = .square
        progressThenLayer.path = progressThinPath.cgPath
        progressThenLayer.strokeEnd = 0.0
        self.layer.addSublayer(progressThenLayer)
    }
    
}

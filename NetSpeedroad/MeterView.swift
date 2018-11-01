//
//  MeterView.swift
//  NetSpeedroad
//
//  Created by Sunny on 2018/10/31.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit

class MeterView: UIView {

    //圆盘开始角度
    fileprivate var startAngle: CGFloat!
    
    //圆盘结束角度
    fileprivate var endAngle: CGFloat!
    
    //圆盘总弧度
    fileprivate var arcAngle: CGFloat!
    
    //线宽
    fileprivate var lineWidth: CGFloat!
    
    //刻度值长度
    fileprivate var scaleValueRadiusWidth: CGFloat!
    
    //速度表半径
    fileprivate var arcRadius: CGFloat!
    
    //刻度半径
    fileprivate var scaleRadius: CGFloat!
    
    //刻度值半径
    fileprivate var scaleValueRadius: CGFloat!
    
    fileprivate var progressLayer: CAShapeLayer!
    
    fileprivate var insideProgressLayer: CAShapeLayer!
    
    fileprivate var layerArray: [CAShapeLayer]!
    
    fileprivate var textArray: [String]!
    
    fileprivate var luCenter: CGPoint!
    
    //指针
    fileprivate var innerCursorImageView: UIImageView!
    
    //刻度几等分
    fileprivate var divide: Int!
    
    //根据此View自适应的表盘去掉外边线宽的半径
    fileprivate var calRadius: CGFloat!
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = bounds.size.width / 2.0
        layer.masksToBounds = true
        
        calRadius = bounds.size.height > bounds.size.width ? (bounds.size.width * 0.5 - lineWidth) : (bounds.size.height * 0.5 - lineWidth)
        
        innerCursorImageView = UIImageView(image: UIImage(named: "cursor")!)
        innerCursorImageView!.frame = CGRect(x:0, y: 0, width: innerCursorImageView!.image!.size.width, height: innerCursorImageView!.image!.size.height)
        innerCursorImageView!.center = self.center
        self.setAnchorPoint(CGPoint(x: 0.5, y: 0.816993), for: innerCursorImageView!)
        innerCursorImageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        luCenter = CGPoint(x: center.x - frame.origin.x, y: center.y - frame.origin.y)
    }
    
    /// 刻度盘圆弧
    ///
    /// - Parameters:
    ///   - startAngle: 开始角度
    ///   - endAngle: 结束角度
    ///   - lineWidth: 线宽
    ///   - fillColor: 填充色
    ///   - strokeColor: 描边色
    func drawArc(startAngle: CGFloat, endAngle: CGFloat, lineWidth: CGFloat, fillColor: UIColor, strokeColor: UIColor) {
        
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.lineWidth = lineWidth
        
        self.arcAngle = endAngle - startAngle
        self.scaleRadius = arcRadius - 15
        self.scaleValueRadius = self.scaleRadius - self.lineWidth
        
        self.addSubview(innerCursorImageView!)
        
        let outArc = UIBezierPath(arcCenter: center, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.path = outArc.cgPath
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)
        
        let insideArc = UIBezierPath(arcCenter: center, radius: arcRadius - 5, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let insideShapeLayer = CAShapeLayer()
        insideShapeLayer.lineWidth = lineWidth
        insideShapeLayer.fillColor = fillColor.cgColor
        insideShapeLayer.strokeColor = strokeColor.cgColor
        insideShapeLayer.path = insideArc.cgPath
        insideShapeLayer.lineCap = .round
        layer.addSublayer(insideShapeLayer)
    }
    
    
    /// 画刻度
    ///
    /// - Parameters:
    ///   - divide: 刻度几等分
    ///   - remainder: 刻度数
    ///   - strokeColor: 轮廓填充颜色
    ///   - fillColor: 刻度颜色
    ///   - scaleNormalWidth:
    ///   - scaleBigWidth:
    func drawScale(divide: Int, remainder: Int, strokeColor: UIColor, fillColor: UIColor, scaleNormalWidth: CGFloat, scaleBigWidth: CGFloat) {
        self.divide = divide
        let perAngle = self.arcAngle! / CGFloat(divide)
        for i in 0 ..< divide {
            //每段弧线的起始角度和结束角度
            let startAngle = self.startAngle + perAngle * CGFloat(i)
            let endAngle = startAngle + perAngle * CGFloat(i + 1)
            
            let tickPath = UIBezierPath(arcCenter: center, radius: self.scaleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            let perLayer = CAShapeLayer()
            perLayer.fillColor = UIColor.clear.cgColor
            perLayer.strokeColor = strokeColor.cgColor
            if remainder != 0 && (i % remainder == 0) {
                perLayer.lineWidth = scaleNormalWidth
            } else {
                perLayer.lineWidth = scaleBigWidth
            }
            perLayer.path = tickPath.cgPath
            layer.addSublayer(perLayer)
        }
    }
    
    func drawScaleValue(divide: Int) {
        if divide == 0 { return }
        let textAngle = self.arcAngle / CGFloat(divide)
        for i in 0 ..< divide {
//            let point = calcuteTextPosition(with: center, angle: -(endAngle - textAngle * CGFloat(i)))
//            let tickText = String(format: "%.1f", Float(i * ))
        }
    }

}

extension MeterView {
    
    //重新设置指针的frame，确保不发生位移
    func setAnchorPoint(_ anchorPoint: CGPoint, for view: UIView) {
        let oldOrigin = view.frame.origin
        view.layer.anchorPoint = anchorPoint
        let newOrigin = view.frame.origin
        var transition: CGPoint!
        transition.x = newOrigin.x - oldOrigin.x
        transition.y = newOrigin.y - oldOrigin.y
        view.center = CGPoint(x: view.center.x - transition.x, y: view.center.y - transition.y)
    }
    
    //计算Label坐标
    func calcuteTextPosition(with arcCenter: CGPoint, angle: CGFloat) -> CGPoint {
        let x = (self.scaleValueRadius - 15) * cosh(angle)
        let y = (self.scaleValueRadius - 15) * sinh(angle)
        return CGPoint(x: center.x + x, y: center.y - y)
    }
    
}

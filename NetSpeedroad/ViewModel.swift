//
//  ViewModel.swift
//  NetSpeedroad
//
//  Created by Sunny on 2018/10/24.
//  Copyright © 2018 Sunny. All rights reserved.
//

import Foundation

@objc final class ViewModel: NSObject {
    
    let downloadURL = URL(string: "https://qd.myapp.com/myapp/qqteam/pcqq/QQ9.0.7.exe")!
    var measurer: RunsNetSpeedMeasurer!
    var connectionType = "当前网络"
    var uplinkMaxSpeed: Double = 0
    var uplinkMinSpeed: Double = 0
    var uplinkAvgSpeed: Double = 0
    var uplinkCurSpeed: Double = 0
    var downlinkMaxSpeed: Double = 0
    var downlinkMinSpeed: Double = 0
    var downlinkAvgSpeed: Double = 0
    var downlinkCurSpeed: Double = 0
    var downloadTaskOne: URLSessionDownloadTask!
    var downloadTaskTwo: URLSessionDownloadTask!
    var downloadTaskThree: URLSessionDownloadTask!
    
    override init() {
        super.init()
        measurer = RunsNetSpeedMeasurer.init(accuracyLevel: 5, interval: 1.0)
        measurer.delegate = self
        measurer.measurerBlock = { [weak self] result in
            guard let weakSelf = self else {return}
            weakSelf.connectionType = result.connectionType.rawValue == 0 ? "WWAN-移动数据网络" : "WiFi-无线网络"
            weakSelf.uplinkMaxSpeed = result.uplinkMaxSpeed
            weakSelf.uplinkMinSpeed = result.uplinkMinSpeed
            weakSelf.uplinkAvgSpeed = result.uplinkAvgSpeed
            weakSelf.uplinkCurSpeed = result.uplinkCurSpeed
            weakSelf.downlinkMaxSpeed = result.downlinkMaxSpeed
            weakSelf.downlinkMinSpeed = result.downlinkMinSpeed
            weakSelf.downlinkAvgSpeed = result.downlinkAvgSpeed
            weakSelf.downlinkCurSpeed = result.downlinkCurSpeed
        }
    }
    
    func startDownload() {
        let sessionOne = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionTwo = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionThree = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        
        sessionOne.downloadTask(with: downloadURL)
        sessionTwo.downloadTask(with: downloadURL)
        sessionThree.downloadTask(with: downloadURL)
    }
    
}

extension ViewModel: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
}

extension ViewModel: RunsNetSpeedMeasurerDelegate {
    
    func measurer(_ measurer: ISpeedMeasurerProtocol, didCompletedByInterval result: RunsNetMeasurerResult) {
        
    }
    
}

//
//  ViewModel.swift
//  NetSpeedroad
//
//  Created by Sunny on 2018/10/24.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import SNYKit

@objc final class ViewModel: NSObject {
    
    var downloadURL1: URL?
    var downloadURL2: URL?
    var downloadURL3: URL?
    var downloadURL4: URL?
    var downloadURL5: URL?
    var downloadURL6: URL?
    var uploadURL1: URL?
    var uploadURL2: URL?
    var uploadURL3: URL?
    var uploadURL4: URL?
    var uploadURL5: URL?
    var uploadURL6: URL?
    
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
    
    let timerStopSec = 15
    var timerCurSec = 0
    var downloadCompleteHandler: (() -> Void)!
    
    override init() {
        super.init()
        
        measurer = RunsNetSpeedMeasurer.init(accuracyLevel: 5, interval: 1.0)
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
    
    @objc func timerStart() {
        SNY.gcd.scheduledDispatchTimer(WithTimerName: "Test", timeInterval: 1.0, queue: GCD.main, repeats: true) { [weak self] in
            guard let weakSelf = self else {return}
            if weakSelf.timerCurSec == weakSelf.timerStopSec {
                weakSelf.timerCurSec = 0
                weakSelf.doneTest()
                return
            } else {
                weakSelf.timerCurSec += 1
            }
            print("上传Max：\(String(format: "%.2f", weakSelf.uplinkMaxSpeed)), 上传Min：\(String(format: "%.2f", weakSelf.uplinkMinSpeed)), 上传Avg：\(String(format: "%.2f", weakSelf.uplinkAvgSpeed)), 上传Cur：\(String(format: "%.2f", weakSelf.uplinkCurSpeed))")
            print("下载Max：\(String(format: "%.2f", weakSelf.downlinkMaxSpeed)), 下载Min：\(String(format: "%.2f", weakSelf.downlinkMinSpeed)), 下载Avg：\(String(format: "%.2f", weakSelf.downlinkAvgSpeed)), 下载Cur：\(String(format: "%.2f", weakSelf.downlinkCurSpeed))")
            print("==================================")
        }
    }
    
    func startTest() {
        
        getAddrs { [weak self] isSucceed in
            guard let weakSelf = self else {return}
            if isSucceed {
                GCD.main.async {
                    weakSelf.measurer.execute()
                }
                weakSelf.downloadTest()
                weakSelf.timerStart()
            } else {
                // FIXME: 错误处理 - 更新Cocopods库 and back!
            }
            
        }
    }
    
    func doneTest() {
        if SNY.gcd.isExistTimer(WithTimerName: "Test") {
            SNY.gcd.cancleTimer(WithTimerName: "Test")
        }
        measurer.shutdown()
        print("----------------------------------")
        print("下载完成")
        print("==================================")
        print("上传最大速度：\(String(format: "%.2f", self.uplinkMaxSpeed))")
        print("上传最小速度：\(String(format: "%.2f", self.uplinkMinSpeed))")
        print("上传平均速度：\(String(format: "%.2f", self.uplinkAvgSpeed))")
        print("上传当前速度：\(String(format: "%.2f", self.uplinkCurSpeed))")
        print("==================================")
        print("下载最大速度：\(String(format: "%.2f", self.downlinkMaxSpeed))")
        print("下载最小速度：\(String(format: "%.2f", self.downlinkMinSpeed))")
        print("下载平均速度：\(String(format: "%.2f", self.downlinkAvgSpeed))")
        print("下载当前速度：\(String(format: "%.2f", self.downlinkCurSpeed))")
        print("----------------------------------")
        downloadCompleteHandler()
    }
    
    func downloadTest() {
        let sessionOne = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionTwo = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionThree = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionFour = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionFive = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionSix = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        
        sessionOne.downloadTask(with: downloadURL1!).resume()
        sessionTwo.downloadTask(with: downloadURL2!).resume()
        sessionThree.downloadTask(with: downloadURL3!).resume()
        sessionFour.downloadTask(with: downloadURL3!).resume()
        sessionFive.downloadTask(with: downloadURL3!).resume()
        sessionSix.downloadTask(with: downloadURL3!).resume()
    }
    
    //获取接口地址
    func getAddrs(completion: @escaping (Bool) -> Void) {
        if let carrier = SNY.getCarrier() {
            let strUrl = "http://api.netspeedtestmaster.com/st/v2/resources/list/?app_type=1&channel=AppStore&country=\(carrier.countryCode)&isp=\(carrier.carrierName)&network=\(carrier.networkType)"
            let url = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] (data, response, err) in
                guard let weakSelf = self else {return}
                if err == nil && data != nil {
                    if let dict = Utils.decodeJSON(data: data!) {
                        weakSelf.downloadURL1 = URL(string: (dict["download"] as! [String])[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL2 = URL(string: (dict["download"] as! [String])[1].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL3 = URL(string: (dict["download"] as! [String])[2].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL4 = URL(string: (dict["download"] as! [String])[3].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL5 = URL(string: (dict["download"] as! [String])[4].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL6 = URL(string: (dict["download"] as! [String])[5].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        
                        weakSelf.uploadURL1 = URL(string: (dict["upload"] as! [String])[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.uploadURL2 = URL(string: (dict["upload"] as! [String])[1].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.uploadURL3 = URL(string: (dict["upload"] as! [String])[2].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.uploadURL4 = URL(string: (dict["upload"] as! [String])[3].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.uploadURL5 = URL(string: (dict["upload"] as! [String])[4].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.uploadURL6 = URL(string: (dict["upload"] as! [String])[5].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            }
            dataTask.resume()
        }
    }
    
}

extension ViewModel: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let session1Done = downloadTask == downloadTaskOne && downloadTask.state == .completed
        let session2Done = downloadTask == downloadTaskTwo && downloadTask.state == .completed
        let session3Done = downloadTask == downloadTaskThree && downloadTask.state == .completed
        if session1Done && session2Done && session3Done {
            doneTest()
        }
    }
    
}

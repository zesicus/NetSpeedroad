//
//  ViewModel.swift
//  NetSpeedroad
//
//  Created by Sunny on 2018/10/24.
//  Copyright © 2018 Sunny. All rights reserved.
//

import UIKit
import SNYKit
import SVProgressHUD
import Reachability
import PlainPing

enum TestMode {
    case ping
    case download
    case upload
}

@objc final class MainViewModel: NSObject {
    
    fileprivate var testMode: TestMode = .ping
    
    fileprivate var pingAddrs = [String]()
    fileprivate var downloadURL1: URL?
    fileprivate var downloadURL2: URL?
    fileprivate var downloadURL3: URL?
    fileprivate var downloadURL4: URL?
    fileprivate var downloadURL5: URL?
    fileprivate var downloadURL6: URL?
    fileprivate var uploadURL1 = ""
    fileprivate var uploadURL2 = ""
    fileprivate var uploadURL3 = ""
    fileprivate var uploadURL4 = ""
    fileprivate var uploadURL5 = ""
    fileprivate var uploadURL6 = ""
    
    fileprivate var measurer: RunsNetSpeedMeasurer!
    
    fileprivate var downloadTaskOne: URLSessionDownloadTask!
    fileprivate var downloadTaskTwo: URLSessionDownloadTask!
    fileprivate var downloadTaskThree: URLSessionDownloadTask!
    fileprivate var downloadTaskFour: URLSessionDownloadTask!
    fileprivate var downloadTaskFive: URLSessionDownloadTask!
    fileprivate var downloadTaskSix: URLSessionDownloadTask!
    fileprivate var uploadTaskOne: URLSessionUploadTask!
    fileprivate var uploadTaskTwo: URLSessionUploadTask!
    fileprivate var uploadTaskThree: URLSessionUploadTask!
    fileprivate var uploadTaskFour: URLSessionUploadTask!
    fileprivate var uploadTaskFive: URLSessionUploadTask!
    fileprivate var uploadTaskSix: URLSessionUploadTask!
    
    fileprivate let timerStopSec = 15
    fileprivate var timerCurSec = 0
    
    //ping延迟队列
    fileprivate var pingResults = [Double]()
    
    var connectionType = ""
    var avgPing: Int = 0
    var uplinkMaxSpeed: Double = 0
    var uplinkMinSpeed: Double = 0
    var uplinkAvgSpeed: Double = 0
    var uplinkCurSpeed: Double = 0
    var downlinkMaxSpeed: Double = 0
    var downlinkMinSpeed: Double = 0
    var downlinkAvgSpeed: Double = 0
    var downlinkCurSpeed: Double = 0
    var bandwidth: Int = 0
    
    var pingExecutingHandler: ((Int) -> Void)!
    var downloadExecutingHandler: (() -> Void)!
    var uploadExecutingHandler: (() -> Void)!
    var pingCompletehandler: ((Int) -> Void)!
    var checkCompleteHandler: (() -> Void)!
    var testCompleteHandler: (() -> Void)!
    
    override init() {
        super.init()
        
        SVProgressHUD.setDefaultStyle(.dark)
        measurer = RunsNetSpeedMeasurer.init(accuracyLevel: 5, interval: 1.0)
        checkStatus()
    }
    
    //检测网络
    
    fileprivate func checkStatus() {
        let reachability = Reachability()!
        switch reachability.connection {
        case .wifi:
            connectionType = "Wi-Fi"
        case .cellular:
            connectionType = SNY.getCarrier()?.networkType ?? "移动网络"
        case .none:
            connectionType = "无网络"
        }
    }
    
    //测速执行
    
    func startTest() {
        
        getAddrs { [weak self] isSucceed in
            guard let weakSelf = self else {return}
            if isSucceed {
                GCD.main.async {
                    weakSelf.pingTest()
                }
            } else {
                SVProgressHUD.showError(withStatus: "接口获取失败")
            }
        }
        
    }
    
    //Ping
    
    fileprivate func pingTest() {
        if pingAddrs.isEmpty {
            //延迟检测完成
            avgPing = Int(pingResults.reduce(0, +) / Double(pingResults.count))
            pingCompletehandler(avgPing)
            testMode = .download
            downloadTest()
            return
        }
        let ping = pingAddrs.removeFirst()
        PlainPing.ping(ping, withTimeout: 0.5) { [weak self] (elapse, err) in
            if elapse != nil {
                self?.pingResults.append(elapse!)
                self?.pingExecutingHandler(Int(elapse!))
            }
            self?.pingTest()
        }
    }
    
    //下载
    
    fileprivate func downloadTest() {
        
        GCD.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.measurer.measurerBlock = { result in
                weakSelf.downlinkMaxSpeed = result.downlinkMaxSpeed
                weakSelf.downlinkMinSpeed = result.downlinkMinSpeed
                weakSelf.downlinkAvgSpeed = result.downlinkAvgSpeed
                weakSelf.downlinkCurSpeed = result.downlinkCurSpeed
            }
            weakSelf.measurer.execute()
        }
        
        
        let sessionOne = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionTwo = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionThree = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionFour = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionFive = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionSix = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        
        downloadTaskOne = sessionOne.downloadTask(with: downloadURL1!); downloadTaskOne.resume()
        downloadTaskTwo = sessionTwo.downloadTask(with: downloadURL2!); downloadTaskTwo.resume()
        downloadTaskThree = sessionThree.downloadTask(with: downloadURL3!); downloadTaskThree.resume()
        downloadTaskFour = sessionFour.downloadTask(with: downloadURL3!); downloadTaskFour.resume()
        downloadTaskFive = sessionFive.downloadTask(with: downloadURL3!); downloadTaskFive.resume()
        downloadTaskSix = sessionSix.downloadTask(with: downloadURL3!); downloadTaskSix.resume()
        
        timerStart()
    }
    
    //上传
    
    fileprivate func uploadTest() {
        
        measurer.measurerBlock = { [weak self] result in
            guard let weakSelf = self else {return}
            weakSelf.uplinkMaxSpeed = result.uplinkMaxSpeed
            weakSelf.uplinkMinSpeed = result.uplinkMinSpeed
            weakSelf.uplinkAvgSpeed = result.uplinkAvgSpeed
            weakSelf.uplinkCurSpeed = result.uplinkCurSpeed
        }
        measurer.execute()
        
        let sessionOne = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionTwo = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionThree = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionFour = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionFive = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        let sessionSix = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.init())
        
        uploadTaskOne = sessionOne.uploadTask(with: getUploadRequest(url: uploadURL1), fromFile: URL(string: Bundle.main.path(forResource: "UploadTestData", ofType: "txt")!)!); uploadTaskOne.resume()
        uploadTaskTwo = sessionTwo.uploadTask(with: getUploadRequest(url: uploadURL2), fromFile: URL(string: Bundle.main.path(forResource: "UploadTestData", ofType: "txt")!)!); uploadTaskTwo.resume()
        uploadTaskThree = sessionThree.uploadTask(with: getUploadRequest(url: uploadURL3), fromFile: URL(string: Bundle.main.path(forResource: "UploadTestData", ofType: "txt")!)!); uploadTaskThree.resume()
        uploadTaskFour = sessionFour.uploadTask(with: getUploadRequest(url: uploadURL4), fromFile: URL(string: Bundle.main.path(forResource: "UploadTestData", ofType: "txt")!)!); uploadTaskFour.resume()
        uploadTaskFive = sessionFive.uploadTask(with: getUploadRequest(url: uploadURL5), fromFile: URL(string: Bundle.main.path(forResource: "UploadTestData", ofType: "txt")!)!); uploadTaskFive.resume()
        uploadTaskSix = sessionSix.uploadTask(with: getUploadRequest(url: uploadURL6), fromFile: URL(string: Bundle.main.path(forResource: "UploadTestData", ofType: "txt")!)!); uploadTaskSix.resume()
        
        timerStart()
    }
    
    //下载 上传 测速完成
    
    fileprivate func doneTest() {
        if SNY.gcd.isExistTimer(WithTimerName: "Test") {
            SNY.gcd.cancleTimer(WithTimerName: "Test")
        }
        measurer.shutdown()
        switch testMode {
        case .ping:
            break
        case .download:
            downloadTaskOne.suspend()
            downloadTaskTwo.suspend()
            downloadTaskThree.suspend()
            downloadTaskFour.suspend()
            downloadTaskFive.suspend()
            downloadTaskSix.suspend()
            testMode = .upload
            bandwidth = Int(downlinkAvgSpeed * 8.0)
            uploadTest()
            break
        case .upload:
            testCompleteHandler()
            testMode = .ping
            pingResults.removeAll()
            avgPing = 0
            break
        }
    }
    
    //上传请求封装
    
    fileprivate func getUploadRequest(url: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let contentType = "multipart/form-data; boundary=----WebKitFormBoundaryftnnT7s3iF7wV5q6"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("SpeedTest/76 CFNetwork/974.2.1 Darwin/18.0.0", forHTTPHeaderField: "User-Agent")
        return request
    }
    
    //获取接口地址
    
    fileprivate func getAddrs(completion: @escaping (Bool) -> Void) {
        if let carrier = SNY.getCarrier() {
            let strUrl = "http://api.netspeedtestmaster.com/st/v2/resources/list/?app_type=1&channel=AppStore&country=\(carrier.countryCode)&isp=\(carrier.carrierName)&network=\(carrier.networkType)"
            let url = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] (data, response, err) in
                guard let weakSelf = self else {return}
                if err == nil && data != nil {
                    if let dict = Utils.decodeJSON(data: data!) {
                        
                        weakSelf.pingAddrs = dict["ping"] as! [String]
                        
                        weakSelf.downloadURL1 = URL(string: (dict["download"] as! [String])[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL2 = URL(string: (dict["download"] as! [String])[1].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL3 = URL(string: (dict["download"] as! [String])[2].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL4 = URL(string: (dict["download"] as! [String])[3].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL5 = URL(string: (dict["download"] as! [String])[4].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        weakSelf.downloadURL6 = URL(string: (dict["download"] as! [String])[5].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                        
                        weakSelf.uploadURL1 = (dict["upload"] as! [String])[0]
                        weakSelf.uploadURL2 = (dict["upload"] as! [String])[1]
                        weakSelf.uploadURL3 = (dict["upload"] as! [String])[2]
                        weakSelf.uploadURL4 = (dict["upload"] as! [String])[3]
                        weakSelf.uploadURL5 = (dict["upload"] as! [String])[4]
                        weakSelf.uploadURL6 = (dict["upload"] as! [String])[5]
                        
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            }
            dataTask.resume()
        }
    }
    
    //上传 下载 测速计时
    
    @objc fileprivate func timerStart() {
        SNY.gcd.scheduledDispatchTimer(WithTimerName: "Test", timeInterval: 1.0, queue: GCD.main, repeats: true) { [weak self] in
            guard let weakSelf = self else {return}
            if weakSelf.timerCurSec == weakSelf.timerStopSec {
                weakSelf.timerCurSec = 0
                weakSelf.doneTest()
                return
            } else {
                weakSelf.timerCurSec += 1
            }
            switch weakSelf.testMode {
            case .download:
                weakSelf.downloadExecutingHandler()
                break
            case .upload:
                weakSelf.uploadExecutingHandler()
                break
            case .ping:
                break
            }
        }
    }
    
}

extension MainViewModel: URLSessionTaskDelegate {
    
    fileprivate func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if testMode == .download {
            let session1Done = task == downloadTaskOne && task.state == .completed
            let session2Done = task == downloadTaskTwo && task.state == .completed
            let session3Done = task == downloadTaskThree && task.state == .completed
            let session4Done = task == downloadTaskFour && task.state == .completed
            let session5Done = task == downloadTaskFive && task.state == .completed
            let session6Done = task == downloadTaskSix && task.state == .completed
            if session1Done && session2Done && session3Done && session4Done && session5Done && session6Done {
                doneTest()
            }
        } else {
            let session1Done = task == uploadTaskOne && task.state == .completed
            let session2Done = task == uploadTaskTwo && task.state == .completed
            let session3Done = task == uploadTaskThree && task.state == .completed
            let session4Done = task == uploadTaskFour && task.state == .completed
            let session5Done = task == uploadTaskFive && task.state == .completed
            let session6Done = task == uploadTaskSix && task.state == .completed
            if session1Done && session2Done && session3Done && session4Done && session5Done && session6Done {
                doneTest()
            }
        }
    }
    
}



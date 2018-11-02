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

enum TestMode {
    case download
    case upload
}

@objc final class ViewModel: NSObject {
    
    var testMode: TestMode = .download
    
    var downloadURL1: URL?
    var downloadURL2: URL?
    var downloadURL3: URL?
    var downloadURL4: URL?
    var downloadURL5: URL?
    var downloadURL6: URL?
    var uploadURL1 = ""
    var uploadURL2 = ""
    var uploadURL3 = ""
    var uploadURL4 = ""
    var uploadURL5 = ""
    var uploadURL6 = ""
    
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
    var downloadTaskFour: URLSessionDownloadTask!
    var downloadTaskFive: URLSessionDownloadTask!
    var downloadTaskSix: URLSessionDownloadTask!
    var uploadTaskOne: URLSessionUploadTask!
    var uploadTaskTwo: URLSessionUploadTask!
    var uploadTaskThree: URLSessionUploadTask!
    var uploadTaskFour: URLSessionUploadTask!
    var uploadTaskFive: URLSessionUploadTask!
    var uploadTaskSix: URLSessionUploadTask!
    
    let timerStopSec = 15
    var timerCurSec = 0
    var downloadExecutingHandler: (() -> Void)!
    var uploadExecutingHandler: (() -> Void)!
    var checkCompleteHandler: (() -> Void)!
    var testCompleteHandler: (() -> Void)!
    
    override init() {
        super.init()
        
        SVProgressHUD.setDefaultStyle(.dark)
        measurer = RunsNetSpeedMeasurer.init(accuracyLevel: 5, interval: 1.0)
        checkStatus()
    }
    
    //检测网络
    
    func checkStatus() {
        let reachability = Reachability()!
        switch reachability.connection {
        case .wifi:
            connectionType = "当前网络：Wi-Fi"
        case .cellular:
            connectionType = "当前网络：移动数据"
        case .none:
            connectionType = "当前网络：无网络"
        }
    }
    
    //测速执行
    
    func startTest() {
        
        getAddrs { [weak self] isSucceed in
            guard let weakSelf = self else {return}
            if isSucceed {
                weakSelf.downloadTest()
            } else {
                SVProgressHUD.showError(withStatus: "接口获取失败")
            }
        }
        
    }
    
    //测速定时 15秒 未下载完成也停止
    
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
            switch weakSelf.testMode {
            case .download:
                weakSelf.downloadExecutingHandler()
                break
            case .upload:
                weakSelf.uploadExecutingHandler()
                break
            }
        }
    }
    
    //测速完成
    
    func doneTest() {
        if SNY.gcd.isExistTimer(WithTimerName: "Test") {
            SNY.gcd.cancleTimer(WithTimerName: "Test")
        }
        measurer.shutdown()
        switch testMode {
        case .download:
            testMode = .upload
            uploadTest()
            break
        case .upload:
            testCompleteHandler()
            testMode = .download
            break
        }
    }
    
    //下载
    
    func downloadTest() {
        
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
    
    func uploadTest() {
        
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
    
    //上传请求封装
    
    func getUploadRequest(url: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let contentType = "multipart/form-data; boundary=----WebKitFormBoundaryftnnT7s3iF7wV5q6"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("SpeedTest/76 CFNetwork/974.2.1 Darwin/18.0.0", forHTTPHeaderField: "User-Agent")
        return request
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
    
}

extension ViewModel: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
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



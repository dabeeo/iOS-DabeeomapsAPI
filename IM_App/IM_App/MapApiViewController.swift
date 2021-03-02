//
//  MapApiViewController.swift
//  IM_App
//
//  Created by Dabeeo on 2021/02/19.
//  Copyright © 2021 Dabeeo. All rights reserved.
//

import Foundation
import UIKit
import IM_SDK

enum MinMaxZoomValue: Int {
    case plus_max
    case minus_max
    case plus_min
    case minus_min
}

class MapApiViewController : UIViewController {
    var dabeeoSDK = IMSDK()
    var setView = UIView.init()
    var mapView = UIView()
    var floorInfoArray = NSMutableArray.init()
    var zoomView = UIView()
    
    var startPoint = navigationPoint.init() //출발지
    var destPoint = navigationPoint.init() //목적지
    
    private let buttonSize : CGFloat = 46
    
    @IBOutlet weak var menuScroll : UIScrollView!
    @IBOutlet weak var cView : UIView!
    
    //Button
    @IBOutlet weak var rotateUseButton : UIButton!
    @IBOutlet weak var zoomUseButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let options = IMSDKOptions.init()
        // 출발지 이미지 마커에 쓰일 이미지 설정 or SDK 디폴트 이미지 사용
        options.startPosImg = UIImage(named: "icon_start")
        options.endPosImg = UIImage(named: "icon_arrive")//nil
        dabeeoSDK.setIMSDKOption(option: options)
        dabeeoSDK.setDelegate(delegate: self)
        let arEnabled  : Bool = false //AR 사용여부
        
        let bounds = dabeeoSDK.startIMSDK(frame: self.view.frame, arEnabled: arEnabled, opt1: "", opt2: "", type: .mapSecret)
        setView = bounds.view
        self.view.addSubview(setView)
        self.view.sendSubviewToBack(setView)
        mapView = bounds.mapview
        menuScroll.contentSize = cView.frame.size
        self.drawUIButton()
    }
    
    func startNavigation(){
        guard startPoint.x != -1 && startPoint.y != -1 && startPoint.level != -1 else {
            print("Start Point Error")
            return
        }
        
        guard destPoint.x != -1 && destPoint.y != -1 && destPoint.level != -1 else {
            print("Destination Point Error")
            return
        }
        if let naviRoute : pathData = dabeeoSDK.findPath(startPosition:CGPoint.init(x: startPoint.x, y: startPoint.y) , startFloor: startPoint.level, destPosition: CGPoint.init(x: destPoint.x, y: destPoint.y), destFloor: destPoint.level, passThrough: nil, type: .none, naviType: .navigation) {
            guard naviRoute.routeList.count != 0 else {
                print("Route Not Found")
                return
            }
            dabeeoSDK.setFloor(level: startPoint.level)
            dabeeoSDK.drawNavigation(data: naviRoute)
        } else {
            print("해당 이동수단으로 출발-목적 경로를 찾을 수 없음")
        }
    }
}

extension MapApiViewController : IMSDKDelegate, IMDebugDelegate{
    func getArFrameImage(imageData: Data) {
    }
    
    func error(code: String, message: String) {
    }
    
    func onSuccessDrawMap(floorArray: NSMutableArray, currentLevel: Int) {
        guard floorArray.count != 0 else {
            return
        }
        self.floorInfoArray = floorArray
        self.drawFloorScroll(currentLevel: currentLevel)
    }
    
    func click(point: CGPoint!, level: Int, objectInfo: NSDictionary) {
        
    }
    
    func longClick( point:CGPoint!, level:Int) {
        var fetchedArray = Array<Any>()
        var title : String = ""
        autoreleasepool {
            var predicate = NSPredicate(format: "level == %i", level)
            fetchedArray = self.floorInfoArray.filtered(using: predicate)
            guard fetchedArray.count == 1 else {
                return
            }
            guard let targetFloorData: NSDictionary = fetchedArray[0] as? NSDictionary else {
                return
            }
            guard let nameArray = targetFloorData.object(forKey: "name") as? NSArray else {
                return
            }
            let langStr = Locale.current.languageCode
            predicate = NSPredicate(format: "lang == %@", langStr!)
            fetchedArray = nameArray.filtered(using: predicate)
        
            if fetchedArray.count == 0 {
                guard let langdata: NSDictionary = nameArray[0] as? NSDictionary else {
                    return
                }
                title = langdata.object(forKey: "text") as! String
            }else{
                guard let langdata: NSDictionary = fetchedArray[0] as? NSDictionary else {
                    return
                }
                title = langdata.object(forKey: "text") as! String
            }
        }
        
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0, execute: {
                let message : String = "\nX : \(point.x)\nY : \(point.y)\n"
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "출발지", style: .default) { (action) in
                    self.startPoint.level = level
                    self.startPoint.x = point.x
                    self.startPoint.y = point.y
                    
                    guard self.destPoint.x != -1 && self.destPoint.y != -1 && self.destPoint.level != -1 else {
                        print("Destination Point Error")
                        return
                    }
                    
                    self.startNavigation()
                }
                let cancelAction = UIAlertAction(title: "목적지", style: .default) { (action) in
                    self.destPoint.level = level
                    self.destPoint.x = point.x
                    self.destPoint.y = point.y
                    
                    guard self.startPoint.x != -1 && self.startPoint.y != -1 && self.startPoint.level != -1 else {
                        print("Start Point Error")
                        return
                    }
                    
                    self.startNavigation()
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                if self.presentedViewController == nil {
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func onPrediction(count: Int32, retryCount: Int32, result: Bool) {
        
    }
    
    func onLocation(position: CGPoint, level: Int) {
        
    }
    
    func onNavigationRoute(routeIdx: Int, targetIdx: Int, snapPoint: CGPoint, currentPoint: CustomPoint) {
        
    }
    
    func endNavigation(type: navigationType) {
        
    }
    
    func onChangeFloorAtTrans(targetIdx: Int) {
        
    }
    
    func onMapList(mapList: NSArray) {
        
    }
    
    func clickObject<T>(object: inout T) {
        
    }
    
    func debugData(data: NSMutableDictionary) {
        
    }
    
    
}
extension MapApiViewController{ //Button Event
    
    //rotate Enabled
    @IBAction func rotateUseSetting(){
        let useRotate = dabeeoSDK.getEnableRotation()
        guard useRotate else {
            rotateUseButton.setTitle("Rotate = T", for: .normal)
            dabeeoSDK.setEnableRotation(isUse: true)
            return
        }
        rotateUseButton.setTitle("Rotate = F", for: .normal)
        dabeeoSDK.setEnableRotation(isUse: false)
    }
    
    //zoom Enabled
    @IBAction func zoomUseSetting(){
        let useZoom = dabeeoSDK.getUseZoomGesture()
        
        guard useZoom else {
            zoomUseButton.setTitle("Zoom = T", for: .normal)
            dabeeoSDK.setUseZoomGesture(isUse: true)
            return
        }
        zoomUseButton.setTitle("Zoom = F", for: .normal)
        dabeeoSDK.setUseZoomGesture(isUse: false)
    }
    
    //rotate Degree Setting
    
    // +Angle
    @IBAction func rightTurnAngle(){
        let currentDegree : Float = dabeeoSDK.getAngle()
        dabeeoSDK.setAngle(degree: currentDegree + 10)
    }
    // -Angle
    @IBAction func leftTurnAngle(){
        let currentDegree : Float = dabeeoSDK.getAngle()
        dabeeoSDK.setAngle(degree: currentDegree - 10)
    }
    
    //3Dtilt Degree Setting
    
    // +tilt
    @IBAction func tiltPlus(){
        let currentTilt : Float = dabeeoSDK.getMapTilt()
        dabeeoSDK.setMapTilt(degree: currentTilt + 10)
    }
    // -tilt
    @IBAction func tiltMinus(){
        let currentTilt : Float = dabeeoSDK.getMapTilt()
        dabeeoSDK.setMapTilt(degree: currentTilt - 10)
    }
    
    @IBAction func plusMaxZoom() {
        self.setMinMaxZoomValue(editZoom: .plus_max)
    }
    
    @IBAction func minusMaxZoom() {
        self.setMinMaxZoomValue(editZoom: .minus_max)
    }
    
    @IBAction func plusMinZoom() {
        self.setMinMaxZoomValue(editZoom: .plus_min)
    }
    
    @IBAction func minusMinZoom() {
        self.setMinMaxZoomValue(editZoom: .minus_min)
    }
    
    func setMinMaxZoomValue(editZoom: MinMaxZoomValue) {
        switch editZoom {
        case .plus_max:
            self.dabeeoSDK.setMaxZoomValue(value: 1)
        case .minus_max:
            self.dabeeoSDK.setMaxZoomValue(value: -1)
        case .plus_min:
            self.dabeeoSDK.setMinZoomValue(value: 1)
        case .minus_min:
            self.dabeeoSDK.setMinZoomValue(value: -1)
        }
        self.dabeeoSDK.setMapZoom()
    }

    
   // setMapTilt
    
}
extension MapApiViewController: UIScrollViewDelegate{ // UIDRAW
    func drawUIButton() {
        zoomView.frame = CGRect(x: self.mapView.frame.size.width - buttonSize - 14, y: 20 + 25, width: buttonSize, height: buttonSize*4 + 3)
        zoomView.backgroundColor =  UIColor.setColor(78, 78, 78, 1)
        
        let zoomInButton = UIButton()
        let zoomOutButton = UIButton()
        let TwoDButton = UIButton()
        let ThreeDButton = UIButton()
        
        zoomInButton.backgroundColor = UIColor.setColor(51, 51, 51, 1)
        zoomOutButton.backgroundColor = UIColor.setColor(51, 51, 51, 1)
        TwoDButton.backgroundColor = UIColor.setColor(51, 51, 51, 1)
        ThreeDButton.backgroundColor = UIColor.setColor(51, 51, 51, 1)
        
        zoomInButton.addTarget(self, action: #selector(zoomIn(sender:)), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOut(sender:)), for: .touchUpInside)
        TwoDButton.addTarget(self, action: #selector(twoD(sender:)), for: .touchUpInside)
        ThreeDButton.addTarget(self, action: #selector(threeD(sender:)), for: .touchUpInside)
        
        zoomInButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        zoomOutButton.frame = CGRect(x: 0, y: buttonSize+1, width: buttonSize, height: buttonSize)
        TwoDButton.frame = CGRect(x: 0, y: (buttonSize+1)*2, width: buttonSize, height: buttonSize)
        ThreeDButton.frame = CGRect(x: 0, y: (buttonSize+1)*3, width: buttonSize, height: buttonSize)
        
        zoomInButton.setTitle("+", for: .normal)
        zoomOutButton.setTitle("-", for: .normal)
        TwoDButton.setTitle("2D", for: .normal)
        ThreeDButton.setTitle("3D", for: .normal)
        
        zoomView.addSubview(zoomInButton)
        zoomView.addSubview(zoomOutButton)
        zoomView.addSubview(TwoDButton)
        zoomView.addSubview(ThreeDButton)
        
        self.view.addSubview(zoomView)
    }
    
    func drawFloorScroll(currentLevel : Int) {
        let buttonSize  = CGSize.init(width: 46, height: 46) //1 button size == 46
        //Max viewCount == 5
        let floorScroll = UIScrollView()
        floorScroll.showsVerticalScrollIndicator = false
        floorScroll.bounces = false
        floorScroll.isScrollEnabled = true
        floorScroll.delegate = self
        
        var scrollHeight : CGFloat = 0
        let contentsHeight : CGFloat = buttonSize.height * CGFloat(floorInfoArray.count) + (CGFloat(floorInfoArray.count) - 1)
        if self.floorInfoArray.count >= 5 {
            scrollHeight = buttonSize.height * 5 + (CGFloat(floorInfoArray.count) - 1)
        }else{
            scrollHeight = buttonSize.height * CGFloat(floorInfoArray.count) + (CGFloat(floorInfoArray.count) - 1)
        }
        floorScroll.frame = CGRect.init(x: 25, y: self.view.safeAreaInsets.top, width: buttonSize.width, height: scrollHeight)
        floorScroll.contentSize = CGSize.init(width: buttonSize.width, height: contentsHeight)
        floorScroll.backgroundColor = UIColor.init(displayP3Red: 78/255, green: 78/255, blue: 78/255, alpha: 1)
        
        for i in 0..<self.floorInfoArray.count {
            guard let fInfo = self.floorInfoArray.object(at: i) as? NSDictionary else {
                return
            }
            guard let fname = fInfo.object(forKey: "name") as? NSArray else {
                return
            }
            
            let floorButton = UIButton()
            let level = fInfo.object(forKey: "level") as! Int
            floorButton.tag = level
            floorButton.backgroundColor = UIColor.init(displayP3Red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            floorButton.frame = CGRect.init(x: 0, y: (buttonSize.height + 1) * CGFloat(i), width: buttonSize.width, height: buttonSize.height)
            if level == currentLevel {
                floorButton.setTitleColor(UIColor.red, for: .normal)
            }else{
                floorButton.setTitleColor(UIColor.white, for: .normal)
            }
            floorButton.setTitle(((fname.object(at: 0) as! NSDictionary).object(forKey: "text") as! String), for: .normal)
            floorButton.addTarget(self, action: #selector(changeFloor(sender:)), for: .touchUpInside)
            floorScroll.addSubview(floorButton)
        }
        self.view.addSubview(floorScroll)
        self.view.bringSubviewToFront(floorScroll)
        //arView.sendsu
    }
    
     @objc func changeFloor(sender: UIButton) {
        let fLevel = sender.tag
        dabeeoSDK.setFloor(level: fLevel)
        //print(fLevel)
    }
    @objc func zoomIn(sender: UIButton) {
        dabeeoSDK.zoomIn()
    }
    @objc func zoomOut(sender: UIButton) {
        dabeeoSDK.zoomOut()
    }
    @objc func twoD(sender: UIButton) {
        dabeeoSDK.setCameraMode(mode: false)
    }
    @objc func threeD(sender: UIButton) {
        dabeeoSDK.setCameraMode(mode: true)
    }
}

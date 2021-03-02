//
//  ARViewController.swift
//  IM_App
//
//  Created by Dabeeo on 2020/06/08.
//  Copyright © 2020 Dabeeo. All rights reserved.
//

import UIKit
import IM_SDK
import ARKit
import CoreMotion
import RealityKit

let motionManager = CMMotionManager()

struct navigationPoint{
    var x : CGFloat
    var y : CGFloat
    var level : Int
    init() {
        self.x = -1
        self.y = -1
        self.level = -1
    }
}

class ARViewController: UIViewController, UIGestureRecognizerDelegate, ARSCNViewDelegate
{
    var isSetCustomARNode: Bool = false
    var dabeeoSDK = IMSDK()
    var pathD : pathData?
    var arView = ARSCNView.init()
    var setView = UIView.init()
    var mapView = UIView.init()
    
    var startPoint = navigationPoint.init() //출발지
    var destPoint = navigationPoint.init() //목적지
    var floorInfoArray = NSMutableArray.init()
    var isNavigating: Bool = false
    var transportType: transportType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let options = IMSDKOptions.init()
        // 출발지 이미지 마커에 쓰일 이미지 설정 or SDK 디폴트 이미지 사용
        options.startPosImg = UIImage(named: "icon_start")
        options.endPosImg = UIImage(named: "icon_arrive")
        gyroscopeSensor() // 기울기 센서
        
        dabeeoSDK.setDelegate(delegate: self)
        dabeeoSDK.setIMSDKOption(option: options)
        
        let arEnabled  : Bool = true //AR 사용여부
        
        let bounds = dabeeoSDK.startIMSDK(frame: self.view.frame, arEnabled: arEnabled, opt1: "", opt2: "", type: .mapSecret)

        setView = bounds.view
        self.view.addSubview(setView)
        self.view.sendSubviewToBack(setView)
        
        if arEnabled == true {
            arView = bounds.arView!
            mapView = bounds.mapview
            arView.delegate = self
        }
        self.addHandler()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func mode2D(){
        dabeeoSDK.setCameraMode(mode: false)
    }
    @IBAction func mode3D(){
        dabeeoSDK.setCameraMode(mode: true)
    }
    @IBAction func ZoomIn(){
        dabeeoSDK.zoomIn()
    }
    @IBAction func ZoomOut(){
        dabeeoSDK.zoomOut()
    }
    
    @IBAction func startNavigation(){
        self.isNavigating = false
        
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
            
            self.isNavigating = true
            pathD = naviRoute
            dabeeoSDK.setFloor(level: startPoint.level)
            dabeeoSDK.drawNavigation(data: naviRoute)
        } else {
            print("해당 이동수단으로 출발-목적 경로를 찾을 수 없음")
        }
    }
    
    @IBAction func ARTESTBTN(){
        // 클라이언트에서 추가할 AR Content의 코드 작성
        
    }
    
    func gyroscopeSensor(){
        if motionManager.isGyroAvailable {
            motionManager.deviceMotionUpdateInterval = 0.2;
            motionManager.startDeviceMotionUpdates()
            motionManager.gyroUpdateInterval = 0.2
            guard let currentQueue = OperationQueue.current else { return }
            motionManager.startGyroUpdates(to: currentQueue) { (gyroData, error) in
                if error != nil {
                    print("error : ",error as Any)
                }
                guard let att = motionManager.deviceMotion?.attitude else { return }
                self.motionGuide(pitch: att.pitch)
            }
        }
    }
    
    func motionGuide(pitch : Double){
        
    }

}

extension ARViewController : UIScrollViewDelegate{ // MAP UI
    func addHandler(){
        let dragView = UIView()
        dragView.frame = CGRect.init(x: 0, y: 0, width: mapView.frame.width, height: 20)// hdight Defalt
        dragView.backgroundColor = UIColor.init(displayP3Red: 17/255, green: 17/255, blue: 17/255, alpha: 0.6)
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(drag))
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        panGesture.delegate = self
        dragView.isUserInteractionEnabled = true
        dragView.addGestureRecognizer(panGesture)
        mapView.addSubview(dragView)
    }
    
    @objc func drag(sender: UIPanGestureRecognizer) {
       let safeAreaTop : CGFloat =  self.view.safeAreaInsets.top
       let safeAreaBottom : CGFloat =  self.view.safeAreaInsets.bottom
       let translation = sender.translation(in: self.view) // translation의 값은 전체 뷰에서 뽑아 오도록
       if !(safeAreaTop >= mapView.frame.origin.y + translation.y) {
            if mapView.frame.size.height - translation.y > safeAreaBottom + 20{ //20은 사용자가 설정한 bar 사이즈
                mapView.center = CGPoint.init(x: mapView.center.x, y: mapView.center.y + translation.y)
                print("Center :",mapView.center.y + translation.y)
                mapView.frame.size.height =  mapView.frame.size.height - translation.y
                dabeeoSDK.setMapSize(size: mapView.frame.size)
            }
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
        
    func removeConstraints(view : UIView) {
        for c : NSLayoutConstraint in view.constraints {
            view.removeConstraint(c)
        }
    }

    // Draw Floor Scroll
    
    func drawFloorScroll() {
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
            floorButton.tag = fInfo.object(forKey: "level") as! Int
            floorButton.backgroundColor = UIColor.init(displayP3Red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            floorButton.frame = CGRect.init(x: 0, y: (buttonSize.height + 1) * CGFloat(i), width: buttonSize.width, height: buttonSize.height)
            floorButton.setTitle(((fname.object(at: 0) as! NSDictionary).object(forKey: "text") as! String), for: .normal)
            floorButton.addTarget(self, action: #selector(changeFloor(sender:)), for: .touchUpInside)
            floorScroll.addSubview(floorButton)
        }
        self.view.addSubview(floorScroll)
        self.view.bringSubviewToFront(floorScroll)
    }
    
     @objc func changeFloor(sender: UIButton) {
        let fLevel = sender.tag
        dabeeoSDK.setFloor(level: fLevel)
    }
}

extension ARViewController : IMSDKDelegate {
    func getArFrameImage(imageData: Data) {
    }
    
    func onMapList(mapList: NSArray) {
    }
    
    func onChangeFloorAtTrans(targetIdx: Int) {
    }
    
    func onSuccessDrawMap(floorArray: NSMutableArray, currentLevel: Int) {
        guard floorArray.count != 0 else {
            return
        }
        self.floorInfoArray = floorArray
        self.drawFloorScroll()
    }
    
    func endNavigation(type: navigationType) {
        
    }
    
    func onLocation(position: CGPoint, level: Int) {
        //print("onLocation")
        //print(position)
        //print(level)
    }
    
 
    
    func onNavigationRoute(routeIdx: Int, targetIdx: Int, snapPoint: CGPoint , currentPoint : CustomPoint) {
        
        guard let routeList = pathD?.routeList.object(at: routeIdx) as? routes else {
           return
        }
        
        guard let paths = routeList.pathList.object(at: 0) as? path else {
           return 
        }
        guard let nowNode = paths.nodeDataList.object(at: targetIdx) as? nodeData else {
           return
        }
        print("\(nowNode)")
        
        // floorId로 프리디케애트 생성
    }
    
    func error( code:String, message:String) {
        print("code: \(code), message: \(message)")
    }
    
    func click(point: CGPoint!, level: Int, objectInfo: NSDictionary) {
        print("Title : ",objectInfo.object(forKey: "title") as! String)
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
                }
                let cancelAction = UIAlertAction(title: "목적지", style: .default) { (action) in
                    self.destPoint.level = level
                    self.destPoint.x = point.x
                    self.destPoint.y = point.y
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                if self.presentedViewController == nil {
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
 
    func onPrediction(count:Int32, retryCount:Int32, result:Bool) {
        
    }

    func clickObject<T>( object:inout T) {
    }

    func addObject<T>( object:inout T) {
    }

    func removeObject<T>( removeYN:Bool, object:inout T) {
    }
}


@available(iOS 13.0, *)
extension ARViewController{ // ARContets
    func getVisibleContents(contentsArray : NSMutableArray, currentPos : CGPoint) -> NSMutableArray {
        guard contentsArray.count != 0 else {
            return NSMutableArray()
        }

        let visibleArray = NSMutableArray()
        let arScale : CGFloat = 100 / 10   //(PIXEL_TO_AR_RATIO / mapScale<과학관 10, 사무실 1>)
        for i in 0..<contentsArray.count {
            guard let contentsDic = contentsArray.object(at: i) as? NSDictionary else {
                return NSMutableArray()
            }
            
            guard let detailDistance = contentsDic.object(forKey: "detailDistance") as? Int else {
                return NSMutableArray()
            }
            
            guard let posX = (contentsDic.object(forKey: "position") as? NSDictionary)?.object(forKey: "x") as? Double else{
                return NSMutableArray()
            }
            guard let posY = (contentsDic.object(forKey: "position") as? NSDictionary)?.object(forKey: "y") as? Double else{
                return NSMutableArray()
            }
            
            let distanceDiff = Int(self.getDistanceTwoPoint(p1: currentPos, p2: CGPoint(x: posX, y: posY)) / arScale)
            
            if distanceDiff <= detailDistance {
                visibleArray.add(contentsDic)
            }
        }
        return visibleArray
    }

    func getDistanceTwoPoint(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
      return  sqrt(pow(abs(p2.x - p1.x), 2) + pow(abs(p2.y - p1.y), 2))
    }

}

extension ARViewController{
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
}

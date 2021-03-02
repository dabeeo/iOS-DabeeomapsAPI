# IMSDK for iOS
​
​
본 저장소는 IMSDK를 보다 쉽게 적용하기 위한 튜토리얼 프로젝트를 제공합니다.
​
## API 문서
- [API 문서로 이동](https://github.com/dabeeo/iOS-DabeeomapsAPI/blob/master/IMSDK_iOS_API_v1.00.00.pdf)
​
​
## 프로젝트 설정

### IMSDK 추가
- ``` IM_SDK.famework ``` 파일을 프로젝트 내 ``` IM_App/ ``` 안에 넣어줍니다.
​
### IMSDK 설정
- MyProject -> TARGETS -> Frameworks, Libraries, and Embedded Content -> ```Embed & Sign``` 으로 설정
- Deployment Target을 13.0 이상으로 설정합니다.
​
### Info.plist Setting

 Https 통신을 허용합니다.
​
  ```swift
  <key>NSAppTransportSecurity</key>
   <dict> 
     <key>NSAllowsArbitraryLoads</key>
     <true/>
   </dict>
  ```
  
  카메라 권한을 허용합니다.

``` swift
  <string>use camera</string>
```
  
  ## 샘플 코드 (Swift)
  <details>
  <summary>SDK 인스턴스 생성 및 설정</summary>
  
  ### IMSDK 인스턴스 생성 및 Delegate와 IMSDKOption 설정
  
  > Import SDK

```swift
    import IM_SDK
```

> IMSDK 인스턴스 생성

```swift
    var dabeeoSDK = IMSDK()
```

> Delegate 설정

```swift
    dabeeoSDK.setDelegate(delegate: self)
```

> Option 설정

```swift
    let options = IMSDKOptions.init()
    options.startPosImg = UIImage(named: "icon_start")
    options.endPosImg = UIImage(named: "icon_arrive")
    dabeeoSDK.setIMSDKOption(option: options)
```
</details>

<details>
<summary>CallBack Protocol</summary>

### IMSDK Delegate 설정시 전달되면 프로토콜 목록

>Protocol

```swift
    func error(code: String, message: String) 
    // SDK내의 모든 Error를 Client에게 알려줄 ErrorEvent
    
    func onSuccessDrawMap(floorArray : NSMutableArray, currentLevel : Int) 
    // 지도가 모두 그려지면 리턴
    
    func click(point: CGPoint!, level: Int, objectInfo : NSDictionary) 
    // 클릭한 포인트의 가장 가까운 노드를 검색하여 그 노의가 object를 가지고 있는지 판단 후 해당 object 정보 리턴
    
    func longClick(point:CGPoint!, level:Int) 
    // longPress를 통하여 시작점과 출발점을 사용자가 정의 할 수 있도록 제공할 Event 

    func onLocation(position : CGPoint, level : Int)
    // 측위에 성공하면 현재의 위치를 리턴
    
    func onNavigationRoute(routeIdx : Int, targetIdx : Int, snapPoint : CGPoint, currentPoint : CustomPoint)
    // 내비게이션 진행중 현재의 위치와 노드 정보를 리턴
    
    func endNavigation(type: navigationType) 
    // 네비게이션이 종료시 리턴
    
    func onChangeFloorAtTrans(targetIdx : Int)
    // 이동수단을 통하여 층이 변경되면 리턴    
```
</details>

<details>
<summary>지도 불러오기</summary>

### SDK의 실행, Map Load

>StartIMSDK
```swift
    let bounds = dabeeoSDK.startIMSDK(frame: self.view.frame, arEnabled: arEnabled, opt1: "", opt2: "", type: .mapSecret)
    // opt1 ClientId , opt2 ClientSecret
    
    setView = bounds.view
    self.view.addSubview(setView)
    self.view.sendSubviewToBack(setView)   
```
</details>

<details>
<summary>지도 제어</summary>

### 지도 내 기능을 제어하는 방법을 설명합니다.

> 지도 확대/축소 

```swift
    dabeeoSDK.setUseZoomGesture(isUse: true)
    // Zoom 사용 여부
    
    dabeeoSDK.setZoomLevel(value: 5.0)
```

> 지도 이동, 회전, Tilt

```swift
    dabeeoSDK.moveTo(point: CGPoint(x: 800, y: 400))
    // 원하는 포인트로 중심 이동

    dabeeoSDK.setEnableRotation(isUse: false)
    // 지도 회전 사용 여부
    
    dabeeoSDK.setAngle(degree: 10)
    
    dabeeoSDK.setUsetTiltGesture(isUse: false)
    // 3D Map에서 tilt 사용 여부
    
    dabeeoSDK.setMapTilt(degree: 10)
```

> 층 변경하기

```swift
    dabeeoSDK.setFloor(level: startPoint.level)
    // 지도의 층을 변경합니다.
```

> 지도 모드 변경

```swift
    dabeeoSDK.setCameraMode(mode: false)
    // true : 2D 모드
    // false : 3D 모드
```

</details>

<details>
<summary>마커 표시하기</summary>

### 지도 내에 다양한 마커를 추가/삭제하는 방법을 설명합니다.

> 사용자 정의 마커

```swift
    let addMarkerArr: NSMutableArray = NSMutableArray()
    let markerPos: NSMutableDictionary = NSMutableDictionary()
    markerPos.setValue(poiId, forKey: "poiId")
    markerPos.setValue(objectId, forKey: "objectId")
    markerPos.setValue(posX, forKey: "markerX")
    markerPos.setValue(posY, forKey: "markerY")
    markerPos.setValue(posZ, forKey: "markerZ")
    markerPos.setValue(floorLevel, forKey: "markerLevel")
    markerPos.setValue(angle, forKey: "markerAngle")
    markerPos.setValue(title, forKey: "markerTitle")
    markerPos.setValue(isSelected, forKey: "isSelected")
    addMarkerArr.add(markerPos)
    dabeeoSDK.setMarker(addMarkerArr: addMarkerArr) 
```

> 마커 제거

```swift
    dabeeoSDK.removeMarker(markerIdArr: NSArray)
```
</details>

<details>
<summary>길 찾기 요청</summary>

### 출/도착지 및 경유지를 설정하여 길 찾기를 요청합니다.

> 시작 위치와 도착 위치 및 이동 수단, 내비게이션 타입을 지정하여 길 찾기를 요청합니다.

```swift
    if let naviRoute : pathData = dabeeoSDK.findPath(startPosition:CGPoint.init(x: startPoint.x, y: startPoint.y) , startFloor: startPoint.level, destPosition: CGPoint.init(x: destPoint.x, y: destPoint.y), destFloor: destPoint.level, passThrough: nil, type: .none, naviType: .navigation) {
```
</details>

<details>
<summary>내비게이션 기능</summary>

### 길 찾기 이후 내비게이션 기능을 제어하는 방법을 설명합니다.

> 내비게이션 실행

```swift
    dabeeoSDK.startNavigation(data: naviRoute)
```

> 내비게이션 종료

```swift
    dabeeoSDK.stopNavigation(type: navigationType)
```

</details>

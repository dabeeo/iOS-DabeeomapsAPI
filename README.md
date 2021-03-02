# IMSDK for iOS
​
​
본 저장소는 IMSDK를 보다 쉽게 적용하기 위한 튜토리얼 프로젝트를 제공합니다.
​
## API 문서
- [Project 폴더 안에 IMSDK_iOS_API_v1.00.00.pdf]
​
​
## 프로젝트 설정
​
### IMSDK 추가
- ``` IM_SDK.famework ``` 파일을 프로젝트 내 ``` IM_App/ ``` 안에 넣어줍니다.
​
### IMSDK 설정
- MyProject -> TARGETS -> Frameworks, Libraries, and Embedded Content -> ```Embed & Sign``` 으로 설정
- Deployment Target을 13.0 이상으로 설정합니다.
​
### Info.plist Setting
​
* Https 통신을 허용합니다.
​
  ```swift
  <key>NSAppTransportSecurity</key>
   <dict> 
     <key>NSAllowsArbitraryLoads</key>
     <true/>
   </dict>
  ```

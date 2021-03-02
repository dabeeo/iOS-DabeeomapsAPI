//
//  TwoDimeContents.swift
//  IM_App
//
//  Created by Dabeeo on 2020/11/09.
//  Copyright © 2020 Dabeeo. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import ARKit
class TwoDimeContents: UIView{
    var contetnsImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contetnsImage.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setContetns(imageUrl : String){
        guard let iUrl = URL(string: imageUrl) else {
            return
        }
        print("iUrl : ",iUrl)
        
    DispatchQueue.global().async {
        if let data = try? Data( contentsOf:iUrl)
        {
            DispatchQueue.main.async {
                self.contetnsImage.image = UIImage(data:data)
            }
        }
    }
    
       // self.contetnsImage.image = downloadedFrom(url: iUrl, newSize: self.frame.size)
    }
    
//    func downloadedFrom(url: URL, newSize: CGSize) -> UIImage {
//        let config = URLSessionConfiguration.default
//        config.requestCachePolicy = .reloadIgnoringLocalCacheData
//        config.urlCache = nil
//
//        var resultImg: UIImage = UIImage()
//
//        let session = URLSession.init(configuration: config)
//        session.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async {
//                resultImg = image.resizedImage(newSize: newSize)//image
//            }
//        }.resume()
//
//        print(resultImg)
//        return resultImg
//    }
//}
//
//extension UIImage {
//    func resizedImage(newSize: CGSize) -> UIImage {
//           guard self.size != newSize else { return self }
//           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//           self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//           let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//           UIGraphicsEndImageContext()
//           //print("resizedImage \(newImage.size)")
//           return newImage
//    }
//}
    
}

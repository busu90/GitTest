//
//  UIimageView-Cache.swift
//  GitTest
//
//  Created by Andrei Busuioc on 6/30/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

extension UIImageView{
    private struct AssociatedKeys {
        static var absoluteUrl = "absoluteUrl"
    }
    
    var absoluteUrl: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.absoluteUrl) as? String
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.absoluteUrl,
                    newValue as NSString?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}

extension UIImageView{
    func setImageAt(urlString: String?, placeholderImg: UIImage){
        guard let urlString = urlString else {
            image = placeholderImg
            return
        }
        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString){
            image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else {
            image = placeholderImg
            return
        }
        image = placeholderImg
        absoluteUrl = urlString
        let imgDownload = URLSession(configuration: .default, delegate: nil, delegateQueue: .main).dataTask(with: url){[weak self](data, response, error) in
            if error == nil && (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        if let requestString = response!.url?.absoluteString, image != nil{
                            ImageCache.shared.setObject(image!, forKey: requestString as NSString)
                            if requestString == self?.absoluteUrl{
                                self?.image = image
                            }
                        }
                    } else {
                        print("Image file is currupted")
                    }
            }
        }
        imgDownload.resume()
    }
}

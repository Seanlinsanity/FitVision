//
//  CustomImageView.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/2.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
//store image into the cache

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlData(_ urlString: String) {
        
        imageUrlString = urlString
        
        image = nil
        
        //get the image from cache if it's available to find it
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url, completionHandler: {(data, respones, error) in
                
                if error != nil {
                    print(error ?? "error")
                    return
                }
                DispatchQueue.main.async (execute: {
                    
                    guard let imageData = data else { return }
                    
                    if let downloadImage = UIImage(data: imageData) {
                        
                        imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                        
                        if self.imageUrlString == urlString {
                            self.image = downloadImage
                        }
                    }
                    
                })
                
            }).resume()
        }
    }
    
}


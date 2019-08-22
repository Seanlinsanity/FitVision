//
//  Video.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var thumbnailImageUrl: String?
    var title: String?
    var numberOfViews: NSNumber?
    var publishedAt: NSNumber?
    var videoId: String?
    var videoDescription: String?
    var timeStamp: Int?
    var subtitleArray: [[String: Any]]?
    var min: String?
    var sec: String?
    var hour: String?
    var time : Float = 0.0
    var subtitle: String?
    var categories = [String]()
    var addLikeDate: Date = Date(timeIntervalSince1970: 0)
    
    var channel: Channel?
    var relatedVideosId : [String]?
    var relatedVideos = [Video]()
    
    func setupDuration() -> String{
        
        var duration = ""
        guard let min = self.min else { return ""}
        if min.count < 2 {
            self.min = "0\(min)"
        }
        
        guard let sec = self.sec else { return ""}
        if sec.count < 2 {
            self.sec = "0\(sec)"
        }
        
        duration = "\(self.min ?? "00"):\(self.sec ?? "00")"
        
        if let hour = self.hour {
            if hour.count < 2 {
                self.hour = "0\(hour)"
            }
            duration = "\(self.hour ?? "00"):\(self.min ?? "00"):\(self.sec ?? "00")"
        }
        
        return duration
    }
        
}

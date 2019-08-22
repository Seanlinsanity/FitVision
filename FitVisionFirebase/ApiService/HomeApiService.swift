//
//  HomeApiService.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/2/21.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase


class HomeApiService: NSObject {
    
    static let sharedInstance = HomeApiService()
    var videos = [Video]()
    var isFetched = false
    let version = "1.3.9"
    
    func fetchVideos(_ completion: @escaping ([Video]) -> ()) {
        
        let ref = Storage.storage().reference().child("homeVideos").child("allVideos")
        ref.child("allVideos_official.json").downloadURL { (url, err) in
            
            if err != nil{
                print("firebaseStorageJSONError")
                return
            }
            
            guard let firebaseUrl = url?.absoluteString else { return }
            guard let url = URL(string: firebaseUrl) else { return }
            self.fetchJsonByUrl(url: url, completion)
        }
    }
    
    private func fetchJsonByUrl(url: URL, _ completion: @escaping (([Video]) -> ())){
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil{
                print("JSON is wrong")
                return
            }
            
            self.videos = [Video]()
            guard let jsonData = data else { return }
            
            do{
                guard let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [[String: Any]] else { return }
                
                self.fetchVideosWithJson(json: json)
                self.isFetched = true

                DispatchQueue.main.async (execute: {
                    completion(self.videos)
                })
                
            }catch let jsonError {
                print(jsonError)
            }
        }).resume()
    }
    
    private func fetchVideosWithJson(json: [[String: Any]]){
        for videoJson in json{
            let video = Video()
            
            let relatedVideos = videoJson["relatedVideos"] as? [String]
            let title = videoJson["title"] as? String
            let categories = videoJson["categories"] as? [String]
            video.relatedVideosId = relatedVideos
            
            if let categoriesTag = categories {
                video.categories = categoriesTag
            }
            if let videoId = videoJson["id"] as? String{
                video.videoId = videoId
                self.fetchVideoContentDetails(videoId: videoId, video: video, videoTitle: title)
            }
            
            self.videos.append(video)
        }
    }
    
    private func fetchVideoContentDetails(videoId: String, video: Video, videoTitle: String?){
        let videoApiUrl = "https:www.googleapis.com/youtube/v3/videos?id=\(videoId)&key=AIzaSyBb38s4UHFs8GdWQsBU8i_CXEfHiczxUz0&part=snippet,contentDetails,statistics"
        if let url = URL(string: videoApiUrl){
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print("youtube video json error")
                }
                
                guard let jsonData = data else { return }
                do{
                    let videoJson = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: Any]

                    guard let items = videoJson["items"] as? [Dictionary<String, AnyObject>] else { return }
                    if items.isEmpty { return }
                    
                    let snippet = items[0]["snippet"] as? Dictionary<String, AnyObject>
                    let thumbnail = snippet?["thumbnails"] as? Dictionary<String, AnyObject>
                    let high = thumbnail?["high"] as? Dictionary<String, AnyObject>
                    let thumbnailUrl = high?["url"] as? String
                    let title = snippet?["title"] as? String
                    let publishDate = snippet?["publishedAt"] as? String
                    let replacePublishDate = publishDate?.replacingOccurrences(of: "-", with: "")
                    let PublishDateComponents = replacePublishDate?.components(separatedBy: "T")
                    let channelId = snippet?["channelId"] as? String
                    let description = snippet?["description"] as? String
                    let newDescription = description?.replacingOccurrences(of: "?", with: "")
                    let contentDetail = items[0]["contentDetails"] as? Dictionary<String, AnyObject>
                    let duration = contentDetail?["duration"] as? String
                    let statistics = items[0]["statistics"] as? Dictionary<String, AnyObject>
                    let viewCount = statistics?["viewCount"] as? String
                    
                    video.title = title
                    if videoTitle != nil {
                        video.title = videoTitle
                    }
                    
                    if let date = PublishDateComponents?[0]{
                        video.publishedAt = Int(date) as NSNumber?
                    }
                    
                    if let duration = duration{
                        self.setupVideoDuration(duration: duration, video: video)
                    }
                    
                    if let nbOfViews = viewCount{
                        video.numberOfViews = Int(nbOfViews) as NSNumber?
                    }
                    
                    video.thumbnailImageUrl = thumbnailUrl
                    video.videoDescription = newDescription
                    
                    guard let id = channelId else { return }
                    self.fetchVideoChannelJson(video: video, channelId: id)
                }
                    
                catch let jsonError{
                    print(jsonError)
                }
                
            }).resume()
        }
    }
    
    private func fetchVideoChannelJson(video: Video, channelId: String){
        
        let channelApiUrl = "https://www.googleapis.com/youtube/v3/channels?id=\(channelId)&key=AIzaSyBb38s4UHFs8GdWQsBU8i_CXEfHiczxUz0&part=snippet,contentDetails,statistics"
        let channel = Channel()
        
        if let url = URL(string: channelApiUrl){
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("youtube channel json error")
                    return
                }
                
                guard let jsonData = data else { return }
                do {
                    let channelJson = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: Any]
                    
                    let items = channelJson["items"] as? [Dictionary<String, AnyObject>]
                    let snippet = items?[0]["snippet"] as? Dictionary<String, AnyObject>
                    let title = snippet?["title"] as? String
                    let thumbnail = snippet?["thumbnails"] as? Dictionary<String, AnyObject>
                    let defaultImage = thumbnail?["default"] as? Dictionary<String, AnyObject>
                    let thumbnailUrl = defaultImage?["url"] as? String
                    
                    video.channel = channel
                    channel.name = title
                    channel.profileImageUrl = thumbnailUrl
                    
                }catch let jsonError{
                    print(jsonError)
                }
            }).resume()
        }
    }
    
    private func setupVideoDuration(duration: String, video: Video){
        
        if duration.contains("H") {
            
            var replaceDuration = duration.replacingOccurrences(of: "PT", with: "")
            replaceDuration = replaceDuration.replacingOccurrences(of: "S", with: "")
            let durationComponents = replaceDuration.components(separatedBy: "M")
            let min = durationComponents[0].components(separatedBy: "H")[1]
            video.hour = durationComponents[0].components(separatedBy: "H")[0]
            let second = durationComponents[1]
            
            if min == ""{
                video.min = "0"
            }else{
                video.min = min
            }
            
            if second == "" {
                video.sec = "0"
            }else{
                video.sec = second
            }
            
        }else{
            
            var replaceDuration = duration.replacingOccurrences(of: "PT", with: "")
            replaceDuration = replaceDuration.replacingOccurrences(of: "S", with: "")
            let durationComponents = replaceDuration.components(separatedBy: "M")
            video.min = durationComponents[0]
            
            let second = durationComponents[1]
            if second == "" {
                video.sec = "0"
            }else{
                video.sec = second
            }
        }
    }
    
}


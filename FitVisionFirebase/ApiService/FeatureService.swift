//
//  FeatureService.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/10.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

struct FeatureService{
    
    static let shared = FeatureService()
    
    func fetchRecomendVideos(completion: @escaping ([Video]) -> ()){
        
        Storage.storage().reference().child("video").child("recommendedVideos.json").downloadURL { (url, error) in
            if error != nil{
                print("failed to load recommended videos in firebase:", error ?? "error")
                return
            }
            
            guard let urlString = url?.absoluteString else { return }
            guard let url = URL(string: urlString) else { return }
            self.fetchRecommededJsonWithUrl(url: url, completion: completion)
        }
    }
    
    private func fetchRecommededJsonWithUrl(url: URL, completion: @escaping ([Video]) -> ()){
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
            if err != nil{
                print("recommeded videos url error:", err ?? "error")
                return
            }
            
            guard let data = data else { return }
            do{
                let recommendedVideosId = try JSONDecoder().decode([String].self, from: data)
                var recommendedVideos = [Video]()
                let homeVideos = HomeApiService.sharedInstance.videos
                
                recommendedVideosId.forEach({ (videoId) in
                    for video in homeVideos{
                        if video.videoId == videoId{
                            recommendedVideos.append(video)
                            break
                        }
                    }
                })
                
                DispatchQueue.main.async {
                    completion(recommendedVideos)
                }
                
            }catch let jsonErr {
                print("failed to read recommeded videos in json:", jsonErr)
            }
        }).resume()
    }
}

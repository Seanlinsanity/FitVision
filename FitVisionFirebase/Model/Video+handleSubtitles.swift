//
//  Video_handleSubtitles.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/6/5.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import Foundation
import Firebase

extension Video{
    
    func fetchVideoSubtitles(completion: @escaping ()->()){
        guard let videoId = videoId else { return }
        if subtitleArray != nil { return }
        
        Storage.storage().reference().child("homeVideos").child("subtitles").child("\(videoId).json").downloadURL { (url, err) in
            if err != nil {
                return
            }
            
            guard let subtitlesUrl = url else { return }
            self.fetchSubtitlesJsonByUrl(url: subtitlesUrl, completion: completion)
        }
    }
    
    private func fetchSubtitlesJsonByUrl(url: URL, completion: @escaping () ->()){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                print(error ?? "Fetch Subtitles Json Error")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String : Any]]
                let subtitleTextArray = json
                self.subtitleArray = subtitleTextArray
                
            }catch let jsonErr{
                print(jsonErr)
            }
            completion()
            
            }.resume()
    }
    
    
    func setupSubtitles() {
        var numberOfSubtitles = 0
        var nextSubtitleStartTime: Float
        var firstSubtitleBeginTime: Float = 0
        
        guard let count = subtitleArray?.count else { return }
        
        repeat{
            
            guard let start = subtitleArray?[numberOfSubtitles]["start"] as? Double, let end = subtitleArray?[numberOfSubtitles]["end"] as? Double else { return }
            
            if numberOfSubtitles + 1 == count {
                nextSubtitleStartTime = Float(end) + 100
            }else{
                guard let nextStart = subtitleArray?[numberOfSubtitles + 1]["start"] as? Double else { return }
                nextSubtitleStartTime = Float(nextStart)
            }
            
            let startTime = Float(start)
            let endTime = Float(end)
            
            if numberOfSubtitles == 0 {
                firstSubtitleBeginTime = startTime
            }
            if time < firstSubtitleBeginTime {
                subtitle = ""
            }
            if time > startTime && time < endTime {
                subtitle = subtitleArray?[numberOfSubtitles]["text"] as? String
            }
            if time > endTime && time < nextSubtitleStartTime {
                subtitle = ""
            }
            numberOfSubtitles += 1
            
        } while (numberOfSubtitles < count)
        
    }
    
}

//
//  VideoModel.swift
//  VidLib
//
//  Created by John Vu on 2017-01-14.
//  Copyright © 2017 John Vu. All rights reserved.
//

import UIKit
import Alamofire

protocol VideoModelDelegate {
    func dataReady()
}

// Video Model - used to retrieve data from YouTubeData API
class VideoModel: NSObject {
    
    var videos = [Video]()
    var delegate:VideoModelDelegate?

    // Get YouTubeData API Key from plist
    func getYouTubeDataAPIKey() -> String {
        var apiKey: String = ""
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            let plist = NSDictionary(contentsOfFile:path)
            apiKey = plist?.object(forKey: "YouTubeDataAPIKey") as! String
        }
        return apiKey
    }

    // Fetch most popular YouTube videos
    func getFeedVideos() {
        // Videos URL
        let urlString = "https://www.googleapis.com/youtube/v3/videos"
        
        Alamofire.request(urlString, method: .get, parameters: ["part":"snippet", "chart":"mostPopular", "maxResults":50, "key":getYouTubeDataAPIKey()], encoding: URLEncoding.default, headers: nil).responseJSON {
            (response) in
            if let JSON = response.result.value as? NSDictionary {
                var arrayOfVideos = [Video]()
                for item in JSON.object(forKey: "items") as! NSArray {
                    let video = item as! NSDictionary
                    let videoObj = Video()
                    videoObj.videoId = video.value(forKeyPath: "id") as! String
                    videoObj.videoTitle = video.value(forKeyPath: "snippet.title") as! String
                    videoObj.videoDescription = video.value(forKeyPath: "snippet.description") as! String
                    if let maxResURL = video.value(forKeyPath: "snippet.thumbnails.maxres.url") as? String {
                        videoObj.videoThumbnailURL = maxResURL
                    } else {
                        let defaultResThumbnailURL = video.value(forKeyPath: "snippet.thumbnails.default.url") as! String
                        videoObj.videoThumbnailURL = defaultResThumbnailURL
                    }
                    arrayOfVideos.append(videoObj)
                }
                self.videos = arrayOfVideos
                if self.delegate != nil {
                    self.delegate?.dataReady()
                }
            }
        }
    }
    
    // Fetch search results based on the user text
    func getSearchResults(searchText:String) {
        // Search URL
        let urlString = "https://www.googleapis.com/youtube/v3/search"
        
        Alamofire.request(urlString, method: .get, parameters: ["part":"snippet", "q":searchText as String!, "type":"video", "maxResults":50, "key":getYouTubeDataAPIKey()], encoding: URLEncoding.default, headers: nil).responseJSON {
            (response) in
            var arrayOfVideos = [Video]()
            if let JSON = response.result.value as? NSDictionary {
                for item in JSON.object(forKey: "items") as! NSArray {
                    let video = item as! NSDictionary
                    let videoObj = Video()
                    videoObj.videoId = video.value(forKeyPath: "id.videoId") as! String
                    videoObj.videoTitle = video.value(forKeyPath: "snippet.title") as! String
                    videoObj.videoDescription = video.value(forKeyPath: "snippet.description") as! String
                    if let highResThumbnailURL = video.value(forKeyPath: "snippet.thumbnails.high.url") as? String {
                        videoObj.videoThumbnailURL = highResThumbnailURL
                    } else {
                        let defaultResThumbnailURL = video.value(forKeyPath: "snippet.thumbnails.default.url") as! String
                        videoObj.videoThumbnailURL = defaultResThumbnailURL
                    }
                    
                    arrayOfVideos.append(videoObj)
                }
            }
            self.videos = arrayOfVideos
            self.delegate?.dataReady()
        }
    }

}

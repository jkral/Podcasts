 //
//  APIService.swift
//  Podcasts
//
//  Created by Jeff Kral on 2/26/18.
//  Copyright © 2018 Jeff Kral. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit
 
 extension Notification.Name {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
 }
 
 class APIService {
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    
    static let shared = APIService()
    
    func dowloadEpisode(episode: Episode) {
        print("Downloading Alamofire")
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
 
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])            
             
            }.response { (resp) in
                
                print(resp.destinationURL?.absoluteString ?? "")
                
                let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl: resp.destinationURL?.absoluteString ?? "", episode.title)
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
                
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let index = downloadedEpisodes.index(where: { $0.title == episode.title && $0.author == episode.author}) else { return }
                downloadedEpisodes[index].fileUrl = resp.destinationURL?.absoluteString ?? ""
                
                do {
                   let data =  try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
                } catch let err {
                    print("Failed to ecode downloaded episodes", err)
                }
        }
    }
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: secureFeedUrl) else { return }
                
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser?.parseAsync(result: { (result) in
                print("successfully parsed xml feed:", result.isSuccess)
                
                if let err = result.error {
                    print("Failed to parse xml feed:",err)
                    return
                }
                guard let feed = result.rssFeed else { return }
                let episodes = feed.toEpisodes()
                completionHandler(episodes)
            })
        }
    }
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to contact url:", err)
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeErr {
                print("Error decoding json:", decodeErr)
            }
        }
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
 }
 
 
 
 
 

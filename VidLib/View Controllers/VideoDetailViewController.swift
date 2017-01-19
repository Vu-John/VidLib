//
//  VideoDetailViewController.swift
//  VidLib
//
//  Created by John Vu on 2017-01-14.
//  Copyright © 2017 John Vu. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var selectedVideo: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adjust webView
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let video = self.selectedVideo {
            self.titleLabel.text = video.videoTitle
            self.descriptionLabel.text = video.videoDescription
            
            let iFrameWidth = self.webView.frame.width;
            let iFrameHeight = self.webView.frame.height;
            // Show YouTube video in iframe in webView
            self.webView.loadHTMLString("<html><head><style>body {margin: 0; background-color:transparent;}</style></head><body><iframe width=\"\(iFrameWidth)\" height=\"\(iFrameHeight)\" frameBorder=\"0\" src=\"http://www.youtube.com/embed/" + video.videoId + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\" allowfullscreen></iframe></body></html>", baseURL: nil)
        }
    }

}

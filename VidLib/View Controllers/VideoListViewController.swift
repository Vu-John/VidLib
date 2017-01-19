//
//  VideoListViewController.swift
//  VidLib
//
//  Created by John Vu on 2017-01-14.
//  Copyright © 2017 John Vu. All rights reserved.
//

import UIKit

class VideoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, VideoModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textSearch: UITextField!
    
    var videos:[Video] = [Video]()
    var selectedVideo: Video?
    let model:VideoModel = VideoModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "VidLib"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 30)!, NSForegroundColorAttributeName : UIColor.white]
        
        self.model.delegate = self
        model.getFeedVideos()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.textSearch.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: VideoModel Delegate Method
    
    // Video Model Delegate - update tableView
    func dataReady() {
        self.videos = self.model.videos
        // Animate reload tableView
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
// MARK: UITextField
    
    // Delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        model.getSearchResults(searchText:textField.text!)
        return true
    }
    
// MARK: UITableView
    
    // Ask delegate for height for the specified row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Get width of screen to calculate the height of the row
        return (self.view.frame.size.width / 320) * 180
    }
    
    // Get number of rows in specified section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    // Populate cell with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell")!
        
        let videoTitle = videos[indexPath.row].videoTitle
        
        // Customize cell to display the video title
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        // Construct thumbnail url
        let videoThumbnailURLString = videos[indexPath.row].videoThumbnailURL
        
        // Create an NSURL object
        let videoThumbnailURL = URL(string: videoThumbnailURLString)
        
        if videoThumbnailURL != nil {
            // Create an NSURLRequest object
            let request = URLRequest(url: videoThumbnailURL!)
            
            // Create an NSURLSession
            let session = URLSession.shared
            
            // Create a datatask and pass in the request
            let dataTask = session.dataTask(with: request, completionHandler:
                { (data: Data?, response: URLResponse?, error: Error?) in
                    DispatchQueue.main.async {
                        let imageView = cell.viewWithTag(1) as! UIImageView
                        imageView.image = UIImage(data: data!)
                    }
            })
            dataTask.resume()
        }
        
        return cell
    }
    
    // Action for when user taps on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Take note of which video the user selected
        self.selectedVideo = self.videos[indexPath.row]

        // Call the segue
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get a reference to the destination view controller
        let detailViewController = segue.destination as! VideoDetailViewController
        
        // Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
    }
    
}


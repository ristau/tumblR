//
//  PhotosViewController.swift
//  tumblR
//
//  Created by Barbara Ristau on 1/13/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

  var posts: [NSDictionary] = []
  let refreshControl = UIRefreshControl()
  var isMoreDataLoading = false
  var loadingMoreView: InfiniteScrollActivityView?
  let HeaderViewIdentifier = "TableViewHeaderView"
  
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = "Humans of New York"

      tableView.dataSource = self
      tableView.delegate = self
      tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
      
      //implement refresh control

      refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
      tableView.insertSubview(refreshControl, at: 0)
      
      // Set up Infinite Scroll loading indicator 
      let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
      
      loadingMoreView = InfiniteScrollActivityView(frame: frame)
      loadingMoreView!.isHidden = true
      tableView.addSubview(loadingMoreView!)
      
      var insets = tableView.contentInset
      insets.bottom += InfiniteScrollActivityView.defaultHeight
      tableView.contentInset = insets
      
      fetchNetworkData()
      
      tableView.reloadData()
      
      print("number of posts: \(self.posts.count)")
      
    }


  
  // MARK: - TableView Functions
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return posts.count
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
      tableView.rowHeight = 240
      return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
    
    let post = posts[indexPath.section]
   
    /*
    if let datePublished = post["date"] as? String {
      print("Date Published: \(datePublished)")
      cell.timeStampLabel.text = datePublished
    }
     */  // moved this to the header 
    
    if let caption = post["summary"] as? String {
      print("Summary: \(caption)")
   
      cell.captionLabel.text = caption
    }
    
    if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
         let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
      
        if let imageUrl = URL(string: imageUrlString!) {

          cell.photoImage.setImageWith(imageUrl)
        } else {
          print("could not get image")
      }
    } else {
      print("error in getting images")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
    
    let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
    profileView.clipsToBounds = true
    profileView.layer.cornerRadius = 15
    profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
    profileView.layer.borderWidth = 1
    
    profileView.setImageWith(URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
    headerView.addSubview(profileView)
    
    // add uilabel for the date here 
    let label = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 21))
    label.center = CGPoint(x:150, y: 25)
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true 
    
    let post = posts[section]
  
    if let datePublished = post["date"] as? String {
      print("Date Published: \(datePublished)")
      label.text = datePublished
      
    }
    
    headerView.addSubview(label)
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    var height = tableView.sectionHeaderHeight
    height = 50
  
    return height
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  // MARK: - Network Request 
  
  func fetchNetworkData(){
    
    let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
    
    let request = URLRequest(url: url!)
    
    let session = URLSession(
      configuration: URLSessionConfiguration.default,
      delegate: nil,
      delegateQueue: OperationQueue.main
    )
    
    let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
      
      if let data = data {
        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
        //  print("responseDictionary: \(responseDictionary)")
          
        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
       
          //print("responseFieldDictionary: \(responseFieldDictionary)")
      
          self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
          print(self.posts)
          self.tableView.reloadData()
        }
      
    }
      
  })
  task.resume()

  }
  
  func loadMoreData() {
    
    let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
    
    let request = URLRequest(url: url!)
    
    let session = URLSession(
      configuration: URLSessionConfiguration.default,
      delegate: nil,
      delegateQueue: OperationQueue.main
    )
    
    let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
      
      // update flag 
      self.isMoreDataLoading = false
      
      // stop the loading indicator
      self.loadingMoreView!.stopAnimating()
      
      if let data = data {
        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
          
          let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
          
          self.posts = responseFieldDictionary["posts"] as! [NSDictionary]

          self.tableView.reloadData()
          }
        }
      })
      task.resume()
    }
  
  
  // MARK: - Pull to Refresh
  
  func refreshControlAction(refreshControl: UIRefreshControl) {
    
    let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
    
    let request = URLRequest(url: url!)

    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
    let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      
      // update the data source 
      if let data = data {
        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
          
          let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
          
          self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
      
          // reload tableview
          self.tableView.reloadData()
          refreshControl.endRefreshing()
        }
      }
    }
    
    task.resume()
  }
  
  // MARK: - Infinite Scrolling 
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if (!isMoreDataLoading) {
      
      // calculate position of one screen length before the bottom of the results
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
      
      // When the user has scrolled past the threshold, start requesting 
      if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
        isMoreDataLoading = true
        
        // update position of loading more view and start loading indicator 
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        loadingMoreView!.startAnimating()
        
      }
    }
    // code to load more results
    loadMoreData()
  }
  


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      let cell = sender as! UITableViewCell
      var indexPath = tableView.indexPath(for: cell)
      let post = posts[(indexPath?.section)!]
      
      let vc = segue.destination as! PhotoDetailsViewController
      vc.post = post
      
    }
  

}

//
//  PhotosViewController.swift
//  tumblR
//
//  Created by Barbara Ristau on 1/13/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var posts: [NSDictionary] = []

  
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      tableView.dataSource = self
      tableView.delegate = self
      
     fetchNetworkData()
      
      tableView.reloadData()
      
      print("number of posts: \(self.posts.count)")
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // MARK: - TableView Functions
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
      tableView.rowHeight = 240
  
      return posts.count

  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
    
    let post = posts[indexPath.row]
    
    if let datePublished = post["date"] as? String {
      print("Date Published: \(datePublished)")
      cell.timeStampLabel.text = datePublished

    }
    
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
      
  });
  task.resume()
 
    
  }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      var vc = segue.destination as! PhotoDetailsViewController
     
      var indexPath = tableView.indexPath(for: sender as! UITableViewCell)
      

  
    }
  

}

//
//  PhotoDetailsViewController.swift
//  tumblR
//
//  Created by Barbara Ristau on 1/13/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
  
  var post: NSDictionary! 
  
  //var photoUrl: URL!
  
  // consider to delete the summary Label, need to work on passing data 
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var photoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

      let summary = post["summary"] as? String
      summaryLabel.text = summary!
      
      if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
        
        let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
        let imageUrl = URL(string: imageUrlString!)
        photoImage.setImageWith(imageUrl!)
        
      }
      
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
      
      photoImage.isUserInteractionEnabled = true
      photoImage.addGestureRecognizer(tapGestureRecognizer)
      
      print("post")
    }
  
  
  
  @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    
    print("Did hit tap")
    performSegue(withIdentifier: "FullScreen", sender: UITapGestureRecognizer.self)
    
  }
  


  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      print("Preparing to go to full screen")
      
      if segue.identifier == "FullScreen" {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationvc = segue.destination as! FullScreenPhotoViewController
        destinationvc.post = post
  
      }
    }
  

}

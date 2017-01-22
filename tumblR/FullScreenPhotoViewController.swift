//
//  FullScreenPhotoViewController.swift
//  tumblR
//
//  Created by Barbara Ristau on 1/22/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import AFNetworking

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {

  var post: NSDictionary!
  @IBOutlet weak var fullScreenPhotoImage: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      scrollView.delegate = self
      
      if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
        
        let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
        let imageUrl = URL(string: imageUrlString!)
        fullScreenPhotoImage.setImageWith(imageUrl!)
        scrollView.contentSize = fullScreenPhotoImage.image!.size
        
        
      }
      
    }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return fullScreenPhotoImage
  }


  @IBAction func closeScreen(_ sender: UIButton) {
    
    print("Tapped close button")
    
    self.dismiss(animated: true, completion: nil)
    
  }
  
  
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  PhotoCell.swift
//  tumblR
//
//  Created by Barbara Ristau on 1/13/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

  @IBOutlet weak var photoImage: UIImageView!
  @IBOutlet weak var captionLabel: UILabel!
  @IBOutlet weak var timeStampLabel: UILabel!
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

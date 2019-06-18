//
//  HuntTableViewCell.swift
//  Escave
//
//  Created by Ryan Schoenlein on 5/21/19.
//  Copyright © 2019 Ryan Schoenlein. All rights reserved.
//

import UIKit

class HuntTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

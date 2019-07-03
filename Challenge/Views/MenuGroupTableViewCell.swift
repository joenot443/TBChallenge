//
//  MenuGroupTableViewCell.swift
//  TouchBistroChallenge
//
//  Created by Joe Crozier on 2019-06-26.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit
import SDWebImage

class MenuGroupTableViewCell: UITableViewCell {
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var group: MenuGroup! {
        didSet {
            nameLabel?.text = group.name
            groupImageView?.sd_setImage(with: group.imageUrl, completed: nil)
        }
    }
}

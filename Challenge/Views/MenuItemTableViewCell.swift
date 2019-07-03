//
//  MenuItemTableViewCell.swift
//  TouchBistroChallenge
//
//  Created by Joe Crozier on 2019-06-26.
//  Copyright © 2019 Joe Crozier. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    @IBOutlet var priceLabel: UILabel?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!

    
    var item: MenuItem! {
        didSet {
            priceLabel?.text = String(format: "$%.2f", item.price)
            itemImageView?.sd_setImage(with: item.imageUrl, completed: nil)
            nameLabel?.text = item.name
        }
    }
}

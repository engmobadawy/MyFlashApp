//
//  MyCellTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by MAC on 23/04/2025.
//  Copyright © 2025 Angela Yu. All rights reserved.
//

import UIKit

class MyCellTableViewCell: UITableViewCell {

    @IBOutlet weak var meAvatar: UIImageView!
    
    @IBOutlet weak var youAvatar: UIImageView!
    
    @IBOutlet weak var messageBubble: UIView!
    
    @IBOutlet weak var actualMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        messageBubble.layer.cornerRadius = 20
        messageBubble.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  CustomSongCell.swift
//  osu!
//
//  Created by Stas Panasuk on 3/4/18.
//  Copyright © 2018 iSan4eZ. All rights reserved.
//

import UIKit

class CustomSongCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var diffLbl: UILabel!
    
    var difficulty : Diff!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.superview?.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

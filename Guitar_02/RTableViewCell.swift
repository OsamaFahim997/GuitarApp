//
//  RTableViewCell.swift
//  Guitar_02
//
//  Created by Abdul on 19/06/2019.
//  Copyright © 2019 Jibran Haider. All rights reserved.
//

import UIKit

class RTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

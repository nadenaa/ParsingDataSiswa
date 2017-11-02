//
//  KivaLoanTableViewCell.swift
//  ParsingDataSiswa
//
//  Created by yusronadena on 11/2/17.
//  Copyright © 2017 yusron. All rights reserved.
//

import UIKit

class KivaLoanTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLAbel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

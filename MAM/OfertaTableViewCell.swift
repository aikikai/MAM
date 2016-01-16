//
//  OfertaTableViewCell.swift
//  
//
//  Created by Luciano Wehrli on 15/1/16.
//
//

import UIKit

class OfertaTableViewCell: UITableViewCell {
        
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dates: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

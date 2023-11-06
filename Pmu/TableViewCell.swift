//
//  TableViewCell.swift
//  Pmu
//
//  Created by seohuibaek on 2023/09/07.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var musicAlbumImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        musicAlbumImg.layer.cornerRadius = 10
        musicAlbumImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

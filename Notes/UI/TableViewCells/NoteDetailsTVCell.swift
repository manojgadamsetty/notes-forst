//
//  NoteDetailsTVCell.swift
//  Notes
//
//  Created by Manoj Gadamsetty on 04/02/20.
//  Copyright © 2020 Task. All rights reserved.
//

import UIKit

class NoteDetailsTVCell: UITableViewCell {

    @IBOutlet weak var mDateLabel: UILabel!
    @IBOutlet weak var mTagsLabel: UILabel!
    @IBOutlet weak var mTagsIV: UIImageView!
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var mNotesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

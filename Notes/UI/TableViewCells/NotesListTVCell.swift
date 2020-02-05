//
//  NotesListTVCell.swift
//  Notes
//
//  Created by Manoj Gadamsetty on 04/02/20.
//  Copyright © 2020 Task. All rights reserved.
//

import UIKit

class NotesListTVCell: UITableViewCell {

    @IBOutlet weak var mTimeLabel: UILabel!
    @IBOutlet weak var mTagsLabel: UILabel!
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var mDiscriptionLabel: UILabel!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mTagsIV: UIImageView!

    @IBOutlet weak var mImageViewWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

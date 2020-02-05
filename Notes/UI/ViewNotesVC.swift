//
//  ViewNotesVC.swift
//  Notes
//
//  Created by Manoj Gadamsetty on 04/02/20.
//  Copyright © 2020 Task. All rights reserved.
//

import UIKit

class ViewNotesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!
    var noteData : Note?
    var mCoverImage: UIImage?
    var fractionRef:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
        
        self.mTableView.rowHeight = 120
        self.mTableView.estimatedRowHeight = UITableView.automaticDimension
        
        
        
        if let data = self.noteData?.imageData {
            self.mCoverImage = UIImage(data: data)
            let imgQueue = DispatchQueue(label: "IMG_QUEUE")
            imgQueue.async(execute: {
                self.fractionRef = self.mCoverImage!.size.height/self.mCoverImage!.size.width
                DispatchQueue.main.async(execute: {
                    self.mTableView.reloadSections([0], with: UITableView.RowAnimation.fade)
                })
            })
        }
    }
    
    // Table View delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell:NoteImageTVCell = tableView.dequeueReusableCell(withIdentifier: "NoteImageTVCell", for: indexPath) as! NoteImageTVCell
            cell.selectionStyle = .none
            cell.mImageView.image = self.mCoverImage
            return cell
        }
        else{
            let cell:NoteDetailsTVCell = tableView.dequeueReusableCell(withIdentifier: "NoteDetailsTVCell", for: indexPath) as! NoteDetailsTVCell
            cell.mTitleLabel.text = noteData?.noteTitle
            cell.mNotesLabel.text = noteData?.noteText
            cell.mDateLabel.text = Utils.sharedInstance.dateToString(date:noteData!.createdAt!)
            
            if noteData?.noteTags?.count == 0 {
                cell.mTagsLabel.text = ""
                cell.mTagsIV.isHidden = true
            }else{
                cell.mTagsLabel.text = noteData?.noteTags
                cell.mTagsIV.isHidden = false
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return self.mTableView.frame.width*fractionRef
        }
        else{
            return UITableView.automaticDimension
        }
    }
}



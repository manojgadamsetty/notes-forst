//
//  FilterVC.swift
//  Notes
//
//  Created by Manoj Gadamsetty on 05/02/20.
//  Copyright © 2020 Task. All rights reserved.
//

import UIKit

protocol FilterVCDelegate: class {
    func dateFilterAdded(_ sender: FilterVC,filter:Bool)     
}

class FilterVC: UIViewController {

    @IBOutlet weak var mDateButton: UIButton!
    @IBOutlet weak var mApplyButton: UIButton!

    @IBOutlet weak var mClearAllButton: UIBarButtonItem!
    @IBOutlet weak var mDateSelectionButtonImageView: UIImageView!
       
    weak var delegate: FilterVCDelegate?

    var dateFilter = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if dateFilter {
            self.mDateSelectionButtonImageView.image = #imageLiteral(resourceName: "select")
            self.mClearAllButton.isEnabled = true
        }else{
            self.mDateSelectionButtonImageView.image = nil
            self.mClearAllButton.isEnabled = false
        }
    }
    

    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem){
        self.mDateSelectionButtonImageView.image = nil
        self.mClearAllButton.isEnabled = false
    }
    @IBAction func dateFilterButtonTapped(_ sender: UIButton){
        if dateFilter {
            self.mDateSelectionButtonImageView.image = nil
            dateFilter = false
            self.mClearAllButton.isEnabled = false
        }else{
            self.mDateSelectionButtonImageView.image = #imageLiteral(resourceName: "select")
            dateFilter = true
            self.mClearAllButton.isEnabled = true
        }
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton){
        delegate?.dateFilterAdded(self, filter:true)
        self.navigationController?.popViewController(animated:true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dateFilter = false
    }

}

//
//  NotesListVC.swift
//  Notes
//
//  Created by Manoj Gadamsetty on 04/02/20.
//  Copyright © 2020 Task. All rights reserved.
//

import UIKit
import CoreData

class NotesListVC: UIViewController {
    
    private let image = #imageLiteral(resourceName: "hg_default-no_results")
    
    @IBOutlet weak var mNotesListTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var dateFilter = false
    
    var fetchNotesData:[Note] = []
    var notesData:[Note] = []
    var searchBarIsActive = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialDataLoad()
        self.setUpSearchBar()
        self.setupEmptyBackgroundView()
    }
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top:"Im Lonely here", bottom:"Add some notes")
        mNotesListTableView.backgroundView = emptyBackgroundView
    }
    
    func setUpSearchBar() {
        mNotesListTableView.tableHeaderView = UIView()
        self.searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = true
        searchBar.placeholder = "Search by Title"
        searchBar.setImage(UIImage(named:"filter"), for: .bookmark, state: .normal)
        
        if #available(iOS 13.0, *) {
            let tf = searchBar.searchTextField
            tf.clearButtonMode = .never
        }else{
            let tf = searchBar.value(forKey:"_searchField") as! UITextField
            tf.clearButtonMode = .never
        }
    }
    
    @IBAction func createNewNotesTapped(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier:"AddNotesVC") as! AddNotesVC
        controller.delegate = self
        controller.isModalInPresentation = true
        self.navigationController?.present(controller, animated:true, completion:nil)
    }
    
    func fetchDataFromCoreDataFirstTime() -> [Note] {
        let request = NSFetchRequest<Note>(entityName:CoreDataStack.entityNotes)
        if dateFilter {
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        }
        var data = [Note]()
        do {
            try data = CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(request)
        } catch let error  {
            print("ERROR: \(error)")
        }
        return data
    }
    
    func initialDataLoad()  {
        notesData.removeAll()
        fetchNotesData.removeAll()
        fetchNotesData = fetchDataFromCoreDataFirstTime()
        notesData = fetchNotesData
        self.mNotesListTableView.reloadData()
    }
}

extension NotesListVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsActive == true {
            mNotesListTableView.backgroundView?.isHidden = true
        }else
        {
            if notesData.count == 0{
                mNotesListTableView.backgroundView?.isHidden = false
            }else{
                mNotesListTableView.backgroundView?.isHidden = true
            }
        }
        return notesData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotesListTVCell = tableView.dequeueReusableCell(withIdentifier: "NotesListTVCell", for: indexPath) as! NotesListTVCell
        let data = notesData[indexPath.row]
        cell.mTitleLabel.text = data.noteTitle
        cell.mDiscriptionLabel.text = data.noteText
        if data.imageData != nil {
            cell.mImageViewWidthConstraint.constant = 110
            cell.mImageView.image = UIImage(data:data.imageData!)
        }else{
            cell.mImageView.image = nil
            cell.mImageViewWidthConstraint.constant = 0
        }
        
        if data.noteTags?.count == 0 {
            cell.mTagsLabel.text = ""
            cell.mTagsIV.isHidden = true
        }else{
            cell.mTagsLabel.text = data.noteTags
            cell.mTagsIV.isHidden = false
        }
        
        cell.mTimeLabel.text = Utils.sharedInstance.dateToString(date:data.createdAt!)
        cell.selectionStyle = .none
        return cell
    }
}
extension NotesListVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier:"ViewNotesVC") as! ViewNotesVC
        controller.noteData = notesData[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension NotesListVC:AddNotesVCDelegate{
    func newNotesAdded(_ sender: AddNotesVC) {
        initialDataLoad()
    }
}
// MARK:- SeachBar delegate Extension
extension NotesListVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarIsActive = true
        notesData = fetchNotesData.filter({ noteData -> Bool in
            let note = noteData.noteTitle!.lowercased().contains(searchText.lowercased())
            return note
        })
        self.mNotesListTableView.reloadData()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarIsActive = true
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarIsActive = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.textField?.text = ""
        searchBar.resignFirstResponder()
        initialDataLoad()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier:"FilterVC") as! FilterVC
        controller.delegate = self
        controller.dateFilter = self.dateFilter
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension NotesListVC:FilterVCDelegate{
    
    func dateFilterAdded(_ sender: FilterVC, filter: Bool) {
        self.dateFilter = filter
        self.initialDataLoad()
    }
}

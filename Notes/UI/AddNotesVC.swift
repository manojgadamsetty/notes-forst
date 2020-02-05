//
//  AddNotesVC.swift
//  Notes
//
//  Created by Manoj Gadamsetty on 04/02/20.
//  Copyright © 2020 Task. All rights reserved.
//

import UIKit
import CoreData
import Photos

protocol AddNotesVCDelegate: class {
    func newNotesAdded(_ sender: AddNotesVC)
}
class AddNotesVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var mTitleTextView: UITextView!
    @IBOutlet weak var mTagsTextView: UITextView!
    @IBOutlet weak var mNotesTextView: UITextView!
    @IBOutlet weak var mAttachmentNameTextView: UITextView!
    @IBOutlet weak var mAttachmentButton: UIButton!
    @IBOutlet weak var mCreateButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imageSelected = false
    var imagePre:UIImage?
    weak var delegate: AddNotesVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        imagePicker.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.initalTextViews()
    }
    
   
    @IBAction func createNewNotesTapped(_ sender: UIBarButtonItem){
        self.dismiss(animated:true, completion:nil)
    }
    @IBAction func createTapped(_ sender: UIButton){
        
        if  self.mTitleTextView.text == "Enter Title" {
            ShowAlertMessage(ErrorMessage:"Please Enter Title", title:"Error")
            return
        }else if self.mNotesTextView.text.count < 10{
            ShowAlertMessage(ErrorMessage:"Please Enter valid Notes", title:"Error")
            return
        }
        let tags = self.mTagsTextView.text
        if tags!.containsWhitespace {
            ShowAlertMessage(ErrorMessage: "Please remove spaces in tags where tags cant contain white spaces", title:"Error")
            return
        }

        var imageData:Data? = nil
        if imageSelected {
            imageData = imagePre!.pngData()
        }
    
        self.saveNotesInCoreData(title:mTitleTextView.text, note: mNotesTextView.text, tags:mTagsTextView.text, ImageData:imageData)
        self.dismiss(animated:true, completion:nil)
    }
    
    @IBAction func selectImage(_ sender: UIButton){
        if imageSelected {
            let alert = UIAlertController(title:"Note", message:"Do you want to remove previously selected image ?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(title: "ok", style:.default) { action in
                 self.mAttachmentNameTextView.text = "Attach Media"
                       self.mAttachmentNameTextView.textColor = UIColor.lightGray
                self.imageSelected = false
                self.imagePre = nil
                self.selectImage()
            }
            alert.addAction(title: "Cancel", style: .cancel) { action in
            }
            self.present(alert, animated: true, completion: nil)
        }else{
            self.selectImage()
        }
    }
    
    func selectImage() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.navigationController?.navigationBar.isHidden = false
        self.present(imagePicker, animated:false)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        guard let image = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) else { return }
        imageSelected = true
        imagePre = image
        self.mAttachmentNameTextView.text = "Media Attached"
        self.mAttachmentNameTextView.textColor = UIColor.black
        picker.dismiss(animated: true, completion: nil)
    }
}
extension AddNotesVC {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNotesVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension AddNotesVC{
    
    private func saveNotesInCoreData(title:String,note:String,tags:String,ImageData:Data!) {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let notesEntry = NSEntityDescription.insertNewObject(forEntityName: CoreDataStack.entityNotes, into: context) as? Note {
            
            notesEntry.noteTitle = title
            notesEntry.noteTags = tags
            notesEntry.noteText = note
            notesEntry.createdAt = Date()
            if (ImageData != nil) {
                notesEntry.imageData = ImageData
            }
        }
        
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            delegate?.newNotesAdded(self)
        } catch let error {
            print(error)
        }
    }
    
    func ShowAlertMessage(ErrorMessage : String,title:String){
        DispatchQueue.main.async(execute: { () -> Void in
            let alert = UIAlertController(title:title, message: ErrorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
}
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


extension AddNotesVC:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            if textView == self.mTitleTextView {
                textView.text = "Enter Title"
            }else if textView == self.mTagsTextView{
                textView.text = "Tags"
            }else if textView == self.mNotesTextView{
                textView.text = ""
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textFromTextView: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textFromTextView.replacingCharacters(in: range, with:text)
      
        return true
    }
    func initalTextViews() {
        mTitleTextView.text = "Enter Title"
        mTagsTextView.text = "Tags"
        mNotesTextView.text = ""
        mAttachmentNameTextView.text = "Attach Media"

        mTitleTextView.textColor = UIColor.lightGray
        mTagsTextView.textColor = UIColor.lightGray
        mNotesTextView.textColor = UIColor.lightGray
        mAttachmentNameTextView.textColor = UIColor.lightGray

    }
}

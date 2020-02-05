//
//  InitialVC.swift
//  Notes
//
//  Created by Manoj Gadamsetty on 05/02/20.
//  Copyright © 2020 Task. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {
    
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func startAsNewButtonTapped(_ sender: UIButton){
    CoreDataStack.sharedInstance.resetAllRecords(in:CoreDataStack.entityNotes)
        self.navigateToNotesList()

    }
    @IBAction func exixtingButtonTapped(_ sender: UIButton){
        self.navigateToNotesList()
    }
    func navigateToNotesList()  {
        let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "start") as? UINavigationController
        mainVC!.modalPresentationStyle = .fullScreen
        self.present(mainVC!, animated:true, completion:nil)
    }
}

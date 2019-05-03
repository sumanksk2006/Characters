//
//  CharacterDetailController.swift
//  Character Viewer
//
//  Created by Suman Kumar Konakalla on 2/4/19.
//  Copyright © 2019 Character. All rights reserved.
//

import UIKit

class CharacterDetailController: UIViewController {

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var charImageView: UIImageView!
    var charImage: UIImage?
    var selectedCharacter : Character? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.detailTextView.text = self.selectedCharacter?.charDescription
        
        self.navigationItem.title = self.selectedCharacter?.title
        
        self.charImageView.image = self.charImage

    }
    

}

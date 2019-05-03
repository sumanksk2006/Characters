//
//  Character.swift
//  Character Viewer
//
//  Created by Suman Kumar Konakalla on 2/1/19.
//  Copyright © 2019 Character. All rights reserved.
//

import Foundation

class Character {
    let title: String
    let imageUrl: String
    let charDescription: String
    var isFavorite: Bool
   
    init(title: String, imageUrl: String, charDescription: String){
        self.title = title
        self.imageUrl = imageUrl
        self.charDescription = charDescription
        self.isFavorite = false
    }
}

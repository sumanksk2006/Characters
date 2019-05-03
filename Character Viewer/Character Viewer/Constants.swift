//
//  Constants.swift
//  Character Viewer
//
//  Created by Suman Kumar Konakalla on 2/5/19.
//  Copyright © 2019 Character. All rights reserved.
//

import Foundation
import UIKit

#if SIMPSONS
let fetchCharacterURL = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"

#elseif WIRE
let fetchCharacterURL = "http://api.duckduckgo.com/?q=the+wire+characters&format=json"

#endif

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let favImage = UIImage.init(named: "favorite")
let selected_favImage = UIImage.init(named: "fav_selected")

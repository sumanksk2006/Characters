//
//  CharactersTabBar.swift
//  Character Viewer
//
//  Created by Suman Kumar Konakalla on 2/5/19.
//  Copyright © 2019 Character. All rights reserved.
//

import UIKit
let listTabTag = 52334
let favTabTag = 10234

extension CharactersViewController  {
   
    //MARK: - TabBar Delegate Methods

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
     
        if item.tag == favTabTag {
            self.filteredCharacters = self.getFavoriteCharacters()
            self.charactersCollectionView.reloadData()
        }
        else{
            self.filteredCharacters = self.characters
            self.charactersCollectionView.reloadData()
        }
        
    }

    //MARK: - Filter for Favorites
    func getFavoriteCharacters() -> [Character] {
        return self.characters.filter({ (characterObj: Character) -> Bool in
            characterObj.isFavorite == true
        })
    }
}

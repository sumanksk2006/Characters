//
//  ViewController.swift
//  Character Viewer
//
//  Created by Suman Kumar Konakalla on 2/1/19.
//  Copyright © 2019 Character. All rights reserved.
//

import UIKit
private let reuseIdentifier = "characterCell"


class CharactersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITabBarDelegate  { 
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteTabBar: UITabBar!
    @IBOutlet weak var segmentLayOutControl: UISegmentedControl!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    var characters : [Character] = []
    var filteredCharacters: [Character] = []
    var isListView : Bool = false
    var collectionLayOutFlow : UICollectionViewFlowLayout? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
        self.collectionLayOutFlow = self.charactersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        self.fetchCharacters()
        self.indicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK: - Fetch Data 
    
    func fetchCharacters() {
        WebServiceHandler().getCharacters(urlString: fetchCharacterURL) { (characters, errorMssg) in
            if let fetchedCharacters = characters {
                print ("characters count: ", fetchedCharacters.count)
                self.characters = fetchedCharacters
                self.filteredCharacters = fetchedCharacters
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.charactersCollectionView.reloadData()
                }
            }
        }
    }
    
    
    
     //MARK: - CollectionView Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.filteredCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterGridCell
        
        cell.characterTitle.text = self.filteredCharacters[indexPath.row].title

        cell.favoriteBtn.tag = indexPath.row
        cell.favoriteBtn.addTarget(self, action: #selector(self.favoriteBtnClicked(sender:)), for: .touchUpInside)
        
        cell.favoriteBtn.setImage(self.filteredCharacters[indexPath.row].isFavorite ? selected_favImage : favImage, for: .normal)
        
        guard self.filteredCharacters[indexPath.row].imageUrl != "" else {
            cell.characterImageView.image = UIImage(named: "placeholder")
            return cell
        }
        
        URLSession.shared.dataTask(with: URL(string: self.filteredCharacters[indexPath.row].imageUrl)!){ data, response, error in
            
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                cell.characterImageView.image = UIImage(data: data!)
            }
        }.resume()
        // Configure the cell
        
        return cell
    }
    
   
    
    //MARK: - CollectionViewFlowLayout Delegate Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        if isListView {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 177*UIScreen.main.bounds.size.height/736)
        }
        else{
            return CGSize(width: UIScreen.main.bounds.size.width/2, height: 177*UIScreen.main.bounds.size.height/736)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if isListView {
            return UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
        }
        else{
            return UIEdgeInsets(top: 0, left:-1, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isListView {
            return 2.0;
        }
        else{
            return 1.0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
        if isListView {
            return 2.0;
        }
        else{
            return 1.0;
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CharacterGridCell
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailSegue") as! CharacterDetailController
        detailVC.selectedCharacter = self.filteredCharacters[indexPath.row]
        detailVC.charImage = selectedCell.characterImageView.image
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

     //MARK: - SearchBar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        let regEx = "[A-Za-z0-9\\s]"
        var regExValidation : Bool = true
        if text.count > 0 {
            if let textPredicate = NSPredicate(format: "SELF MATCHES %@", regEx) as NSPredicate? {
                regExValidation = textPredicate.evaluate(with: text)
            }
        }
        
        if regExValidation {
            return true
        }
        else{
            return false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
    func searchCharacters(searchText : String){
        if !(searchText.count == 0){
            
            let searchedProducts = self.getCharactersForList().filter { (characterObj: Character) -> Bool in
                characterObj.title.localizedCaseInsensitiveContains(searchText)
            }
            
            
            self.filteredCharacters = searchedProducts
            self.charactersCollectionView.reloadData()
            
        }
        else{
            self.filteredCharacters = self.getCharactersForList()
            self.charactersCollectionView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.searchCharacters(searchText: searchText)
        
        if searchText.count == 0 {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredCharacters = self.getCharactersForList()
        self.charactersCollectionView.reloadData()
    }
    
    
    //MARK: - Outlet Actions Methods

    @IBAction func layoutChanged(_ sender: Any) {
        if self.segmentLayOutControl.selectedSegmentIndex == 1 {
            isListView = false
            
            self.charactersCollectionView.performBatchUpdates({
             
                self.collectionLayOutFlow?.invalidateLayout()
                self.charactersCollectionView.setCollectionViewLayout(self.collectionLayOutFlow!, animated: true)
        
            }) { (finished) in
                
            }
        }
        else{
            isListView = true
            self.charactersCollectionView.performBatchUpdates({
               
                self.collectionLayOutFlow?.invalidateLayout()
                self.charactersCollectionView.setCollectionViewLayout(self.collectionLayOutFlow!, animated: true)
          
            }) { (finished) in
                
            }
        }
    }
    
    @objc func favoriteBtnClicked(sender: UIButton){
        
        let characterIndex = sender.tag
        if (self.filteredCharacters[characterIndex].isFavorite){
            self.filteredCharacters[characterIndex].isFavorite = false
            sender.setImage(favImage, for: .normal)
        }
        else{
            self.filteredCharacters[characterIndex].isFavorite = true
            sender.setImage(selected_favImage, for: .normal)
        }
    }
    
    
    func getCharactersForList() -> [Character] {
        return (self.favoriteTabBar.selectedItem?.tag == favTabTag) ? self.getFavoriteCharacters() : self.characters
    }
    
}


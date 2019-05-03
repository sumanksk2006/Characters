//
//  WebServiceHandler.swift
//  Character Viewer
//
//  Created by Suman Kumar Konakalla on 2/1/19.
//  Copyright © 2019 Character. All rights reserved.
//

import Foundation

class WebServiceHandler {
    
    typealias responseDict = [String: Any]
    let defaultSession = URLSession(configuration: .default)
    var fetchCharacterTask : URLSessionDataTask?
    var errorMssg = ""
    
    //MARK: - Request to Fetch Data

    func getCharacters(urlString : String, completion: @escaping ([Character]?, String) -> () ){
        fetchCharacterTask?.cancel()
        
        guard let requestURL = URL(string: urlString) else { return }
        fetchCharacterTask = defaultSession.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                self.errorMssg = error.localizedDescription
            }
            else if let data = data, let responseData = response as? HTTPURLResponse, responseData.statusCode == 200 {
                
                
                completion(self.parseCharacterResults(data) , self.errorMssg)
            }
        }
        
        fetchCharacterTask?.resume()
        
    }
    
    //MARK: - Parse Fetched Data
    
    func parseCharacterResults(_ data: Data) -> [Character]{
        var characterDict : responseDict?
        
        var fetchedCharacters : [Character] = []
        
        do {
            characterDict = try JSONSerialization.jsonObject(with: data, options: []) as? responseDict
        } catch let parserError as NSError {
            self.errorMssg += "JSONSerialization error: \(parserError.localizedDescription)"
            return fetchedCharacters
        }
        
        guard let charactersArray = characterDict!["RelatedTopics"] as? [Any]  else {
            return fetchedCharacters
        }
        for characterObj in charactersArray{
            
            if let characterDict = characterObj as? responseDict{
                let textComponents =  (characterDict["Text"] as! String).components(separatedBy: " - ")
                let titleString  = textComponents[0]
                let characterDesc = textComponents.count > 1 ? textComponents[1] : ""
                let imageURL = (characterDict["Icon"] as! [String: String])["URL"] ?? ""
                
                fetchedCharacters.append(Character.init(title: titleString, imageUrl: imageURL, charDescription: characterDesc))
            }
        }
        
        
        return fetchedCharacters
        
    }
}

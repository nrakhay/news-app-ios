//
//  NewsModel.swift
//  intro-lab-nrakhay
//
//  Created by Nurali Rakhay on 03.02.2023.
//

import Foundation

enum Keys {
    static let newsArrayKey = "newsArray"
}

struct NewsModel: Codable{
    let title: String
    let description: String
    let publisher: String
    let newsUrl: String
    let imageUrl: String
    let publishedDay: String
}

struct DataManager {
    static let defaults = UserDefaults.standard
    private init(){}
    
    static func saveNewsData(newsModel: [NewsModel]){
        do {
         let encoder = JSONEncoder()
         let encodedData = try encoder.encode(newsModel)
         defaults.setValue(encodedData, forKey: Keys.newsArrayKey)
        }catch let err{
            print(err)
        }
    }

    static func getSavedNews() -> [NewsModel]{
        guard let savedNewsData = defaults.object(forKey: Keys.newsArrayKey) as? Data else { return [] }
        do{
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([NewsModel].self, from: savedNewsData)
            return decodedData
        }catch _ {
            return([])
      }
    }
}

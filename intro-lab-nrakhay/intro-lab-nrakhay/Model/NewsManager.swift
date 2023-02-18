//
//  NewsManager.swift
//  intro-lab-nrakhay
//
//  Created by Nurali Rakhay on 03.02.2023.
//

import Foundation

protocol NewsManagerDelegate {
    func didUpdateNews(_ newsManager: NewsManager, _ news: [NewsModel])
    func didFailWithError(_ error: Error)
}

struct NewsManager {
    var delegate: NewsManagerDelegate?
    let newsURL = "https://newsapi.org/v2/everything?sortBy=popularity"
    
    func fetchNews(about keyword: String) {
        let urlString = "\(newsURL)&q=\(keyword)&apiKey=56f446e21c7a4b4faf1fecb67f8028c2"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
            if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let safeData = data {
                    let news = parseJSON(newsData: safeData)
                    self.delegate?.didUpdateNews(self, news)
                }
            }
            
            task.resume()
        }
    }
    func parseJSON(newsData: Data) -> [NewsModel]{
        var newsModelCollection: [NewsModel] = []
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsData.self, from: newsData)

            if let articles = decodedData.articles {
                for count in 0...19 {
                    let article = articles[count]
            
                    let title = article.title
                    let description = article.description
                    let publisher = article.source.name
                    let newsUrl = article.url
                    let imageUrl = article.urlToImage ?? ""
                    
                    let publishedAt = article.publishedAt
                    let dayIndex = publishedAt.index(publishedAt.startIndex, offsetBy: 10)
                    let publishedDay = article.publishedAt[..<dayIndex]
                                        
                    let news = NewsModel(title: title,
                                         description: description,
                                         publisher: publisher,
                                         newsUrl: newsUrl,
                                         imageUrl: imageUrl,
                                         publishedDay: String(publishedDay))
                    
                    newsModelCollection.append(news)
                    
                }
            }
        } catch {
            print(error)
        }
         
        return newsModelCollection
    }
}

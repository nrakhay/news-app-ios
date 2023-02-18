//
//  NewsData.swift
//  intro-lab-nrakhay
//
//  Created by Nurali Rakhay on 03.02.2023.
//

import Foundation

struct NewsData: Decodable {
    let articles: [Article]?
}

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Decodable {
    let name: String
}

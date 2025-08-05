//
//  Endpoints.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

struct Endpoints {
    
    // API key from: https://newsapi.org/register
    static let apiKey = "5e88dc5d60be48d4a12b4a6515b73304"
    static let baseURL = "https://newsapi.org/v2"
    
    static var globalHeadlines: String {
        return "\(baseURL)/top-headlines?sources=bbc-news,cnn,reuters,associated-press,the-guardian-uk,al-jazeera-english&apiKey=\(apiKey)"
    }
    
    static func localNews(country: String) -> String {
        return "\(baseURL)/top-headlines?country=\(country)&pageSize=20&apiKey=\(apiKey)"
    }
    
    static func searchNews(query: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        return "\(baseURL)/everything?q=\(encodedQuery)&sortBy=publishedAt&pageSize=50&apiKey=\(apiKey)"
    }
    
    static func searchLocalNews(query: String, country: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        return "\(baseURL)/everything?q=\(encodedQuery)&country=\(country)&sortBy=publishedAt&pageSize=20&apiKey=\(apiKey)"
    }
}

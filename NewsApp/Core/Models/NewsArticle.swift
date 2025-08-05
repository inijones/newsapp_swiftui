//
//  SwiftUIView.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI
import Foundation

struct NewsArticle: Identifiable, Codable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let source: Source
    let author: String?
    let content: String?
    
    
    var id: String { url }
    
    struct Source: Codable {
        let id: String?
        let name: String
    }
    
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: publishedAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return publishedAt
    }
}

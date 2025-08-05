//
//  NewsAPIResponse.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}


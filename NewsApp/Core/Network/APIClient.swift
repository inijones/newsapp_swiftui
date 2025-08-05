//
//  APIClient.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

class APIClient {
    static let shared = APIClient()
    private let session = URLSession.shared
    
    private init() {}
    
    func fetchGlobalNews() async throws -> [NewsArticle] {
        let endpoint = Endpoints.globalHeadlines
        return try await fetchNews(from: endpoint)
    }
    
    func fetchLocalNews(country: String) async throws -> [NewsArticle] {
        let endpoint = Endpoints.localNews(country: country)
        return try await fetchNews(from: endpoint)
    }
    
    func searchNews(query: String) async throws -> [NewsArticle] {
        let endpoint = Endpoints.searchNews(query: query)
        return try await fetchNews(from: endpoint)
    }
    
    func searchNewsWithLocation(query: String, country: String) async throws -> [NewsArticle] {
        // First get local results, then global results
        async let localResults = searchLocalNews(query: query, country: country)
        async let globalResults = searchNews(query: query)
        
        let local = try await localResults
        let global = try await globalResults
        
        // Combine with local results first
        var combined = local
        let localUrls = Set(local.map { $0.url })
        let uniqueGlobal = global.filter { !localUrls.contains($0.url) }
        combined.append(contentsOf: uniqueGlobal)
        
        return combined
    }
    
    private func searchLocalNews(query: String, country: String) async throws -> [NewsArticle] {
        let endpoint = Endpoints.searchLocalNews(query: query, country: country)
        return try await fetchNews(from: endpoint)
    }
    
    private func fetchNews(from endpoint: String) async throws -> [NewsArticle] {
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let newsResponse = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
            return newsResponse.articles
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Unable to fetch news. Please try again."
        case .decodingError:
            return "Unable to process news data."
        }
    }
}


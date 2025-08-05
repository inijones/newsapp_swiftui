//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var recentSearches: [String] = []
    
    private let locationManager = LocationManager.shared
    private var searchTask: Task<Void, Never>?
    
    init() {
        loadRecentSearches()
    }
    
    func search(query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            articles = []
            return
        }
        
        searchTask?.cancel()
        
        searchTask = Task {
            isLoading = true
            errorMessage = nil
            
            do {
                try await Task.sleep(nanoseconds: 300_000_000) // Debounce
                
                if Task.isCancelled { return }
                
                let fetchedArticles: [NewsArticle]
                
                // Use location-aware search if location is available
                if locationManager.isLocationAvailable {
                    fetchedArticles = try await APIClient.shared.searchNewsWithLocation(
                        query: query,
                        country: locationManager.currentCountry
                    )
                } else {
                    fetchedArticles = try await APIClient.shared.searchNews(query: query)
                }
                
                if Task.isCancelled { return }
                
                articles = fetchedArticles
                addToRecentSearches(query)
            } catch {
                if !Task.isCancelled {
                    errorMessage = error.localizedDescription
                    loadSampleSearchData(for: query)
                }
            }
            
            if !Task.isCancelled {
                isLoading = false
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
        articles = []
        errorMessage = nil
        searchTask?.cancel()
    }
    
    func deleteRecentSearch(_ search: String) {
        recentSearches.removeAll { $0 == search }
        saveRecentSearches()
    }
    
    func clearAllRecentSearches() {
        recentSearches.removeAll()
        saveRecentSearches()
    }
    
    private func addToRecentSearches(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        recentSearches.removeAll { $0 == trimmedQuery }
        recentSearches.insert(trimmedQuery, at: 0)
        
        if recentSearches.count > 10 {
            recentSearches = Array(recentSearches.prefix(10))
        }
        
        saveRecentSearches()
    }
    
    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    }
    
    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
    }
    
    private func loadSampleSearchData(for query: String) {
        let locationName = locationManager.currentCity ?? "your area"
        
        articles = [
            NewsArticle(
                title: "Local: \(query.capitalized) Initiative Launches in \(locationName)",
                description: "New \(query.lowercased()) program announced by local authorities with community support.",
                url: "https://example.com/local-\(query.lowercased())-2024",
                urlToImage: "https://via.placeholder.com/400x200/8b5cf6/ffffff?text=Local+\(query.capitalized)",
                publishedAt: "2024-12-15T11:30:00Z",
                source: NewsArticle.Source(id: "local-search", name: "Local News"),
                author: "Local Reporter",
                content: "A new \(query.lowercased()) initiative has been announced by local officials..."
            ),
            NewsArticle(
                title: "Global: \(query.capitalized) Trends Shape International Markets",
                description: "Worldwide \(query.lowercased()) developments influence economic and social patterns globally.",
                url: "https://example.com/global-\(query.lowercased())-2024",
                urlToImage: "https://via.placeholder.com/400x200/ec4899/ffffff?text=Global+\(query.capitalized)",
                publishedAt: "2024-12-15T09:45:00Z",
                source: NewsArticle.Source(id: "global-search", name: "Global Times"),
                author: "International Correspondent",
                content: "Recent \(query.lowercased()) developments have created significant impact across multiple sectors..."
            )
        ]
    }
}

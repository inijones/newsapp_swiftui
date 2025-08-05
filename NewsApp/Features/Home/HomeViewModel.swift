//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchArticles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedArticles = try await APIClient.shared.fetchGlobalNews()
            articles = fetchedArticles
        } catch {
            errorMessage = error.localizedDescription
            loadSampleGlobalData()
        }
        
        isLoading = false
    }
    
    private func loadSampleGlobalData() {
        articles = [
            NewsArticle(
                title: "Global: Technology Giants Report Record Quarterly Earnings",
                description: "Major tech companies exceed expectations as digital transformation accelerates worldwide.",
                url: "https://example.com/tech-earnings-2024",
                urlToImage: "https://via.placeholder.com/400x200/1e40af/ffffff?text=Tech+News",
                publishedAt: "2024-12-15T10:30:00Z",
                source: NewsArticle.Source(id: "tech-times", name: "Tech Times"),
                author: "Sarah Chen",
                content: "The world's largest technology companies have reported unprecedented quarterly earnings..."
            ),
            NewsArticle(
                title: "International Climate Summit Reaches Breakthrough Agreement",
                description: "195 countries unite on ambitious climate targets for the next decade in historic deal.",
                url: "https://example.com/climate-summit-2024",
                urlToImage: "https://via.placeholder.com/400x200/059669/ffffff?text=Climate+News",
                publishedAt: "2024-12-15T08:15:00Z",
                source: NewsArticle.Source(id: "global-news", name: "Global News Network"),
                author: "Dr. Maria Rodriguez",
                content: "In a landmark decision that took three weeks of intensive negotiations..."
            ),
            NewsArticle(
                title: "World Cup Finals Break Global Viewership Records",
                description: "Historic football match draws 2 billion viewers as underdogs claim stunning victory.",
                url: "https://example.com/world-cup-finals-2024",
                urlToImage: "https://via.placeholder.com/400x200/dc2626/ffffff?text=Sports+News",
                publishedAt: "2024-12-14T22:45:00Z",
                source: NewsArticle.Source(id: "sports-world", name: "Sports World"),
                author: "James Mitchell",
                content: "Last night's World Cup final will be remembered as one of the greatest sporting moments..."
            ),
            NewsArticle(
                title: "Breakthrough in Renewable Energy Storage Technology",
                description: "Scientists develop revolutionary battery technology that could transform clean energy adoption.",
                url: "https://example.com/energy-breakthrough-2024",
                urlToImage: "https://via.placeholder.com/400x200/7c3aed/ffffff?text=Science+News",
                publishedAt: "2024-12-14T16:20:00Z",
                source: NewsArticle.Source(id: "science-daily", name: "Science Daily"),
                author: "Dr. Amanda Foster",
                content: "Researchers at leading universities have announced a major breakthrough in energy storage..."
            )
        ]
    }
}

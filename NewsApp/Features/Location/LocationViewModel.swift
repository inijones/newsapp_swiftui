//
//  LocationViewModel.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

@MainActor
class LocationViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let locationManager = LocationManager.shared
    
    func fetchLocalNews() async {
        isLoading = true
        errorMessage = nil
        
        let country = locationManager.currentCountry
        
        do {
            let fetchedArticles = try await APIClient.shared.fetchLocalNews(country: country)
            articles = fetchedArticles
        } catch {
            errorMessage = error.localizedDescription
            loadSampleLocalData()
        }
        
        isLoading = false
    }
    
    private func loadSampleLocalData() {
        let locationName = locationManager.currentCity ?? "your area"
        
        articles = [
            NewsArticle(
                title: "Local: City Council Approves Major Infrastructure Investment",
                description: "New transportation and utilities upgrades planned for \(locationName) over next five years.",
                url: "https://example.com/local-infrastructure-2024",
                urlToImage: "https://via.placeholder.com/400x200/0ea5e9/ffffff?text=Local+News",
                publishedAt: "2024-12-15T14:20:00Z",
                source: NewsArticle.Source(id: "local-tribune", name: "Local Tribune"),
                author: "Maria Garcia",
                content: "The city council has unanimously approved a comprehensive infrastructure plan..."
            ),
            NewsArticle(
                title: "Local Business District Sees Record Growth This Quarter",
                description: "Small businesses in \(locationName) report strongest sales figures in five years.",
                url: "https://example.com/local-business-growth-2024",
                urlToImage: "https://via.placeholder.com/400x200/10b981/ffffff?text=Business+News",
                publishedAt: "2024-12-15T12:30:00Z",
                source: NewsArticle.Source(id: "business-local", name: "Local Business Journal"),
                author: "Robert Kim",
                content: "Local entrepreneurs and established businesses alike are celebrating exceptional growth..."
            ),
            NewsArticle(
                title: "Weather Alert: Seasonal Changes Expected This Week",
                description: "Meteorologists forecast significant weather patterns affecting the \(locationName) region.",
                url: "https://example.com/weather-update-2024",
                urlToImage: "https://via.placeholder.com/400x200/f59e0b/ffffff?text=Weather+News",
                publishedAt: "2024-12-15T09:15:00Z",
                source: NewsArticle.Source(id: "weather-service", name: "Local Weather Service"),
                author: "Weather Team",
                content: "The regional weather service has issued updates for changing conditions..."
            )
        ]
    }
}

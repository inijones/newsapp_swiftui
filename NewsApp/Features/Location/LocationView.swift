//
//  LocationView.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

struct LocationView: View {
    @StateObject private var viewModel = LocationViewModel()
    @StateObject private var locationManager = LocationManager.shared
    @State private var selectedArticle: NewsArticle?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                // Loading State
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading local news...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                }
                // Error State
                else if let errorMessage = viewModel.errorMessage, viewModel.articles.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "location.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Unable to load local news")
                            .font(.headline)
                        
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Try Again") {
                            Task { await viewModel.fetchLocalNews() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
                // Success State
                else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Location Header
                            if let city = locationManager.currentCity {
                                HStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.blue)
                                    Text("News from \(city)")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.top, 8)
                            }

                            // Article List
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.articles) { article in
                                    NewsCard(article: article)
                                        .onTapGesture {
                                            selectedArticle = article
                                        }
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await viewModel.fetchLocalNews()
                    }
                }
            }
            .navigationTitle("Local News")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchLocalNews()
            }
            .sheet(item: $selectedArticle) { article in
                NewsDetailView(article: article)
            }
        }
    }
}


#Preview {
    LocationView()
}

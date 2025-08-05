//
//  HomeView.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedArticle: NewsArticle?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading global news...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                } else if let errorMessage = viewModel.errorMessage, viewModel.articles.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "globe.americas")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Unable to load news")
                            .font(.headline)
                        
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Try Again") {
                            Task { await viewModel.fetchArticles() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.articles) { article in
                                NewsCard(article: article)
                                    .onTapGesture {
                                        selectedArticle = article
                                    }
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await viewModel.fetchArticles()
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task { await viewModel.fetchArticles() }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
        .task {
            await viewModel.fetchArticles()
        }
        .sheet(item: $selectedArticle) { article in
            NewsDetailView(article: article)
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

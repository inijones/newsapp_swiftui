//
//  SearchView.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var selectedArticle: NewsArticle?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack {
                    // Search Bar
                    HStack {
                        TextField("Search news...", text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                Task { await viewModel.search(query: viewModel.searchText) }
                            }
                            .submitLabel(.search)

                        if !viewModel.searchText.isEmpty {
                            Button(action: viewModel.clearSearch) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Recent Searches
                    if viewModel.articles.isEmpty && !viewModel.searchText.isEmpty && !viewModel.recentSearches.isEmpty {
                        List {
                            Section(header: Text("Recent Searches")) {
                                ForEach(viewModel.recentSearches, id: \.self) { term in
                                    HStack {
                                        Text(term)
                                            .onTapGesture {
                                                viewModel.searchText = term
                                                Task { await viewModel.search(query: term) }
                                            }

                                        Spacer()

                                        Button(action: {
                                            viewModel.deleteRecentSearch(term)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }

                                Button("Clear All", role: .destructive) {
                                    viewModel.clearAllRecentSearches()
                                }
                            }
                        }
                    }

                    // Loading State
                    else if viewModel.isLoading && viewModel.articles.isEmpty {
                        Spacer()
                        ProgressView("Searching news...")
                            .scaleEffect(1.2)
                        Spacer()
                    }

                    // Error State
                    else if let error = viewModel.errorMessage, viewModel.articles.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)

                            Text("Something went wrong")
                                .font(.headline)

                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)

                            Button("Try Again") {
                                Task {
                                    await viewModel.search(query: viewModel.searchText)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        Spacer()
                    }

                    // Search Results
                    else {
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
                            await viewModel.search(query: viewModel.searchText)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .sheet(item: $selectedArticle) { article in
                NewsDetailView(article: article)
            }
        }
    }
}


#Preview {
    SearchView()
}

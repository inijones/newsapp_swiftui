//
//  NewsDetailView.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

struct NewsDetailView: View {
    let article: NewsArticle
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(LinearGradient(
                                colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay(
                                Image(systemName: "newspaper")
                                    .foregroundColor(.blue)
                                    .font(.largeTitle)
                            )
                    }
                    .frame(maxHeight: 250)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(article.source.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Text(article.formattedDate)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(article.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        if let author = article.author {
                            Text("By \(author)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        if let description = article.description {
                            Text(description)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        
                        if let content = article.content {
                            Text(content)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer(minLength: 20)
                        
                        Button(action: {
                            if let url = URL(string: article.url) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Text("Read Full Article")
                                    .fontWeight(.semibold)
                                Image(systemName: "arrow.up.right.square")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Article")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: shareArticle) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    private func shareArticle() {
        let activityVC = UIActivityViewController(
            activityItems: [article.title, article.url],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}


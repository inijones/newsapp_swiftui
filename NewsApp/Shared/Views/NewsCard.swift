//
//  NewsCard.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

struct NewsCard: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.largeTitle)
                    )
            }
            .frame(height: 200)
            .clipped()
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(article.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Description
                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                // Source and Date
                HStack {
                    Text(article.source.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text(article.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

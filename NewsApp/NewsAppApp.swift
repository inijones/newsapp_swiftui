//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Inijones on 05/08/2025.
//

import SwiftUI

@main
struct NewsAppApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }

                LocationView()
                    .tabItem { Label("Location", systemImage: "location") }

                SearchView()
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
            }
        }
    }
}

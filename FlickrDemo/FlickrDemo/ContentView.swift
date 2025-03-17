//
//  ContentView.swift
//  FlickerDemo
//
//  Created by Jerry Walton on 3/16/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlickrViewModel()
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 2)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(viewModel.images) { item in
                            NavigationLink(destination: ImageDetailView(item: item)) {
                                AsyncImage(url: URL(string: item.media.m)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 150)
                                .clipped()
                            }
                            .accessibilityLabel(item.title)
                        }
                    }
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
    
    private var searchBar: some View {
        TextField("Search images...", text: $viewModel.searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}

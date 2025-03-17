//
//  ImageDetailView.swift
//  FlickerDemo
//
//  Created by Jerry Walton on 3/16/25.
//
import SwiftUI

struct ImageDetailView: View {
    let item: FlickrItem
    @State private var imageSize: CGSize = .zero
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: item.media.m)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.title)
                    
                    Text(item.author)
                        .font(.subheadline)
                    
                    Text(item.description)
                        .font(.body)
                    
                    if let dimensions = item.imageDimensions {
                        Text("Dimensions: \(dimensions.width) x \(dimensions.height)")
                            .font(.caption)
                    }
                    
                    Text(formatDate(item.published))
                        .font(.caption)
                }
                .padding()
            }
        }
        .navigationBarItems(trailing: shareButton)
    }
    
    private var shareButton: some View {
        Button(action: {
            let items: [Any] = [
                item.title,
                item.description,
                item.author,
                URL(string: item.media.m)!
            ]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
        }) {
            Image(systemName: "square.and.arrow.up")
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

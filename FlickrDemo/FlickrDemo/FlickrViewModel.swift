//
//  FlickrViewModel.swift
//  FlickrDemo
//
//  Created by Jerry Walton on 3/16/25.
//
import Foundation
import Combine

class FlickrViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var images: [FlickrItem] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchImages(for: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func searchImages(for query: String) {
        guard !query.isEmpty else {
            images = []
            return
        }
        
        isLoading = true
        
        let tags = query.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ",")
        
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags)"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .replaceError(with: FlickrResponse(items: [], title: ""))
            .map(\.items)
            .assign(to: &$images)
    }
    
    public func testMe() -> Bool {
        return false
    }
}

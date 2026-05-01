//
//  ImageServiceProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


import Foundation

actor ImageService: ImageServiceProtocol {
    
    func fetchRandomImage() async -> String {
        
        guard let url = URL(string: Constants.imageUrl) else { return "" }
        do {
            let (_, response) = try await URLSession.shared.data(from: url)
            return response.url?.absoluteString ?? ""
        } catch {
            return ""
        }
    }
}

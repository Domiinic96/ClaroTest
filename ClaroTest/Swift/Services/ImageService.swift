//
//  ImageServiceProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


import Foundation

actor ImageService: ImageServiceProtocol {
    
    func fetchRandomImage() async ->  Result<String, Error> {
        
        guard let url = URL(string: Constants.imageUrl) else {
            return .failure(URLError(.badURL)) }
        do {
            let (_, response) = try await URLSession.shared.data(from: url)
            
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode), let finalUrl = response.url?.absoluteString else {
                return .failure(URLError(.badServerResponse))
            }
            
            return .success(finalUrl)
        } catch {
            return .failure(error)
        }
    }
}

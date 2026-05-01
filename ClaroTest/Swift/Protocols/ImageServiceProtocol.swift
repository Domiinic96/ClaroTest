//
//  ImageServiceProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


protocol ImageServiceProtocol:Sendable {
    func fetchRandomImage() async -> String
}
//
//  ContactViewModelProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


@MainActor
protocol ContactViewModelProtocol: ObservableObject {
    var name: String { get set }
    var lastName: String { get set }
    var phone: String { get set }
    var imageUrl: String { get set }
    
    func loadImage() async
    func save()
}
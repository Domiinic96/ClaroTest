//
//  ContactExtension.swift
//  ClaroTest
//
//  Created by Luis Santana on 1/5/26.
//
import Foundation
extension Contact {
    static var mock: Contact {
        let c = Contact()
        c.name = "Luis"
        c.lastName = "Santana"
        c.phone = "8296489596"
        c.imageUrl = "https://randomuser.me/api/portraits/men/44.jpg"
        return c
    }
}

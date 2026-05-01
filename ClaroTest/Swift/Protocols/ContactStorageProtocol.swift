//
//  ContactStorageProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


@objc protocol ContactStorageProtocol {
    func save(_ contacts: [Contact])
    func fetch() -> [Contact]
    func removeAll()
}

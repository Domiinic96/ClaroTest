//
//  ContactStorageProtocol.swift
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//

import Foundation
@objc protocol ContactStorageProtocol {
    func save(_ contacts: [Contact])
    func fetch() -> [Contact]
    func removeAll()
}

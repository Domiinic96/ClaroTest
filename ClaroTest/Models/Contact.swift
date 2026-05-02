//
//  ContactDto.swift
//  ClaroTest
//
//  Created by Luis Santana on 2/5/26.
//

import Foundation

@objcMembers
public class Contact: NSObject, Codable {
    public var id: String = ""
     public var name: String = ""
     public var lastName: String = ""
     public var phone: String = ""
     public var imageUrl: String = ""
}

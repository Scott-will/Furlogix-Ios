//
//  User.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-09.
//

struct User : Decodable{ 
    let id : UInt8
    let name : String
    let surName : String
    let petName : String
    let email : String
}

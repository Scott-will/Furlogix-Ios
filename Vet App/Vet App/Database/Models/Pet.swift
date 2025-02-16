//
//  Pet.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

struct Pet : Decodable{
    let id : Int64
    let name : String
    let type : String
    let description : String
    let userId : Int64
}

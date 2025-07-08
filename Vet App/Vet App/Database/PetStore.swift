//
//  PetStore.swift
//  Vet App
//
//  Created by Scott Williams on 2025-02-15.
//

import SQLite
import Foundation

class PetStore{
    
    static let DIR_USERS_DB = "Furlogix"
    static let STORE_NAME = "pets.sqlite3"
    private var db: Connection? = nil
    private let pets = Table("pets")

    private let id = SQLite.Expression<Int64>("id")
    private let name = SQLite.Expression<String>("name")
    private let type = SQLite.Expression<String>("type")
    private let description = SQLite.Expression<String>("description")
    private let userId = SQLite.Expression<Int64>("userId")
    private let photoUri = SQLite.Expression<String>("photoUri")

    static let instance = PetStore()

     

    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in:
                .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_USERS_DB)

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                createTable()
                print("SQLiteDataStore init successfully at: \(dbPath) ")
             } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
             }
         } else {
             db = nil
         }
    }
    
    private func createTable() {
        guard let database = db else {
            return
        }
        do {
            try database.run(pets.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
                table.column(type)
                table.column(description)
                table.column(userId)
                table.column(photoUri)
                table.foreignKey(userId, references: UsersStore.instance.GetTable(), UsersStore.instance.GetPrimaryKeyColumn())
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }
    
    public func GetTable() -> Table{
        return pets
    }
    
    public func GetPrimaryKeyColumn() -> SQLite.Expression<Int64>{
        return id;
    }
    
    public func GetPetsForUser(user_id : Int64) -> [Pet]{
        var petList : [Pet] = []
        guard let database = db else {return []}
        do {
            for pet in try database.prepare(self.pets.filter(userId == user_id)){
                petList.append(
                    Pet(
                        id: pet[id],
                        name: pet[name],
                        type: pet[type],
                        description: pet[description],
                        userId: pet[userId],
                    photoUri: pet[photoUri]))
            }
        }
        catch {
            print(error)
        }
        return petList
    }
    
    public func GetPetById(petId : Int64) -> Pet?{
        guard let database = db else {return nil}
        do {
            for pet in try database.prepare(self.pets.filter(id == petId)){
                return Pet(
                    id: pet[id],
                    name: pet[name],
                    type: pet[type],
                    description: pet[description],
                    userId: pet[userId],
                    photoUri: pet[photoUri]
                )
            }
        }
        catch{
            print(error)
            return nil
        }
        return nil
    }
    
    func insert(pet : Pet) -> Int64? {
        guard let database = db else { return nil }

        let insert = pets.insert(self.name <- pet.name,
                                 self.description <- pet.description,
                                 self.type <- pet.type,
                                 self.userId <- pet.userId,
                                 self.photoUri <- photoUri)
        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }
    
    func update(pet : Pet) -> Int64? {
        guard let database = db else{ return nil}
        let petToUpdate = pets.filter(id == pet.id)
        let update = petToUpdate.update(
            self.name <- pet.name,
            self.description <- pet.description,
            self.type <- pet.type,
            self.userId <- pet.userId,
            self.photoUri <- pet.photoUri
        )
        do {
            let rowID = try database.run(update)
            return Int64(rowID)
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func delete(petId : Int64) -> Bool {
        guard let database = db else { return false }
        let petToDelete = pets.filter(id == petId)
        do {
            try database.run(petToDelete.delete())
            return true
        } catch {
            print(error)
            return false
        }
    }
}

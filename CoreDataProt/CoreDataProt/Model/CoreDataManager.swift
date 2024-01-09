//
//  CoreDataManager.swift
//  CoreDataProt
//
//  Created by Илья Капёрский on 16.12.2023.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    
    static var instance: CoreDataManager { get }
    
    var persistentContainer: NSPersistentContainer { get }
    
    var context: NSManagedObjectContext { get }
    
    func saveContext ()
    
}

final class CoreDataManager:  CoreDataManagerProtocol {
    
    static let instance = CoreDataManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataProt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addUser(fullName: String, birthDay: Date, isMale: Bool, ava: String) {
        let newUser = User(context: context)
        newUser.id = getNextId()
        newUser.fullName = fullName
        newUser.birthDay = birthDay
        newUser.isMale = isMale
        newUser.ava = ava
        saveContext()

    }
    
    func getUsers() -> [User]{
        let fetchRequest = User.fetchRequest() as NSFetchRequest<User>
        
        var users = [User]()
        
        users = try! context.fetch(fetchRequest)
        return users
    }
    
    func updateUser(user: User, newFullName: String, newBirthDay: Date, newIsMale: Bool, newAva: String) {
        
        let fetchUser: NSFetchRequest<User> = User.fetchRequest()
        fetchUser.predicate = NSPredicate(format: "id = %@", String(user.id))
        let results = try? context.fetch(fetchUser)
        if results?.count != 0 {
            // here you are updating
            let cdUser = results?.first
            cdUser?.fullName = newFullName
            cdUser?.birthDay = newBirthDay
            cdUser?.isMale = newIsMale
        }

        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func clearUsers() {
        let fetchRequest = User.fetchRequest() as! NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
    
    func deleteUser(user: User) {
        context.delete(user)
    }
    
    func createDefualtValues() {
        let existinctUsers = getUsers()
        if (existinctUsers.filter({$0.id == 1}).count == 0) {
            addUser(fullName: "Dart Vader", birthDay: Date.now, isMale: true, ava: "DV")
        }
        
        if (existinctUsers.filter({$0.id == 2}).count == 0) {
            addUser(fullName: "Luke Skywalker", birthDay: Date.now, isMale: true, ava: "LS")
        }
        
        if (existinctUsers.filter({$0.id == 3}).count == 0) {
            addUser(fullName: "Padme Amidala", birthDay: Date.now, isMale: false, ava: "PA")
        }
    }
    
    private func getNextId() -> Int16 {
        return (getUsers().last?.id ?? 0) + 1
    }
    
}

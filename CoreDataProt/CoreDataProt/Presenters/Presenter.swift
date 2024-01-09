//
//  Presenter.swift
//  CoreDataProt
//
//  Created by Илья Капёрский on 03.01.2024.
//

import Foundation

protocol ViewOutputDelegate: AnyObject {
    func getData()
    func saveData()
    func addUser(fullName: String, birthDay: Date, isMale: Bool, ava: String)
    func deleteUser(user: User, indexPath: IndexPath)
    func clearUsers()
}

final class Presenter {
    
    weak private var viewInputDelegate: ViewInputDelegate?
    var users = [User]()
    
    func setViewinputDelegate(viewinputDelegate: ViewInputDelegate) {
        self.viewInputDelegate = viewinputDelegate
    }
    
    func createDefaultData() {
        CoreDataManager.instance.createDefualtValues()
    }
    
    func getDataFromCD() {
        self.users = CoreDataManager.instance.getUsers()
        self.viewInputDelegate?.setupData(data: self.users)
    }
    
    func saveDataToCD() {
        CoreDataManager.instance.saveContext()
    }
    
    func addUserToCD(fullName: String, birthDay: Date, isMale: Bool, ava: String) {
        CoreDataManager.instance.addUser(fullName: fullName, birthDay: birthDay, isMale: isMale, ava: ava)
    }
    
    func deleteUserFromCD(user: User, indexPath: IndexPath) {
        CoreDataManager.instance.deleteUser(user: user)
        self.viewInputDelegate?.deleteData(indexPath: indexPath)
    }
    
    func clearUsersFromCD() {
        CoreDataManager.instance.clearUsers()
    }
    
}

extension Presenter: ViewOutputDelegate {
    func getData() {
        self.createDefaultData()
        self.getDataFromCD()
    }
    
    func saveData() {
        self.saveDataToCD()
        self.getDataFromCD()
    }
    
    func addUser(fullName: String, birthDay: Date, isMale: Bool, ava: String) {
        self.addUserToCD(fullName: fullName, birthDay: birthDay, isMale: isMale, ava: ava)
        self.getDataFromCD()
    }
    
    func deleteUser(user: User, indexPath: IndexPath) {
        self.deleteUserFromCD(user: user, indexPath: indexPath)
    }
    
    func clearUsers() {
        self.clearUsersFromCD()
        self.getDataFromCD()
    }
}

//
//  MainPresenter.swift
//  CoreDataProt
//
//  Created by Илья Капёрский on 05.12.2023.
//

import Foundation

protocol MainViewProtocol: class {
    
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, coreDataManager: CoreDataManagerProtocol)
    
    func createDefualtValues()
    
    func getUsers() -> [User]
    
    func addUser(fullName: String, birthDay: Date, isMale: Bool, ava: String)
    
    func deleteUser(user: User)
    
    func updateUser(user: User, newFullName: String, newBirthDay: Date, newIsMale: Bool, newAva: String)
}

class MainPresenter: MainViewPresenterProtocol
{
    let view: MainViewProtocol
    let coreDataManager: CoreDataManagerProtocol
    
    required init(view: MainViewProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.view = view
        self.coreDataManager = coreDataManager
    }
    
    func getUsers() -> [User]{
        coreDataManager.instance.getUsers()
    }
    
    func createDefualtValues() {
        coreDataManager.instance.createDefualtValues()
    }
    
    func addUser(fullName: String, birthDay: Date, isMale: Bool, ava: String) {
        coreDataManager.instance.addUser(fullName: fullName, birthDay: birthDay, isMale: isMale, ava: ava)
    }
    
    func deleteUser(user: User) {
        coreDataManager.instance.deleteUser(user: user)
    }
    
    func updateUser(user: User, newFullName: String, newBirthDay: Date, newIsMale: Bool, newAva: String) {
        coreDataManager.instance.updateUser(user: user, newFullName: newFullName, newBirthDay: newBirthDay, newIsMale: newIsMale, newAva: newAva)
    }
}

//
//  ViewController.swift
//  CoreDataProt
//
//  Created by Илья Капёрский on 03.12.2023.
//

import UIKit

protocol ViewInputDelegate: AnyObject {
    func setupData(data: [User])
    func deleteData(indexPath: IndexPath)
    
}

final class MainViewController: UIViewController {

    private let presenter = Presenter()
    private var users = [User]()
    weak private var viewOutputDelegate: ViewOutputDelegate?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = "New character.."
        textField.textColor = UIColor.black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.shadowColor = UIColor.white.cgColor
        textField.layer.shadowOpacity = 0.4
        textField.layer.shadowRadius = 20
        textField.layer.shadowOffset = .zero
        textField.layer.shouldRasterize = true
        textField.layer.rasterizationScale = UIScreen.main.scale
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 20
        textField.leftViewMode = .always
        textField.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Add character", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
            let tableView = UITableView(frame: .zero, style: .grouped)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupPreferences()
    }
    
    private func setupPreferences() {
        presenter.setViewinputDelegate(viewinputDelegate: self)
        self.viewOutputDelegate = presenter
        self.viewOutputDelegate?.getData()
        //self.viewOutputDelegate?.clearUsers()
        let nav = navigationController?.navigationBar
        nav?.prefersLargeTitles = true
        nav?.barStyle = .black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "Users"
        view.backgroundColor = .black
    }


    private func setupLayout() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 30),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHierarchy() {
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(tableView)
    }
    
    @objc func buttonPressed () {
        
        self.viewOutputDelegate?.addUser(fullName: self.textField.text ?? "Noname", birthDay: Date.now, isMale: true, ava: "")
        updateView()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate, DetailVCDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        let cell = tableView.cellForRow(at: indexPath)
        let id = String(users[indexPath.row].id)
        print(cell?.textLabel?.text ?? "" + id)
        detailVC.delegate = self
        detailVC.user = users[indexPath.row]
        changeViewController(detailVC)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        return createDefaultCellbySetting(user)
    }
    
    func createDefaultCellbySetting(_ setting: User) -> UITableViewCell{
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = setting.fullName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.layer.cornerRadius = 5
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func changeViewController(_ nextVC: UIViewController) {
        navigationController?.pushViewController(nextVC, animated: true)
        self.viewOutputDelegate?.getData()
        updateView()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let user = users[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [self]  (contextualAction, view, boolValue) in

            self.viewOutputDelegate?.deleteUser(user: user, indexPath: indexPath)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        updateView()
        return swipeActions
    }
    
    func updateView() {
        tableView.reloadData()
    }
}

extension MainViewController: ViewInputDelegate {
    
    func setupData(data: [User]) {
        self.users = data
    }
    
    func deleteData(indexPath: IndexPath) {
        self.users.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}


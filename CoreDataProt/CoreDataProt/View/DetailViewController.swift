//
//  DetailViewController.swift
//  CoreDataProt
//
//  Created by Илья Капёрский on 07.12.2023.
//

import UIKit

protocol DetailVCDelegate {
    func updateView()
}

final class DetailViewController: UIViewController{
    
    var presenter = Presenter()
    weak private var viewOutputDelegate: ViewOutputDelegate?
    
    var delegate: DetailVCDelegate?
    
    func update() {
        delegate?.updateView()
    }

    private enum CustomConstraints: CGFloat {
        case padding10 = 10
        case padding20 = 20
        case padding40 = 40
        case padding200 = 200
    }
    
    var user: User?
    {
        didSet{
            name.text = user?.fullName
            title = user?.fullName
            birth.date = user!.birthDay!
            gender.selectedSegmentIndex = user!.isMale ? 0 : 1
            ava.image = UIImage(named: user?.ava ?? "person.slash.fill")
        }
    }
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Edit", for: .normal)
        button.setTitle("Save", for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var upperView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ava: UIImageView = {
        var ava = UIImageView()
        ava.layer.cornerRadius = 150.0
        ava.layer.borderColor = UIColor.black.cgColor
        ava.layer.borderWidth = 3.0
        ava.clipsToBounds = true
        ava.translatesAutoresizingMaskIntoConstraints = false
        return ava
    }()
    
    private lazy var nameImage: UIImageView = {
        var nameIm = UIImageView()
        nameIm.image = UIImage(systemName: "person")
        nameIm.tintColor = .black
        nameIm.translatesAutoresizingMaskIntoConstraints = false
        return nameIm
    }()
    
    private lazy var name: UITextField = {
        var name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private lazy var birthImage: UIImageView = {
        var birthIm = UIImageView()
        birthIm.image = UIImage(systemName: "calendar")
        birthIm.tintColor = .black
        birthIm.translatesAutoresizingMaskIntoConstraints = false
        return birthIm
    }()
    
    private lazy var birth: UIDatePicker = {
        var birth = UIDatePicker()
        birth.datePickerMode = .date
        birth.isUserInteractionEnabled = false
        birth.translatesAutoresizingMaskIntoConstraints = false
        return birth
    }()
    
    private lazy var genderImage: UIImageView = {
        var genderIm = UIImageView()
        genderIm.image = UIImage(systemName: "figure.dress.line.vertical.figure")
        genderIm.tintColor = .black
        genderIm.translatesAutoresizingMaskIntoConstraints = false
        return genderIm
    }()
    
    private lazy var gender: UISegmentedControl = {
        var gender = UISegmentedControl(items: ["Male", "Female"])
        gender.backgroundColor = .black
        gender.tintColor = .white
        gender.isUserInteractionEnabled = false
        gender.translatesAutoresizingMaskIntoConstraints = false
        return gender
    }()
    
    
    override func viewDidLoad() {

        self.viewOutputDelegate = presenter
        super.viewDidLoad()
        setupViewSettings()
        setupHierarchy()
        setupLayout()
        
    }
    

    private func setupHierarchy() {
        view.addSubview(upperView)
        view.addSubview(button)
        view.addSubview(ava)
        view.addSubview(nameImage)
        view.addSubview(name)
        view.addSubview(birthImage)
        view.addSubview(birth)
        view.addSubview(genderImage)
        view.addSubview(gender)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            upperView.topAnchor.constraint(equalTo: view.topAnchor),
            upperView.leftAnchor.constraint(equalTo: view.leftAnchor),
            upperView.rightAnchor.constraint(equalTo: view.rightAnchor),
            upperView.bottomAnchor.constraint(equalTo: ava.centerYAnchor),
            
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -CustomConstraints.padding10.rawValue),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 70),
            
            ava.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CustomConstraints.padding10.rawValue),
            ava.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ava.widthAnchor.constraint(equalToConstant: 300),
            ava.heightAnchor.constraint(equalToConstant: 300),
            //ava.heightAnchor.constraint(equalToConstant: CustomConstraints.padding200.rawValue),
            
            nameImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CustomConstraints.padding20.rawValue),
            nameImage.centerYAnchor.constraint(equalTo: name.centerYAnchor),
           // nameImage.widthAnchor.constraint(equalToConstant: 20),
            
            
            name.topAnchor.constraint(equalTo: ava.bottomAnchor, constant: CustomConstraints.padding10.rawValue),
            name.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -CustomConstraints.padding20.rawValue),
            name.heightAnchor.constraint(equalToConstant: CustomConstraints.padding40.rawValue),
            
            
            birthImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CustomConstraints.padding20.rawValue),
            birthImage.centerYAnchor.constraint(equalTo: birth.centerYAnchor),
            //birthImage.widthAnchor.constraint(equalToConstant: 20),
            
            birth.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -CustomConstraints.padding20.rawValue),
            birth.topAnchor.constraint(equalTo: name.bottomAnchor, constant: CustomConstraints.padding10.rawValue),
            
            genderImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CustomConstraints.padding20.rawValue),
            genderImage.centerYAnchor.constraint(equalTo: gender.centerYAnchor),
            //genderImage.widthAnchor.constraint(equalToConstant: 20),
            
            gender.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -CustomConstraints.padding20.rawValue),
            gender.topAnchor.constraint(equalTo: birth.bottomAnchor, constant: CustomConstraints.padding10.rawValue)
            ])
        
    }
    
    private func setupViewSettings() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func buttonPressed () {
        if (button.isSelected) {
            self.viewOutputDelegate?.updateUser(user: self.user!, newFullName: self.name.text ?? "No name", newBirthDay: self.birth.date, newIsMale: self.gender.selectedSegmentIndex == 0, newAva: (self.user?.ava)!)
            viewDidLoad()
            update()
        }
        gender.isUserInteractionEnabled = !button.isSelected
        birth.isUserInteractionEnabled = !button.isSelected
        name.isUserInteractionEnabled = !button.isSelected
        button.isSelected.toggle()
    }
}

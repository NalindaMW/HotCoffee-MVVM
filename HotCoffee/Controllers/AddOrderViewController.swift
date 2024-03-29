//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Created by Nalinda Wickramarathna on 2022-08-30.
//

import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderDidCancel(controller: UIViewController)
}

class AddOrderViewController: UIViewController {

    private var viewModel = AddCoffeeOrderViewModel()
    var delegate: AddCoffeeOrderDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        coffeeSizesSegmentedControl = UISegmentedControl(items: viewModel.sizes)
        coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        coffeeSizesSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(coffeeSizesSegmentedControl)
        
        NSLayoutConstraint.activate([
            coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @IBAction func save() {
        if let validName = nameTextField.text, !validName.isEmpty,
           let validEmail = emailTextField.text, !validEmail.isEmpty {
            let selectedCoffeeSize = viewModel.sizes[coffeeSizesSegmentedControl.selectedSegmentIndex]
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                print("No coffee was selected")
                return
            }
            
            viewModel.name = validName
            viewModel.email = validEmail
            viewModel.selectedCoffeeType = viewModel.types[indexPath.row]
            viewModel.selectedCoffeeSize = selectedCoffeeSize
            
            Webservice().load(resource: Order.create(vm: viewModel)) { result in
                switch result {
                case .success(let order):
                    if let delegate = self.delegate {
                        DispatchQueue.main.async {
                            delegate.addCoffeeOrderDidSave(order: order, controller: self)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func close() {
        if let delegate = self.delegate {
            delegate.addCoffeeOrderDidCancel(controller: self)
        }
    }
}

extension AddOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeCell", for: indexPath)
        
        cell.textLabel?.text = viewModel.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

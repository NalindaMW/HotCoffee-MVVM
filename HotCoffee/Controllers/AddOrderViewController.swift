//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Created by Nalinda Wickramarathna on 2022-08-30.
//

import UIKit

class AddOrderViewController: UIViewController {

    private var viewModel = AddCoffeeOrderViewModel()
    
    @IBOutlet weak var tableView: UITableView!
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
    
    
}

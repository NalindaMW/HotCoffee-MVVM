//
//  ViewController.swift
//  HotCoffee
//
//  Created by Nalinda Wickramarathna on 4/15/22.
//

import UIKit

class OrdersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchOrders()
    }

    private func fetchOrders() {
        Webservice().load(resource: Order.getOrders) { [weak self] result in
            switch result {
                case .success(let orders):
                    print(orders)
                    self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                    self?.tableView.reloadData()
                
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let addCoffeeVC = navC.viewControllers.first as? AddOrderViewController else {
            fatalError("Error performing segue.")
        }
        
        addCoffeeVC.delegate = self
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderListViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListViewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderViewCell", for: indexPath)
        cell.textLabel?.text = vm.name
        cell.detailTextLabel?.text = vm.email
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension OrdersViewController: AddCoffeeOrderDelegate {
    func addCoffeeOrderDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        orderListViewModel.ordersViewModel.append(orderVM)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func addCoffeeOrderDidCancel(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}


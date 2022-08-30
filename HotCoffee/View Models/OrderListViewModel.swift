//
//  OrdersListViewModel.swift
//  HotCoffee
//
//  Created by Nalinda Wickramarathna on 2022-08-30.
//

import Foundation

struct OrderListViewModel {
    
    var ordersViewModel: [OrderViewModel]
    
    init() {
        self.ordersViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return ordersViewModel.count
    }
    
    func orderViewModel(at index: Int) -> OrderViewModel {
        return ordersViewModel[index]
    }
}

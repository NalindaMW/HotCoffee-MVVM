//
//  Order.swift
//  HotCoffee
//
//  Created by Nalinda Wickramarathna on 2022-08-30.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappucino
    case latte
    case espresso
    case cortado
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}

extension Order {
    init?(_ vm: AddCoffeeOrderViewModel) {
        guard let name = vm.name,
        let email = vm.email,
            let selectedType = CoffeeType(rawValue: vm.selectedCoffeeType!.lowercased()),
            let selectedSize = CoffeeSize(rawValue: vm.selectedCoffeeSize!.lowercased())  else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
}

extension Order {
    
    static var getOrders: Resource<[Order]> = {
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("Not a valid url")
        }
        
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order> {
        
        let order = Order(vm)
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("Not a valid url")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order.")
        }
        
        var resource = Resource<Order>(url: url)
        resource.httpMethod = .post
        resource.body = data
        
        return resource
    }
}

//
//  DiscoverProtocols.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Models

public protocol DiscoverModuleInput {
    var moduleOutput: DiscoverModuleOutput? { get }
}

public protocol DiscoverModuleOutput: AnyObject {
}

protocol DiscoverViewInput: AnyObject {
}

protocol DiscoverViewOutput: AnyObject {
    func requestData()
}

protocol DiscoverInteractorInput: AnyObject {
    func requestData()
}

protocol DiscoverInteractorOutput: AnyObject {
}

protocol DiscoverRouterInput: AnyObject {
}

protocol DiscoverRouterOutput: AnyObject {
}

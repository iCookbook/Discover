//
//  DiscoverProtocols.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Models
import Networking

public protocol DiscoverModuleInput {
    var moduleOutput: DiscoverModuleOutput? { get }
}

public protocol DiscoverModuleOutput: AnyObject {
}

protocol DiscoverViewInput: AnyObject {
    func fillData(with data: [Recipe], nextPageUrl: String?, withOverridingCurrentData: Bool)
    func showAlert(title: String, message: String)
}

protocol DiscoverViewOutput: AnyObject {
    func requestData(urlString: String?)
    func requestRandomData()
    func didSelectRecipe(_ recipe: Recipe)
}

protocol DiscoverInteractorInput: AnyObject {
    func requestData(urlString: String?)
    func requestRandomData()
}

protocol DiscoverInteractorOutput: AnyObject {
    func provideResponse(_ response: Response, withOverridingCurrentData: Bool)
    func handleError(_ error: NetworkManagerError)
}

protocol DiscoverRouterInput: AnyObject {
    func openRecipeDetailsModule(for recipe: Recipe)
}

protocol DiscoverRouterOutput: AnyObject {
}

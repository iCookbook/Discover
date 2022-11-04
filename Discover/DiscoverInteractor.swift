//
//  DiscoverInteractor.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Models
import Networking

final class DiscoverInteractor {
    weak var output: DiscoverInteractorOutput?
    
    // MARK: - Private Properties
    
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Init
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension DiscoverInteractor: DiscoverInteractorInput {
    func requestData(urlString: String? = nil) {
        /// We need to create different endpoints whether url was provided.
        var endpoint: EndpointProtocol!
        if let urlString = urlString {
            endpoint = URLEndpoint(urlString: urlString)
        } else {
            endpoint = Endpoint.random()
        }
        
        let request = NetworkRequest(endpoint: endpoint)
        networkManager.getResponse(request: request) { [unowned self] (result) in
            switch result {
            case .success(let response):
                output?.provideResponse(response)
            case .failure(let error):
                output?.handleError(error)
            }
        }
    }
}

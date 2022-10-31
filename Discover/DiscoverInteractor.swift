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
    func requestData() {
        let request = NetworkRequest(endpoint: Endpoint.random())
        networkManager.perform(request: request) { [unowned self] (result: Result<Response, NetworkManagerError>) in
            switch result {
            case .success(let response):
                output?.provideResponse(response)
            case .failure(let error):
                output?.handleError(error)
            }
        }
    }
}

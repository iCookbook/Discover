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
    func requestData(urlString: String?) {
        
        guard let urlString = urlString else {
            output?.handleError(.invalidURL)
            return
        }
        let endpoint = URLEndpoint(urlString: urlString)
        
        let request = NetworkRequest(endpoint: endpoint)
        networkManager.getResponse(request: request) { [unowned self] (result) in
            switch result {
            case .success(let response):
                output?.provideResponse(response, withOverridingCurrentData: false)
            case .failure(let error):
                output?.handleError(error)
            }
        }
    }
    
    func requestRandomData(overrideCurrentData: Bool) {
        let request = NetworkRequest(endpoint: Endpoint.random())
        networkManager.getResponse(request: request) { [unowned self] (result) in
            switch result {
            case .success(let response):
                output?.provideResponse(response, withOverridingCurrentData: overrideCurrentData)
            case .failure(let error):
                output?.handleError(error)
            }
        }
    }
}

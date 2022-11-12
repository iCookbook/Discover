//
//  DiscoverInteractor.swift
//  Discover
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Common
import Networking

final class DiscoverInteractor: BaseRecipesInteractor {
}

extension DiscoverInteractor: DiscoverInteractorInput {
    /// Provides data by url.
    /// - Parameter urlString: url to the source of data.
    func provideData(urlString: String?) {
        
        guard let urlString = urlString else {
            output?.handleError(.invalidURL)
            return
        }
        let endpoint = URLEndpoint(urlString: urlString)
        
        let request = NetworkRequest(endpoint: endpoint)
        networkManager.getResponse(request: request) { [unowned self] (result) in
            switch result {
            case .success(let response):
                output?.didProvidedResponse(response, withOverridingCurrentData: false)
            case .failure(let error):
                output?.handleError(error)
            }
        }
    }
}

//
//  NewsService.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import Alamofire
import Foundation
import SwiftyJSON

class NewsService {

    var datasource: NewsServiceProtocol
    var endoint: String = "https://hn.algolia.com/api/v1/search_by_date?query=mobile"

    init(datasource: NewsServiceProtocol) {
        self.datasource = datasource

        callService()
    }

    func callService() {


        AF.request(endoint, method: .get)
            .responseJSON { response in

                switch response.result {
                case .success:

                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case 200:
                            let jsonDecoder = JSONDecoder()

                            if let news = try? jsonDecoder.decode(
                                News.self,
                                from: response.data!
                            ) {
                                self.datasource.fetchNews(news: news)
                            }

                        default:
                            debugPrint()
                        }

                    } else {
                        // Error
                    }
                case let .failure(error):

                    self.datasource.serviceError(error: error)
                }
            }
    }

}

// MARK: Protocol

protocol NewsServiceProtocol {

    func fetchNews(news: News)
    func serviceError(error: Error)
}
//
//  NewsViewModel.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import Foundation

class NewsViewModel : NSObject, NewsServiceProtocol {

    private(set) var items: [NewsListItemViewModel]! {
        didSet {
            self.bindNewsViewModelToController()
            self.didFinishFetch?()
        }
    }

    var errorService: Error? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }


    var deletedNews: [String] = []

    let conditions: [(NewsListItemViewModel) -> Bool] = [
        {!$0.title.isEmpty},
        {!$0.url.isEmpty},
    ]


    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?

    var bindNewsViewModelToController : (() -> ()) = {}

    override init() {
        super.init()

        callService()
    }

    func callService() {
        _ = NewsService(datasource: self)
    }

    func delete(index: Int) {
        deletedNews.append(items[index].id)
        items.remove(at: index)

    }

    // MARK: Protocol News Service

    func fetchNews(news: News) {
        self.errorService = nil
        self.isLoading = false

        items = news.hits.map(NewsListItemViewModel.init)
        items = items.filter({ !deletedNews.contains($0.id) })
        items = items.filter {
          story in
          conditions.reduce(true) { $0 && $1(story) }
       }
    }


    func serviceError(error: Error) {
        errorService = error
        isLoading = false
    }


}

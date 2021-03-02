//
//  NewsViewModel.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import Foundation

class NewsViewModel: NSObject, NewsServiceProtocol {
    let conditions: [(NewsListItemViewModel) -> Bool] = [
        { !$0.title.isEmpty },
        { !$0.url.isEmpty }
    ]

    private(set) var items: [NewsListItemViewModel]! {
        didSet {
            bindNewsViewModelToController()
        }
    }

    var errorService: Error?
    var conectivity: Bool = false

    var deletedNews: [String] = []
    var backupList: [NewsListItemViewModel]!

    var bindNewsViewModelToController: (() -> Void) = {}
    
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
        errorService = nil

        var filter = news.hits.map(NewsListItemViewModel.init)
        filter = filter.filter { !deletedNews.contains($0.id) }
        filter = filter.filter {
            story in
            conditions.reduce(true) { $0 && $1(story) }
        }

        backupList = filter
        items = filter
    }

    func serviceError(error: Error) {

        if let temp = backupList {
            items = temp
        } else {
            conectivity = true
            errorService = nil
        }

    }

    func conectivityError() {

        if let temp = backupList {
            items = temp
        } else {
            conectivity = true
            errorService = nil
        }
    }
}

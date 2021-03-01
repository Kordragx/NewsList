//
//  NewsViewModel.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import Foundation

class NewsViewModel : NSObject, NewsServiceProtocol {

    let conditions: [(NewsListItemViewModel) -> Bool] = [
        {!$0.title.isEmpty},
        {!$0.url.isEmpty},
    ]

    private(set) var items: [NewsListItemViewModel]! {
        didSet {
            self.bindNewsViewModelToController()
        }
    }

    var errorService: Error? {
        didSet { self.showBackup() }
    }

    var conectivity: Bool = false {
        didSet { self.showBackup() }
    }

    var deletedNews: [String] = []
    var bindNewsViewModelToController : (() -> ()) = {}

    var showBackup : (() -> ()) = {}
    var backupList: [NewsListItemViewModel]!

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

        var filter = news.hits.map(NewsListItemViewModel.init)
        filter = filter.filter({ !deletedNews.contains($0.id) })
        filter = filter.filter {
          story in
          conditions.reduce(true) { $0 && $1(story) }
       }


        backupList = filter
        items = filter
    }


    func serviceError(error: Error) {
        errorService = error

    }


    func conectivityError() {
        conectivity = true
        self.errorService = nil

        if !backupList.isEmpty {
            items = backupList
        }


    }


}

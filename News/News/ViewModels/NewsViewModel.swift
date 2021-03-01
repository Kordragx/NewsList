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

    var deletedNews: [String] = []
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
        items = news.hits.map(NewsListItemViewModel.init)
        items = items.filter({ !deletedNews.contains($0.id) })
        items = items.filter {
          story in
          conditions.reduce(true) { $0 && $1(story) }
       }
    }


    func serviceError(error: Error) {
        
    }

}

//
//  NewsListItemViewModel.swift
//  News
//
//  Created by Daniel Nunez on 28-02-21.
//

import Foundation

struct NewsListItemViewModel: Equatable {
    let id: String
    let title: String
    let author: String
    let create_at: String
    let url: String
}

extension NewsListItemViewModel {

    init(news: NewsData) {
        self.id = news.objectID
        self.title = news.storyTitle ?? news.title ?? ""
        self.author = news.author
        self.url = news.storyURL ?? news.url ?? ""


        if let dateCreated = dateFormatter.date(from: news.createdAt) {
            let (day, hour, _) = Date().localDate() - dateCreated
            if day! >= 1 {
                self.create_at = "Ayer"
            } else if hour! >=  1 {
                self.create_at = "\(hour!)h"
            } else {
                self.create_at = "Ahora"
            }
        } else {
            self.create_at = ""
        }
    }
}

// MARK: - Private

private let dateFormatter: DateFormatter = {

    let formatter = Foundation.DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    formatter.timeZone = TimeZone(abbreviation: "UTC")

    return formatter
}()

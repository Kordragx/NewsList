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
        id = news.objectID
        title = news.storyTitle ?? news.title ?? ""
        author = news.author
        url = news.storyURL ?? news.url ?? ""

        if let dateCreated = dateFormatter.date(from: news.createdAt) {
            let (day, hour, min) = Date() - dateCreated
            if day! >= 1 {
                create_at = NSLocalizedString("Ayer", comment: "")
            } else if hour! >= 1 {
                create_at = NSLocalizedString("Hora", comment: "")
                    .replacingOccurrences(of: "{t}", with: String(describing: hour!))
            } else if hour! <= 0, min! >= 1 {
                create_at = NSLocalizedString("Min", comment: "")
                    .replacingOccurrences(of: "{t}", with: String(describing: min!))
            } else {
                create_at = NSLocalizedString("Ahora", comment: "")
            }
        } else {
            create_at = ""
        }
    }
}

// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = Foundation.DateFormatter()

    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    return formatter
}()

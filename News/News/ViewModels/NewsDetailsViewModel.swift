//
//  NewsDetailsViewModel.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import Foundation

protocol NewsDetailsViewModelOutput {
    var url: String { get }
}

protocol NewsDetailsViewModel: NewsDetailsViewModelOutput {}

final class DefaultMovieDetailsViewModel: NewsDetailsViewModel {
    // MARK: - OUTPUT

    let url: String

    init(url: String) {
        self.url = url
    }
}

//
//  NewsItemListCell.swift
//  News
//
//  Created by Daniel Nunez on 28-02-21.
//

import UIKit

final class NewsItemListCell: UITableViewCell {
    static let reuseIdentifier = String(describing: NewsItemListCell.self)

    static let height = CGFloat(70)

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var createAt: UILabel!

    private var viewModel: NewsListItemViewModel!

    func fill(with viewModel: NewsListItemViewModel) {
        self.viewModel = viewModel

        title.text = viewModel.title
        createAt.text = viewModel.author + " - " + viewModel.create_at
    }
}

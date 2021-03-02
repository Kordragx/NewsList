//
//  ViewController.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!

    private var newsViewModel: NewsViewModel!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action:
            #selector(ViewController.handleRefresh(_:)),
            for: UIControl.Event.valueChanged
        )
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        attempFetchNews()
    }

    override func viewWillAppear(_: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setup() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(
            UINib(nibName: NewsItemListCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: NewsItemListCell.reuseIdentifier
        )

        newsTableView.estimatedRowHeight = NewsItemListCell.height
        newsTableView.rowHeight = UITableView.automaticDimension

        newsTableView.addSubview(refreshControl)
    }

    func attempFetchNews() {
        newsViewModel = NewsViewModel()
        refreshControl.beginRefreshing()

        newsViewModel.bindNewsViewModelToController = {
            self.lblMessage.isHidden = true
            self.newsTableView.isHidden = false
            self.refreshControl.endRefreshing()
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }

        if newsViewModel.conectivity {
            self.refreshControl.endRefreshing()
            lblMessage.isHidden = false
        }
    }
}

// MARK: - extension - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return newsViewModel.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsItemListCell.reuseIdentifier,
            for: indexPath
        ) as? NewsItemListCell else {
            assertionFailure(
                "Cannot dequeue reusable cell \(NewsItemListCell.self) with reuseIdentifier: \(NewsItemListCell.reuseIdentifier)"
            )
            return UITableViewCell()
        }

        cell.fill(with: newsViewModel.items[indexPath.row])

        return cell
    }
}

// MARK: - extension - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVM = DefaultMovieDetailsViewModel(url: newsViewModel.items[indexPath.row].url)
        let vc = NewsDetailController.create(with: detailVM)
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            newsViewModel.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - extension - handleRefresh

extension ViewController {
    @objc func handleRefresh(_: UIRefreshControl) {
        newsViewModel.conectivity = false
        newsViewModel.callService()
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
        }
    }
}

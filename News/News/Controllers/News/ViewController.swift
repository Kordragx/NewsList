//
//  ViewController.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    private var newsViewModel : NewsViewModel!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        callToViewModelForUIUpdate()

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setup() {

        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(UINib.init(nibName: NewsItemListCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: NewsItemListCell.reuseIdentifier)

        newsTableView.estimatedRowHeight = NewsItemListCell.height
        newsTableView.rowHeight = UITableView.automaticDimension

        self.newsTableView.addSubview(refreshControl)
        refreshControl.beginRefreshing()
    }

    func callToViewModelForUIUpdate(){

        self.newsViewModel =  NewsViewModel()
        self.newsViewModel.bindNewsViewModelToController = {
            self.updateDataSource()
        }
    }

    func updateDataSource(){
        refreshControl.endRefreshing()
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
        }
    }

}

// MARK: - extension - UITableViewDataSource
extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsItemListCell.reuseIdentifier,
                                                       for: indexPath) as? NewsItemListCell else {
            assertionFailure("Cannot dequeue reusable cell \(NewsItemListCell.self) with reuseIdentifier: \(NewsItemListCell.reuseIdentifier)")
            return UITableViewCell()
        }
        

        cell.fill(with: newsViewModel.items[indexPath.row])


        return cell
    }


}

// MARK: - extension - UITableViewDelegate
extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailVM = DefaultMovieDetailsViewModel(url: newsViewModel.items[indexPath.row].url)
            let vc = NewsDetailController.create(with: detailVM)
            navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            newsViewModel.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

// MARK: - extension - handleRefresh
extension ViewController {

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        newsViewModel.callService()
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
        }
    }
}


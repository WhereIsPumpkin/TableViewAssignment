//
//  ViewController.swift
//  UITableViewAssignment
//
//  Created by Saba Gogrichiani on 28.10.23.
//

import UIKit

struct Album {
    let name: String
    let artist: String
    let image: UIImage
}

class MainViewController: UIViewController {
    private var albums: [Album] = [
        Album(name: "Disorder", artist: "Joy Division", image: UIImage(named: "Disorder") ?? UIImage()),
        Album(name: "OK Computer", artist: "Radiohead", image: UIImage(named: "Ok Computer") ?? UIImage()),
        Album(name: "Plastic Ono Band", artist: "John Lennon", image: UIImage(named: "Plastic Ono Band") ?? UIImage()),
        Album(name: "Selected Ambient Works 85-92", artist: "Aphex Twin", image: UIImage(named: "Selected Ambient Works 85-92") ?? UIImage()),
        Album(name: "The Eraser", artist: "Thom Yorke", image: UIImage(named: "The Eraser") ?? UIImage()),
        Album(name: "Sgt. Pepper's Lonely Hearts Club Band", artist: "The Beatles", image: UIImage(named: "SgtPepper") ?? UIImage())
    ]

    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewTable()
        setUpNavigationBar()
    }

    private func setUpViewTable() {
        initTableView()
        setTableViewConstraints()
    }

    private func initTableView() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }

    private func setTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albums[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = album.name
        cell.imageView?.image = album.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        let itemDetailsVC = ItemDetailsViewController()
        itemDetailsVC.album = album
        navigationController?.pushViewController(itemDetailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: AddNewItemDelegate {
    private func setUpNavigationBar() {
        navigationItem.title = "Favorite Albums"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }

    @objc private func addButtonTapped() {
        let addNewItemVC = AddNewItemToListViewController()
        addNewItemVC.delegate = self
        let navigationController = UINavigationController(rootViewController: addNewItemVC)
        present(navigationController, animated: true)
    }

    func addItemToList(name: String, image: UIImage?) {
        let newAlbum = Album(name: name, artist: "New Artist", image: image ?? UIImage())
        albums.append(newAlbum)
        tableView.reloadData()
    }
}

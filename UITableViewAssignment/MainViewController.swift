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

final class MainViewController: UIViewController {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            self.albums.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        albums.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}

extension MainViewController: AddNewItemDelegate {
    private func setUpNavigationBar() {
        navigationItem.title = "Favorite Albums"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(editButtonTapped))
    }

    @objc private func addButtonTapped() {
        let addNewItemVC = AddNewItemToListViewController()
        addNewItemVC.delegate = self
        let navigationController = UINavigationController(rootViewController: addNewItemVC)
        present(navigationController, animated: true)
    }
    
    @objc private func editButtonTapped() {
        if tableView.isEditing {
            tableView.isEditing = false
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(editButtonTapped))
        } else {
            tableView.isEditing = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(editButtonTapped))
        }
    }

    func addItemToList(name: String, image: UIImage?) {
        let newAlbum = Album(name: name, artist: "New Artist", image: image ?? UIImage())
        albums.append(newAlbum)
        tableView.reloadData()
    }
}

//
//  FeedViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 16/04/2022.
//

import UIKit

final class FeedViewController: UIViewController {
    
    // MARK: - Properties
    private let feedTableView: UITableView = {
        let table = UITableView()
        table.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        return table
    }()
    
    private let unfocusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.opacity = 0.5
        view.layer.addSublayer(layer)
        view.layer.opacity = 1
        return UIView()
    }()
    
    private let sideMenu = SideMenuView(frame: CGRect(x: -UIScreen.main.bounds.width, y: -100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*2))

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupTableView()
        setupNavBar()
        setupSideMenu()
    }

    // MARK: - Set up
    private func setupSubViews() {
        view.addSubview(feedTableView)
    }
    
    private func setupNavBar() {
        title = "Skaters Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        let image = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapProfileImage))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTableView.frame = view.bounds
        unfocusView.frame = view.bounds
    }
    
    private func setupTableView() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
    
    func setupSideMenu() {
        unfocusView.isUserInteractionEnabled = true
        unfocusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeave)))
    }
    
    // MARK: - Network Manager calls
    
    
    
    // MARK: - Functions
    
    //show side menu
    @objc func didTapProfileImage() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(unfocusView)
        unfocusView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.addSubview(sideMenu)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.sideMenu.transform = CGAffineTransform(rotationAngle: 0.01)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self.sideMenu.transform = self.sideMenu.transform.translatedBy(x: 250, y: 0)
            }
        }
    }
    
    //hide side menu
    @objc func didTapLeave() {
        navigationController?.navigationBar.isHidden = false
        unfocusView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.sideMenu.transform = CGAffineTransform(translationX: -250, y: 0)
        } completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self.sideMenu.transform = self.sideMenu.transform.rotated(by: -0.01)
            }
        }
    }
    
    
    

}
// MARK: - Extensions
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier) as? FeedTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}

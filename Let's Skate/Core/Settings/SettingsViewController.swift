//
//  SettingsViewController.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 21/04/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    // tableView
    private let settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(SettingTableViewCell.self)
        tableView.backgroundColor = UIColor().lightMainColor()
        return tableView
    }()

    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupTableView()
    }
    
    // MARK: - Set up
    
    // adding SubViews
    private func setupSubViews() {
        view.addSubview(settingTableView)
    }
    
    // TableView delegate / data source
    private func setupTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        settingTableView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height-100)
    }
    // MARK: - Functions
    
    
}
// MARK: - Extensions
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingViewModel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeResuableCell(for: SettingTableViewCell.self, for: indexPath)
        SettingViewModel.allCases.forEach { model in
            if indexPath.row == model.row {
                cell.configure(with: model.iconName, title: model.title)
                cell.backgroundColor = UIColor().lightMainColor()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

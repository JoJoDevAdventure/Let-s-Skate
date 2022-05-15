//
//  CommentTableViewCell.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 13/05/2022.
//

import UIKit
import SDWebImage

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CommentTableViewCell"
    
    private let stockView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor().lightMainColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let profileImageView = ProfileRoundedImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    private let nicknameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let datePostedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupSubViews()
        setupConstraints()
        backgroundColor = UIColor().DarkMainColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    private func setupCell() {
        stockView.layer.cornerRadius = 10
    }
    
    private func setupSubViews() {
        addSubview(stockView)
        stockView.addSubview(profileImageView)
        stockView.addSubview(nicknameLabel)
        stockView.addSubview(commentLabel)
        stockView.addSubview(datePostedLabel)
        
    }
    
    private func setupConstraints() {
        profileImageView.backgroundColor = .gray
    
        let constraints = [
            //content view
            stockView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7),
            stockView.rightAnchor.constraint(equalTo: rightAnchor, constant: -7),
            stockView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stockView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            // profile image
            profileImageView.leftAnchor.constraint(equalTo: stockView.leftAnchor, constant: 5),
            profileImageView.topAnchor.constraint(equalTo: stockView.topAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // nickname
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nicknameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            //date label
            datePostedLabel.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
            datePostedLabel.trailingAnchor.constraint(equalTo: stockView.trailingAnchor, constant: -10),
            
            //comment
            commentLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: stockView.trailingAnchor, constant: -10),
            commentLabel.bottomAnchor.constraint(equalTo: stockView.bottomAnchor, constant:  -15),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Functions
    
    func configure(comment: Comment) {
        nicknameLabel.text = comment.user?.nickname
        commentLabel.text = comment.comment
        let timestamp = getReadableDate(timeStamp: Double(comment.date.seconds))
        datePostedLabel.text = timestamp
        guard let profileImageUrl = comment.user?.profileImageUrl else { return }
        profileImageView.sd_setImage(with: URL(string: profileImageUrl))
    }
    
    func getReadableDate(timeStamp: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }

    func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
    
    
    // MARK: - Extensions
}

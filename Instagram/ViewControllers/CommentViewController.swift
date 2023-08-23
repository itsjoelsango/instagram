//
//  CommentViewController.swift
//  Instagram
//
//  Created by Jo Michael on 8/8/23.
//

import UIKit
import ParseCore

private let reuseIdentifier = "CellIdentifier"

class CommentViewController: UIViewController {
    
    private var commentTableView: UITableView!
    private var editCommentTextField: UITextField!
    private var submitCommentButton: UIButton!
    
    // setup data
    private let post: PFObject
    lazy var comments = post["comments"] as? [PFObject] ?? []
    
    
    // configure timer
    private var timer: Timer?
   
    init(post: PFObject) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Comments"
        navigationSettings()
        setupViews()
        updateButtonState()
        fetchCommentsEverySecond(self.post)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.fetchCommentsEverySecond(self!.post)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ViewDidDisappear")
        self.editCommentTextField.removeFromSuperview()
        print("View was removed")
        dismiss(animated: true) {
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    private func navigationSettings() {
        let customButton = UIButton(type: .custom)
        customButton.setImage(UIImage(systemName: "paperplane",
                                      withConfiguration: UIImage.SymbolConfiguration(textStyle: .title2)), for: .normal)
        customButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        customButton.addTarget(self, action: #selector(sharedButtonTapped), for: .touchUpInside)
        
        let customBarButtonitem = UIBarButtonItem(customView: customButton)
        navigationItem.rightBarButtonItem = customBarButtonitem
    }
    
    @objc private func sharedButtonTapped() {
        print("shared button clicked!")
    }
    
    private func fetchCommentsEverySecond(_ post: PFObject) {
        let messageQuery = PFQuery(className: "Comments")
        messageQuery.whereKey("post", equalTo: post)
        messageQuery.includeKeys(["author", "comments", "comments.author"])
        messageQuery.addAscendingOrder("createdAt")
        messageQuery.findObjectsInBackground { (comments, error) in
            if let comments = comments {
                DispatchQueue.main.async {
                    print("Fetch comments!")
                    self.comments = comments
                    self.commentTableView.reloadData()
                }
            } else if let error = error {
                print("Error fetching comments: \(error.localizedDescription)")
            }
            
        }
    }
    
    @objc private func PostCommentButtonTapped() {
        let text = editCommentTextField.text
        print("post button clicked")
        editCommentTextField.resignFirstResponder()
        editCommentTextField.text = nil
        submitCommentButton.isEnabled.toggle()
        submitCommentButton.backgroundColor = .gray
        
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = post
        comment["author"] = PFUser.current()!
        
        post.add(comment, forKey: "comments")
        post.saveInBackground { (success, error) in
            if success {
                print("comment saved")
                DispatchQueue.main.async {
                    self.commentTableView.reloadData()
                }
            } else {
                print("error while trying to save comment")
            }
        }
        
        self.commentTableView.reloadData()
        
    }
    
    @objc private func dismissKeyboard() {
        self.editCommentTextField.isUserInteractionEnabled = true
        self.editCommentTextField.resignFirstResponder()
    }
    
    private func setupViews() {
        
        // configure tableview
        commentTableView = UITableView()
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        commentTableView.delegate = self
        commentTableView.dataSource = self
//        commentTableView.backgroundColor = .systemTeal
        commentTableView.showsVerticalScrollIndicator = false
        commentTableView.separatorStyle = .none
        commentTableView.allowsSelection = false
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.keyboardDismissMode = .onDrag
        self.view.addSubview(commentTableView)
        
        editCommentTextField = UITextField()
        editCommentTextField.delegate = self
        editCommentTextField.placeholder = "Add a comment"
        editCommentTextField.layer.borderColor = UIColor.systemGray.cgColor
        editCommentTextField.layer.borderWidth = 1.0
        editCommentTextField.layer.cornerRadius = 22.0
        editCommentTextField.translatesAutoresizingMaskIntoConstraints = false
        editCommentTextField.autocorrectionType = .default
        editCommentTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        editCommentTextField.leftViewMode = .always
        editCommentTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        editCommentTextField.rightViewMode = .always
        self.view.addSubview(editCommentTextField)
        
        submitCommentButton = UIButton()
        submitCommentButton.setTitle("Post", for: .normal)
        submitCommentButton.translatesAutoresizingMaskIntoConstraints = false
        submitCommentButton.isEnabled = false
        submitCommentButton.layer.cornerRadius = 16
        submitCommentButton.layer.masksToBounds = true
        submitCommentButton.addTarget(self, action: #selector(PostCommentButtonTapped), for: .touchUpInside)
        self.view.addSubview(submitCommentButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            commentTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            commentTableView.bottomAnchor.constraint(greaterThanOrEqualTo: self.editCommentTextField.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            editCommentTextField.heightAnchor.constraint(equalToConstant: 44),
            editCommentTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            editCommentTextField.trailingAnchor.constraint(equalTo: submitCommentButton.leadingAnchor, constant: -8),
            editCommentTextField.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            submitCommentButton.heightAnchor.constraint(equalToConstant: 40),
            submitCommentButton.widthAnchor.constraint(equalToConstant: 60),
            submitCommentButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            submitCommentButton.centerYAnchor.constraint(equalTo: editCommentTextField.centerYAnchor)
        ])
    }
    
    
}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CommentTableViewCell {
            let comment = comments[indexPath.row]
            cell.commentLabel.text = comment["text"] as? String
            
            let author = comment["author"] as! PFUser
            cell.authorLabel.text = author.username
            return cell
        }
        return UITableViewCell()
    }
}

extension CommentViewController: UITableViewDelegate {

}

//MARK: Extension for settings texfield behavior
extension CommentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        updateButtonState(with: newText)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateButtonState()
    }
    
    func updateButtonState(with text: String? = nil) {
        let isEmpty = text?.isEmpty ?? editCommentTextField.text?.isEmpty ?? true
        submitCommentButton.isEnabled = !isEmpty
        submitCommentButton.backgroundColor = submitCommentButton.isEnabled ? .systemMint : .systemGray
    }
}

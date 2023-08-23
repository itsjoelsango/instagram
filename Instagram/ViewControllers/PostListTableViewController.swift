//
//  PostListTableViewController.swift
//  Instagram
//
//  Created by Jo Michael on 7/19/23.
//

import UIKit
import ParseCore
import AlamofireImage

private let registerCell = "Cell"

class PostListTableViewController: UIViewController {
    
    private var posts: [PFObject] = []
    private var currentPost: PFObject!
    private var querySkip = 0
    private let queryLimit = 10

    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var lauchCameraBarButton: UIBarButtonItem!
    
    var refreshControl: UIRefreshControl!
    
    weak var delegate: PassPostDataDelegate?
    weak var postCellDelegate: PostListViewCellDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewWillAppear trigger")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "PostListViewCell", bundle: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        
        let loadingView = UIActivityIndicatorView(style: .medium)
        loadingView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        postTableView.tableFooterView = loadingView
        
        lauchCameraBarButton.target = self
        lauchCameraBarButton.action = #selector(presentCameraViewController)
        
        postTableView.dataSource = self
        postTableView.delegate = self
        postTableView.refreshControl = refreshControl
        postTableView.register(nib, forCellReuseIdentifier: registerCell)
        postTableView.allowsSelection = false
        postTableView.showsVerticalScrollIndicator = false
        
        NotificationCenter.default.addObserver(forName: Notification.Name("likeButtonTapped"),
                                               object: nil,
                                               queue: .main) { notification in
            self.likeButtonTapped(notification)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(commentLabelTapped),
                                               name: NSNotification.Name("commentTapped"),
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchInitialPosts()
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.fetchInitialPosts()
        }
    }
    
    @objc private func presentCameraViewController() {
        let cameraVC = CameraViewController()
        let navVC = UINavigationController(rootViewController: cameraVC)
        present(navVC, animated: true)
        
    }
    
    private func fetchInitialPosts() {
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.addDescendingOrder("createdAt")
        query.limit = self.queryLimit
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.postTableView.reloadData()
            } else if let error = error {
                print(error.localizedDescription)
                fatalError()
            }
        }
    }
    
    @objc func pulledToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
            self.fetchInitialPosts()
        }
    }
    
    @objc func commentLabelTapped(_ notification: Notification) {
        guard let cell = notification.object as? PostListViewCell,
                let indexPath = postTableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
        print("Cell: \(cell) and index: \(indexPath.row)")
        presentModelViewController(with: post)
    }
    
    @objc private func likeButtonTapped(_ notification: Notification) {
        guard let cell = notification.object as? PostListViewCell,
                let indexPath = postTableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
    }
    
    private func presentModelViewController(with post: PFObject) {
        let vc = CommentViewController(post: post)
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
}

extension PostListTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let comments = post["comments"] as? [PFObject] ?? []
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: registerCell, for: indexPath) as? PostListViewCell else { return UITableViewCell() }

        let user = post["author"] as! PFUser
        cell.authorLabel.text = user.username
        
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["media"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        ImageResponseSerializer.addAcceptableImageContentTypes(["application/octet-stream"])
        
        cell.postImageView.af.setImage(withURL: url)
        
        if let createdTime = post.createdAt {
            let date = createdTime.dayAndTimeText
            cell.createdDateLabel.text = date
        }
        
        let currentUser = PFUser.current()
        cell.userCommentedLabel.text = currentUser?.username
        
        cell.numberOfCommentsOnaPost.text = comments.count <= 0 ? "" : "View all \(comments.count) comments"
        
//        cell.isLiked = post
        cell.updateLikeButtonAppearance()
        cell.delegate = self
        
        let numberOfLikes = post["likesCount"] as! Int
        cell.counterLabel.text = numberOfLikes <= 0 ? "" : "\(numberOfLikes) likes"

        return cell
    }
    
    
}

extension PostListTableViewController: UITableViewDelegate {
    
}

extension PostListTableViewController: PostListViewCellDelegate {
    func didLikeButtonClicked(for cell: PostListViewCell) {
        
    }

}



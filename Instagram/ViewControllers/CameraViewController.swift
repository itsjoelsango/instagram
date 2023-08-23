//
//  CameraViewController.swift
//  Instagram
//
//  Created by Jo Michael on 8/5/23.
//

import UIKit
import ParseCore
import AlamofireImage
import PhotosUI

class CameraViewController: UIViewController {
    private var mediaImageView: UIImageView!
    private var captionTextField: UITextField!
    private var submitButton: UIButton!

    private lazy var cameraPicker: UIBarButtonItem = {
        let cameraBarButtonItem = UIBarButtonItem()
        cameraBarButtonItem.image = UIImage(systemName: "camera.viewfinder")
        cameraBarButtonItem.target = self
        cameraBarButtonItem.action = #selector(imageCameraPicker)
        return cameraBarButtonItem
    }()
    
    private lazy var libraryPicker: UIBarButtonItem = {
        let libraryBarButtonItem = UIBarButtonItem()
        libraryBarButtonItem.image = UIImage(systemName: "plus")
        libraryBarButtonItem.target = self
        libraryBarButtonItem.action = #selector(imageLibraryPicker)
        return libraryBarButtonItem
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraPicker.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        navigationItem.rightBarButtonItems = [libraryPicker, cameraPicker]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        updateButtonState()
        let gesturRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(gesturRecognizer)
        captionTextField.becomeFirstResponder()

    }
    
    private func setupViews() {
        self.view.backgroundColor = .systemBackground
        // configure the image view
        mediaImageView = UIImageView()
        mediaImageView.contentMode = .scaleAspectFit
        mediaImageView.image = UIImage(systemName: "photo")
        mediaImageView.tintColor = .systemGray2
        mediaImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mediaImageView)
        
        captionTextField = UITextField()
        captionTextField.delegate = self
        captionTextField.placeholder = "Add caption"
        captionTextField.layer.borderColor = UIColor.systemGray.cgColor
        captionTextField.layer.borderWidth = 1.0
        captionTextField.layer.cornerRadius = 22.0
        captionTextField.translatesAutoresizingMaskIntoConstraints = false
        captionTextField.autocorrectionType = .default
        captionTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        captionTextField.leftViewMode = .always
        captionTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        captionTextField.rightViewMode = .always
        self.view.addSubview(captionTextField)
        
        submitButton = UIButton()
        submitButton.setTitle("Submit", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.isEnabled = false
        submitButton.layer.cornerRadius = 16
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mediaImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
            mediaImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mediaImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            mediaImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            mediaImageView.bottomAnchor.constraint(equalTo: captionTextField.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            captionTextField.heightAnchor.constraint(equalToConstant: 44),
            captionTextField.leadingAnchor.constraint(equalTo: mediaImageView.leadingAnchor),
            captionTextField.trailingAnchor.constraint(equalTo: mediaImageView.trailingAnchor),
            captionTextField.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.leadingAnchor.constraint(equalTo: captionTextField.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: captionTextField.trailingAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
        ])
    }
    
    @objc private func imageLibraryPicker(_ sender: Any) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .any(of: [.images, .screenshots])
        configuration.preferredAssetRepresentationMode = .current
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    @objc private func imageCameraPicker(_ sender: Any) {
        let nextController = UIImagePickerController()
        nextController.delegate = self
        nextController.allowsEditing = true
        nextController.sourceType = .camera
        present(nextController, animated: true)
    }
    
    @objc private func submitAction(_ sender: UIButton) {
        let text = captionTextField.text
        captionTextField.resignFirstResponder()
        captionTextField.text = nil
        submitButton.isEnabled.toggle()
        submitButton.backgroundColor = .gray
        
        let post = Post()
        post.caption = text
        post.likesCount = 0
        post.author = PFUser.current()!
        
        let imageData = mediaImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post.media = file!
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saves!")
            } else {
                print("error: \(String(describing: error))")
            }
        }
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            let size = CGSize(width: 400, height: 400)
            let scaledImage = image.af.imageScaled(to: size)
            
            mediaImageView.image = scaledImage
            
            dismiss(animated: true, completion: nil)
        } else {
            print("image return nil value")
        }
   
    }
}

extension CameraViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        guard let result = results.first else {
            // Handle case when no results are selected
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            if let error = error {
                // Handle error loading image
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            if let image = image as? UIImage {
                let size = CGSize(width: 400, height: 400)
                let scaledImage = image.af.imageAspectScaled(toFill: size)
                
                DispatchQueue.main.async {
                    self.mediaImageView.image = scaledImage
                }
            }
        }
    }
}

extension CameraViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        captionTextField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboard() {
        self.captionTextField.isUserInteractionEnabled = true
        self.captionTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        updateButtonState(with: newText)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateButtonState()
    }
    
    func updateButtonState(with text: String? = nil) {
        let isEmpty = text?.isEmpty ?? captionTextField.text?.isEmpty ?? true
        submitButton.isEnabled = !isEmpty
        submitButton.backgroundColor = submitButton.isEnabled ? .systemMint : .systemGray
    }
    
}

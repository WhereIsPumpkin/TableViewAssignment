import UIKit

protocol AddNewItemDelegate {
    func addItemToList(name: String, image: UIImage?)
}

class AddNewItemToListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var uploadView = UIStackView()
    private let imagePicker = UIImagePickerController()
    private let albumNameInput = UITextField()
    private let uploadButton = UIButton()
    private let imageView = UIImageView()
    var delegate: AddNewItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUploadView()
        setupMainView()
        setUpNavigationBar()
    }
    
    func setupMainView(){
        view.backgroundColor = .systemBackground
        setupViewConstraints()
    }
    
    func setupUploadView() {
        initUploadView()
        setupUploadViewConstraints()
    }
    
    func initUploadView() {
        uploadView.axis = .vertical
        uploadView.alignment = .center
        uploadView.spacing = 20
        view.addSubview(uploadView)

        albumNameInput.placeholder = "Album Name"
        albumNameInput.backgroundColor = .white
        albumNameInput.borderStyle = .roundedRect
        albumNameInput.widthAnchor.constraint(equalToConstant: 250).isActive = true
        uploadView.addArrangedSubview(albumNameInput)

        uploadButton.setTitle("Upload Cover 📷", for: .normal)
        uploadButton.setTitleColor(.blue, for: .normal)
        uploadButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        
        uploadView.addArrangedSubview(uploadButton)
        
        // Add imageView to the stack view
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        uploadView.addArrangedSubview(imageView)
    }
    
    @objc func pickImage() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
    
        dismiss(animated: true, completion: nil)
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "Add New Album"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        guard let name = albumNameInput.text, !name.isEmpty, imageView.image != nil else {
            print("Both the album name and image must be provided.")
            return
        }
        delegate?.addItemToList(name: name, image: imageView.image)
        self.dismiss(animated: true, completion: nil)
    }

    func setupUploadViewConstraints() {
        uploadView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}



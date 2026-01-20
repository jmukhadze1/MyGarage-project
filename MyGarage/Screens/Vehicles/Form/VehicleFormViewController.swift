//
//  VehicleFormViewController.swift
//  MyGarage
//
//  Created by David on 20.01.26.
//

import UIKit
import FirebaseAuth
import TinyConstraints

final class VehicleFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let viewModel: VehicleFormViewModel
    var onFinish: (() -> Void)?

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let makeField = FormTextFieldView(title: "Make", placeholder: "")
    private let modelField = FormTextFieldView(title: "Model", placeholder: "")
    private let yearField = FormTextFieldView(title: "Year", placeholder: "", keyboard: .numberPad)
    private let mileageField = FormTextFieldView(title: "Current Mileage", placeholder: "", keyboard: .numberPad)

    private let photoPreviewImageView = UIImageView()
    private let choosePhotoButton = UIButton(type: .system)

    private var selectedImage: UIImage?
    private var existingImageURL: String?

    private let imageUploadService = ImageUploadService()

    init(viewModel: VehicleFormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.screenTitle

        setupNav()
        setupLayout()
        configurePhotoUI()
        fillInitialValues()
    }

    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .prominent,
            target: self,
            action: #selector(saveTapped)
        )
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.edgesToSuperview(usingSafeArea: true)

        contentStack.axis = .vertical
        contentStack.spacing = 16

        scrollView.addSubview(contentStack)

        contentStack.topToSuperview(offset: 16)
        contentStack.leftToSuperview(offset: 16)
        contentStack.rightToSuperview(offset: 16)
        contentStack.bottomToSuperview(offset: -16)

        contentStack.width(to: scrollView, offset: -32)

        contentStack.addArrangedSubview(makeField)
        contentStack.addArrangedSubview(modelField)
        contentStack.addArrangedSubview(yearField)
        contentStack.addArrangedSubview(mileageField)

        contentStack.addArrangedSubview(photoPreviewImageView)
        contentStack.addArrangedSubview(choosePhotoButton)
    }

    private func configurePhotoUI() {
        photoPreviewImageView.backgroundColor = UIColor.systemGray6
        photoPreviewImageView.clipsToBounds = true
        photoPreviewImageView.layer.cornerRadius = 12
        photoPreviewImageView.contentMode = .center
        photoPreviewImageView.tintColor = .systemGray3
        photoPreviewImageView.image = UIImage(systemName: "photo")

        photoPreviewImageView.height(190)

        choosePhotoButton.setTitle("Choose Photo", for: .normal)
        choosePhotoButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        choosePhotoButton.addTarget(self, action: #selector(choosePhotoTapped), for: .touchUpInside)
    }

    private func fillInitialValues() {
        let initial = viewModel.initialValues()
        makeField.text = initial.make
        modelField.text = initial.model
        yearField.text = initial.year
        mileageField.text = initial.mileage
        existingImageURL = initial.imageURL
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func choosePhotoTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)

        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        selectedImage = pickedImage

        photoPreviewImageView.contentMode = .scaleAspectFill
        photoPreviewImageView.tintColor = nil
        photoPreviewImageView.image = pickedImage
    }

    @objc private func saveTapped() {
        Task { @MainActor in
            do {
                let finalImageURL: String?

                if let imageToUpload = selectedImage {
                    guard let userId = Auth.auth().currentUser?.uid else {
                        throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
                    }

                    finalImageURL = try await imageUploadService.uploadVehicleImage(
                        image: imageToUpload,
                        userId: userId
                    )
                } else {
                    finalImageURL = existingImageURL
                }

                try await viewModel.save(
                    make: makeField.text,
                    model: modelField.text,
                    yearText: yearField.text,
                    mileageText: mileageField.text,
                    imageURL: finalImageURL
                )

                dismiss(animated: true) { [weak self] in
                    self?.onFinish?()
                }

            } catch {
                showError(message: error.localizedDescription)
            }
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

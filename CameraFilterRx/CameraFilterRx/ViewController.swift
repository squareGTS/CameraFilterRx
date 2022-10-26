//
//  ViewController.swift
//  CameraFilterRx
//
//  Created by Maxim Bekmetov on 25.10.2022.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else { fatalError("Segue destination is not found")
        }
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
    }

    @IBAction func applyFilterButtonPressed() {
        guard let sourceImage = self.photoImageView.image else { return }

//        FilterSevice().applyFilter(to: sourceImage) { filterImage in
//
//            DispatchQueue.main.async {
//                self.photoImageView.image = filterImage
//            }
//        }

        FilterSevice().applyFilter(to: sourceImage).subscribe(onNext: {
            filteredImage in

            DispatchQueue.main.async {
                self.photoImageView.image = filteredImage
            }
        }).disposed(by: disposeBag)
    }

    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }
}

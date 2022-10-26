//
//  FilterSevice.swift
//  CameraFilterRx
//
//  Created by Maxim Bekmetov on 26.10.2022.
//

import UIKit
import CoreImage
import RxSwift

class FilterSevice {
    private var context: CIContext

    init() {
        self.context = CIContext()
    }

    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in

            self.applyFilter(to: inputImage) { filterImage in
                observer.onNext(filterImage)
            }
            return Disposables.create()
        }
    }

   private func applyFilter(to inputImage: UIImage, completion: @escaping((UIImage)->())) {
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(4.0, forKey: kCIInputWidthKey)

        if let sourceImage = CIImage(image: inputImage) {

            filter.setValue(sourceImage, forKey: kCIInputImageKey)

            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
}

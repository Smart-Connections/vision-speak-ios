//
//  MLManager.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import CoreML
import Vision

protocol ImageAnalysisModelDelegate: AnyObject {
    func didRecieve(_ observation: VNClassificationObservation)
}

class ImageAnalysisModel: NSObject {

    weak var delegate: ImageAnalysisModelDelegate?

    func performRequet(with imageBuffer: CVImageBuffer) {
        guard let model = try? VNCoreMLModel(for: YOLOv3Tiny(configuration: .init()).model)
        else { return }
        
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async(group: group,  execute: {
            let request = VNCoreMLRequest(model: model) { request, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                guard let results = request.results as? [VNClassificationObservation],
                      let firstObservation = results.first
                else { return }
                print(firstObservation.identifier)
                self.delegate?.didRecieve(firstObservation)
            }
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer)
            try? imageRequestHandler.perform([request])
        })
    }
}

//
//  MLManager.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import CoreML
import Vision

protocol ImageAnalysisModelDelegate: AnyObject {
    func didRecieve(_ results: [VNRecognizedObjectObservation])
}

class ImageAnalysisModel: NSObject {

    weak var delegate: ImageAnalysisModelDelegate?

    func performRequest(with imageBuffer: CVImageBuffer) {
        guard let model = try? VNCoreMLModel(for: YOLOv3Tiny(configuration: .init()).model)
        else { return }

        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async {
            let request = VNCoreMLRequest(model: model) { (request, error) in

                if let error = error {
                    debugPrint("Failed to perform request: \(error)")
                    return
                }

                guard let results = request.results else {
                    debugPrint("No results")
                    return
                }
                debugPrint("detect object results: \(results)")
                self.delegate?.didRecieve(results as? [VNRecognizedObjectObservation] ?? [])
            }
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, options: [:])
            do {
                try imageRequestHandler.perform([request])
            } catch {
                debugPrint("Failed to perform image request: \(error)")
            }
        }
    }
}

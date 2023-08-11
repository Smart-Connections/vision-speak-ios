//
//  MLManager.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import CoreML
import Vision

protocol Resnet50ModelManagerDelegate: AnyObject {
    func didRecieve(_ observation: VNClassificationObservation)
}

class Resnet50ModelManager: NSObject {

    weak var delegate: Resnet50ModelManagerDelegate?

    func performRequet(with imageBuffer: CVImageBuffer) {
        // 機械学習モデル
        guard let model = try? VNCoreMLModel(for: Resnet50(configuration: .init()).model)
        else { return }
        
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async(group: group,  execute: {
            // フレーム内で機械学習モデルを使用した画像分析リクエスト
            let request = VNCoreMLRequest(model: model) { request, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                guard let results = request.results as? [VNClassificationObservation],
                      let firstObservation = results.first
                else { return }

                self.delegate?.didRecieve(firstObservation)
            }

            // imageRequestHanderにimageBufferをセット
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer)
            // imageRequestHandlerにrequestをセットし、実行
            try? imageRequestHandler.perform([request])
        })
    }
}

//
//  VideoCapture.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import AVFoundation

protocol VideoCaptureDelegate: AnyObject {
    func didSet(_ previewLayer: AVCaptureVideoPreviewLayer)
    func didCaptureFrame(from imageBuffer: CVImageBuffer)
}

class VideoCapture: NSObject {

    weak var delegate: VideoCaptureDelegate?

    // AVの出入力のキャプチャを管理するセッションオブジェクト
    private let captureSession = AVCaptureSession()

    // ビデオを記録し、処理を行うためにビデオフレームへのアクセスを提供するoutput
    private let videoOutput = AVCaptureVideoDataOutput()

    // カメラセットアップとフレームキャプチャを処理する為のDispathQueue
    private let sessionQueue = DispatchQueue(label: "object-detection-queue")

    func startCapturing() {
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async(group: group,  execute: {
            // capture deviceのメディアタイプを決め、
            // 何からインプットするかを決める
            guard let captureDevice = AVCaptureDevice.default(for: .video),
                  let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
            else { return }

            // captureSessionにdeviceInputを入力値として入れる
            self.captureSession.addInput(deviceInput)

            // キャプチャセッションの開始
            self.captureSession.startRunning()

            // ビデオフレームの更新ごとに呼ばれるデリゲートをセット
            self.videoOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)

            // captureSessionから出力を取得するためにdataOutputをセット
            self.captureSession.addOutput(self.videoOutput)

            // captureSessionをUIに描画するためにPreviewLayerにsessionを追加
            let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.delegate?.didSet(previewLayer)
        })
    }

    func stopCapturing() {
        // キャプチャセッションの終了
        captureSession.stopRunning()
    }
}


extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        Thread.sleep(forTimeInterval: 0.2)

        // フレームからImageBufferに変換
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else { return }

        delegate?.didCaptureFrame(from: imageBuffer)
    }
}

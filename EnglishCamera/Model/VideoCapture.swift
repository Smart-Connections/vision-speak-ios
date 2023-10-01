//
//  VideoCapture.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import AVFoundation
import UIKit

protocol VideoCaptureDelegate: AnyObject {
    func didSet(_ previewLayer: AVCaptureVideoPreviewLayer)
    func didCaptureFrame(from imageBuffer: CVImageBuffer)
    func didTakePicture(_ data: Data)
}

class VideoCapture: NSObject, AVCapturePhotoCaptureDelegate {

    weak var delegate: VideoCaptureDelegate?

    private let captureSession = AVCaptureSession()

    private let videoOutput = AVCaptureVideoDataOutput()
    
    private let photoOutput = AVCapturePhotoOutput()

    private let sessionQueue = DispatchQueue(label: "object-detection-queue")

    func startCapturing() {
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async(group: group,  execute: {

            guard let captureDevice = AVCaptureDevice.default(for: .video),
                  let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
            else { return }
            
            self.captureSession.addInput(deviceInput)
            self.captureSession.startRunning()
            self.videoOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
            if self.captureSession.canAddOutput(self.videoOutput) {
                self.captureSession.addOutput(self.videoOutput)
                if let connection = self.videoOutput.connection(with: .video) {
                    connection.videoOrientation = .portrait // Change as needed
                }
            }
            self.captureSession.addOutput(self.photoOutput)

            let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            previewLayer.connection?.videoOrientation = .portrait
            self.delegate?.didSet(previewLayer)
        })
    }

    func stopCapturing() {
        captureSession.stopRunning()
    }
    
    func takePicture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.maxPhotoDimensions = CMVideoDimensions()
        self.photoOutput.capturePhoto(with: settings, delegate: self)
    }
}


extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        Thread.sleep(forTimeInterval: 1)
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else { return }
        delegate?.didCaptureFrame(from: imageBuffer)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            delegate?.didTakePicture(imageData)
        }
    }
    
    func  photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        AudioServicesDisposeSystemSoundID(1108)
    }
}

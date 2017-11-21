//
//  View2.swift
//  PwP2
//
//  Created by Yahya Azami on 2017-11-20.
//  Copyright © 2017 yazami. All rights reserved.
//

import UIKit
import AVFoundation

class View2: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var videoFileOutput:AVCaptureMovieFileOutput?
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    var notStreaming = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice() //configuring the necessare capture devices
        setupInputOutput() //creating inputs using the capture devices
        setupPreview() 
        startRunningCaptureSession()
    }
    
    func setupCaptureSession()
    {
        //change this to vga later or something for video
        captureSession.sessionPreset = AVCaptureSession.Preset.high
    }
    
    func setupDevice()
    {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        //finding device properties
        let devices = deviceDiscoverySession.devices
        
        //checking which camera we're using
        for device in devices
        {
            if device.position == AVCaptureDevice.Position.back
            {
                backCamera = device
            }
            else if device.position == AVCaptureDevice.Position.front
            {
                frontCamera = device
            }
        }

        currentCamera = backCamera
    }
    
    func setupInputOutput()
    {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            videoFileOutput = AVCaptureMovieFileOutput()
            captureSession.addOutput(videoFileOutput!)
            
            
            //REMOVE
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        }
        catch
        {
            print(error)
        }
    }
    
    func setupPreview()
    {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession()
    {
        captureSession.startRunning()
    }
    
    
    //Pressing the button should start the stream.
    @IBAction func cameraButton_TouchUpInside(_ sender: UIButton) {
        
        //START SENDING DATA HERE
        if(notStreaming)
        {
            notStreaming = false
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: { () -> Void in
                self.recordButtonOutlet.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: nil)
        }
        
        //STOP SENDING DATA HERE
        else
        {
            notStreaming = true
            UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: { () -> Void in
                self.recordButtonOutlet.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
            
            recordButtonOutlet.layer.removeAllAnimations()
        }
    }
}



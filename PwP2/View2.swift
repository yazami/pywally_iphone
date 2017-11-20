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
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupDevice() //configuring the necessare capture devices
        setupInputOutput() //creating inputs using the capture devices
        setupPreview() //configuring an output object to process captured images
        startRunningCaptureSession()
        
    }
    
    func setupCaptureSession()
    {
        //change this to vga later or something for video
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
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
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
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
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButton_TouchUpInside(_ sender: UIButton) {
        
        
        
        
    }
    
    
    

    
    
    
    
    
    
    
    
    
    
}

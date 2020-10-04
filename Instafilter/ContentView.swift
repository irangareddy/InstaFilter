//
//  ContentView.swift
//  Instafilter
//
//  Created by RANGA REDDY NUKALA on 02/10/20.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           print("Save finished!")
       }
}

struct ContentView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var imageTobeSaved: UIImage?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button(action: {
                showingImagePicker = true
            }, label: {
                HStack {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 24, weight: .heavy))
                    Text("Load Image")
                }.foregroundColor(.purple)
            })
            Button(action: {
                saveImage(image: imageTobeSaved!)
            }, label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 24, weight: .heavy))
                    Text("Save Image")
                }.foregroundColor(.green)
            })
        }.sheet(isPresented: $showingImagePicker,onDismiss: loadImage, content: {
            ImagePicker(image: $inputImage)
        })
    }
    
    func saveImage(image: UIImage) {
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: image)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.cmykHalftone()
        
        currentFilter.inputImage = beginImage
//        currentFilter.
        
        
        
//        currentFilter.
        currentFilter.center = CGPoint(x: inputImage.size.width/2, y: inputImage.size.height/2)
        
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            imageTobeSaved = uiImage
            image = Image(uiImage: uiImage)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

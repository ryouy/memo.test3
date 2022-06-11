//
//  ContentView.swift
//  memo.test3
//
//  Created by Ryo  on 2022/05/17.
//

import SwiftUI
import Foundation
import Combine
import UIKit
import WaveAnimationView



struct ContentView: View {
    
    @State var text: String = ""
    @State private var rect: CGRect = .zero
    @State var uiImage: UIImage? = nil
    @State private var showActivityView: Bool = false
    @State var count = 0
    @State var timerLoop :Timer?
    @State var timer :Timer?
    
    @State var textArray=["1","2","3","4"]
    
    @State var timerFlg=true
    @State private var flag = false
    @State private var isDone = false
    @State private var isRotatedSq2 = true
    
    @State private var randomwavescale = 0
    // @State private var wavescale = 0
    @State private var wavescale = 0
    private let maxTextLength = 10
    
    
    
    
    
    
    
    
    var body: some View {
        
        
        
        let url = fileSave(fileName: "wavePDF.pdf")
        VStack{
            ZStack (alignment: .top){
                Image("blue")
                    .resizable()
                    .scaledToFit()
                    .zIndex(1)
                
                //can't use list due to ios version
                /*                List {
                 Section("some") {
                 ForEach(textArray, id: \.self) { array in
                 Text(array)
                 }
                 .listRowSeparator(.hidden)
                 }
                 }
                 */
                
                Form {
                    ForEach(textArray, id:\.self) { array in
                        Text(array)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 5.0))
                    }
                    
                }.offset(x: 0,y: 100)
                
                    .onTapGesture {
                        UIApplication.shared.closeKeyboard()
                    }.animation(.easeIn)
            
                
                Image("blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 420, height: 150)
                
                                   
                //substitute wavescale
                    .offset(x: 0,y: flag ?wavescale: 0)
                    .animation(.easeInOut(duration: 2.0))
            }
            
            TextEditor( text: self.$text)
                .frame(maxHeight: 40)
                .font(.system(size: 30))
                .font(Font.body.bold())
                .multilineTextAlignment(.center)
                .background(Color.white)
                .onChange(of: text) { value in
                    if value.contains("\n"){
                        let newlongText=value
                        let someTexts=newlongText.splitInto(10)
                        textArray.append(contentsOf: someTexts)
                        self.text = ""
                        
                    }
                    
                    if ( textArray.count>5 ){
                        textArray.removeFirst(textArray.count-5)
                    }
                }
        }.onAppear{
            self.timerLoop = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                choosewavescale()
                if randomwavescale == 1{
                    wavescale = 60 }
                if randomwavescale == 2{
                    wavescale = 110 }
                if randomwavescale == 3{
                    wavescale = 155 }
                let randomnumber = Int.random(in: 1..<2)
                if randomnumber == 1 {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
                        //insert below line and start
                        self.randomwavescale = choosewavescale();
                        self.flag.toggle()
                        
                        
                        
                    }
                    self.timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                        self.flag.toggle()
                        if textArray.count>randomwavescale{
                            textArray.removeFirst(randomwavescale-1)
                            print(textArray)
                            
                        }
                    }
                }
            }
        }
        .background(RectangleGetter(rect: $rect))
        
        
        Spacer()
        Button(action: {
            self.showActivityView.toggle()
            self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.rect)
            createPdfFromView(hosting: UIImageView(image: uiImage), saveToDocumentsWithFileName: "somePDF")
        }) {
            Text("PDF")
                .padding()
                .foregroundColor(Color.white)
                .background(Color.black)
                .cornerRadius(70)
            
        }.sheet(isPresented: self.$showActivityView) {
            ActivityView(
                activityItems: [url],
                
                applicationActivities: nil
            )
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct RectangleGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader { geometry in
            self.createView(proxy: geometry)
        }
    }
    
    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = proxy.frame(in: .global)
        }
        return Rectangle().fill(Color.clear)
    }
}

extension UIView {
    func getImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
            
        }
    }
}

//function for randomwavescale
func choosewavescale() -> Int {
    let random = Int.random(in: 1..<3)
    let randomwavescale = random
    return randomwavescale
}
    
func createPdfFromView(hosting: UIImageView, saveToDocumentsWithFileName fileName: String) {
    let pdfData = NSMutableData()
    UIGraphicsBeginPDFContextToData(pdfData, hosting.bounds, nil)
    UIGraphicsBeginPDFPage()
    guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
    hosting.layer.render(in: pdfContext)
    UIGraphicsEndPDFContext()
    if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        let documentsFileName = documentDirectories + "/" + fileName + ".pdf"
        pdfData.write(toFile: documentsFileName, atomically: true)
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ActivityView>
    ) -> UIActivityViewController {
        return UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
    }
    
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityView>
    ) {
        
    }
}

func fileSave(fileName: String) -> URL {
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = dir.appendingPathComponent(fileName, isDirectory: false)
    return filePath
}

extension String {
    func splitInto(_ length: Int) -> [String] {
        var str = self
        for i in 0 ..< (str.count - 1) / max(length, 1) {
            str.insert(",", at: str.index(str.startIndex, offsetBy: (i + 1) * max(length, 1) + i))
        }
        return str.components(separatedBy: ",")
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


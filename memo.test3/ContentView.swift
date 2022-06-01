//
//  ContentView.swift
//  memo.test3
//
//  Created by Ryo  on 2022/05/17.
//

import SwiftUI
import Foundation
import Combine



struct ContentView: View {
    
    @State var text: String = ""
    @State private var rect: CGRect = .zero
    @State var uiImage: UIImage? = nil
    @State private var showActivityView: Bool = false
    @State var count = 0
    @State var timer :Timer?
    @State var textArray=["1","2","3","4"]
    @State var timerFlg=true
    @State private var flag = false
    private let maxTextLength = 10
    
    var body: some View {
       
        let url = fileSave(fileName: "wavePDF.pdf")
        
        VStack {
            
            
            Image("blue")
                .resizable()
                .scaledToFit()
                .frame(width: 420, height: 150)
               
//                .offset(y: flag ? 100 : -100)
//                .animation(.easeInOut(duration: 3.0))
                 
        
            
            ZStack {
                
                Form {
                    ForEach(textArray, id:\.self) { array in
                        Text(array)
                    }
                    
                }
                .onTapGesture {
                    UIApplication.shared.closeKeyboard()
                }
               
                   .animation(.easeIn)
                
                
                
                
                Image("blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 420, height: 150)
                    .offset(y: flag ? 0 : 0)
                    .offset(x: 0, y: -270)
                    .animation(.easeInOut(duration: 3.0))
                    .animation(Animation.default
                        .repeatCount(3)
                    )
                
                
                
                TextEditor( text: self.$text)
                    .frame(maxHeight: 40)
                    .font(.system(size: 30))
                    .font(Font.body.bold())
                    .multilineTextAlignment(.center)
                    .background(Color.white)
                    .padding(.all)
                    .offset(x: 0, y: 100)
                    .onChange(of: text) { value in
                        
                        if value.contains("\n"){
                            var newText=value
                            
                            //アニメーション後にtimerでdelay
                            newText.removeLast()
                            textArray.append(newText)
                            self.text = ""
                            
                            
                        }
                        
                        if value.count > maxTextLength{
                            textArray.append(value)
                            self.text = ""
                        }
                        
                        if textArray.count>5{

                            //アニメーション後にtimerでdelay
                            textArray.removeFirst()
                        }
                        
                      if (value.contains("\n") || value.count > maxTextLength)&&timerFlg==true{
//
                          timerFlg=false
                        
                    
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
                                
                                let randomnumber = Int.random(in: 1..<3)
                                if randomnumber == 1 {
                                    if textArray.count>0{
                                        textArray.removeFirst()
                                    }
                                }
                            }
                          
                          self.flag.toggle()
                          
 
                       }
                    }
                
                
                
                
            }
            
            
        }
        .background(RectangleGetter(rect: $rect))
        
        
        //上のコードはスクショの範囲指定用
        
        
        
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
// pdf保存のための長いおまじない
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
        // Nothing to do
    }
}

func fileSave(fileName: String) -> URL {
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = dir.appendingPathComponent(fileName, isDirectory: false)
    return filePath
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


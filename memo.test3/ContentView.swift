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
import AVFoundation

struct ContentView: View {
    @State var time: Int = 0
    @State var text: String = ""
    @State private var rect: CGRect = .zero
    @State var uiImage: UIImage? = nil
    @State private var showActivityView: Bool = false
    @State var count = 0
    @State var timerLoop :Timer?
    @State var timer :Timer?
    @State var onoff = false
    @State var textArray=["忘れ去りたいこと...","","","","","","",""]
    @State var opArray = Array(repeating: 1.0, count: 8)
    @State private var flag = true
    @State private var waveOffset = Array(repeating: Angle(degrees: 0), count: 5)
    @State private var percent = [100,100,100,120,120]
    @State var textlengthA = 0
    @State var textlengthB = 0
    @State private var thisisiPad = false
    private var maxArrayLengthforiPhone = 4
    private let maxArrayLengthforiPad = 6
    private let waveSound = try!  AVAudioPlayer(data: NSDataAsset(name: "VSQSE_1184_wave_33")!.data)
    private func playSound(){
            waveSound.play()
        }

    
    
    
    //   private let yeah = try!  AVAudioPlayer(data: NSDataAsset(name: "yeah")!.data)
    /*  private func playSound(){
     yeah.play()
     }
     */
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
        UITextView.appearance().backgroundColor = .clear
        
    }
    
    var body: some View {
        let url = fileSave(fileName: "wavePDF.pdf")
        ZStack{
            
            
            
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                Color(hue: 0.1, saturation: 0.15, brightness: 1, opacity: 0.5)
                
            
                
                ForEach((0...4), id: \.self){nums in
                    
                    Wave(offset: Angle(degrees: self.waveOffset[nums].degrees), percent:Double(percent[nums])/95-(0.04)*Double((nums))
                    )
                    //rgbで青⇨水色⇨白としたいが、色コード的にforeachじゃきつい
                    // .fill(Color(red: 255, green: 250, blue: 250,
                    .fill(Color(red: 0, green: 0, blue: 1, opacity: 0.8-(0.1)*Double((nums))))
                    .onTapGesture {
                        UIApplication.shared.closeKeyboard()
                        onoff = true
                    }
                    
                }
                
                
                VStack{
                    Form {
                        
                        ForEach(0..<textArray.count, id:\.self) { i in
                            Text("\(self.textArray[i])")
                                .font(.system(size: thisisiPad ?20: 40, weight: .black, design: .rounded))
                                .opacity(self.opArray[i])
                                .animation(.easeInOut(duration: 1))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.gray)
                                .listRowBackground(Color.clear)
                                .onTapGesture {
                                    UIApplication.shared.closeKeyboard()
                                }
                            
                        }
                    }.offset(x:0,y:100)
                    
                    TextEditor( text: self.$text)
                        .frame(maxHeight: thisisiPad ?40: 50)
                        .font(.system(size: thisisiPad ?25: 40, weight: .black, design: .rounded))
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .background(Color.gray.opacity(0.2))
                        .onChange(of: text) { value in
                            if value.contains("\n"){
                                var newlongText=value
                                newlongText.removeLast()
                                let someTexts=newlongText.splitInto(thisisiPad ?10: 25)
                                textArray.append(contentsOf: someTexts)
                                
                                for _ in 0..<someTexts.count {
                                    opArray.append(1.0)
                                }
                                self.text = ""
                            }
                            
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                
                                if ( textArray.count>maxArrayLengthforiPad ){
                                    textArray.removeFirst(textArray.count-maxArrayLengthforiPad)
                                    self.thisisiPad.toggle()
                                }
                            }
                            
                            
                            if UIDevice.current.userInterfaceIdiom == .phone {
                            
                                if ( textArray.count>maxArrayLengthforiPhone ){
                                    textArray.removeFirst(textArray.count-maxArrayLengthforiPhone)
                                    
                                }
                            }
                            
                            
                            
                            
                            
                        }
                    
                    
                }
            }.background(RectangleGetter(rect: $rect))
                .onAppear{
                    //もしかしてonappearの1秒後にタイマースタートだからズレある？
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        time += 1
                        
                    }
                    playSound()
                    Timer.scheduledTimer(withTimeInterval: 239, repeats: true) { timer in
                        playSound()
                        
                    }
                    
                    onoff = true
                    
                    conWave(nums:0)
                    conWave(nums:1)
                    conWave(nums:2)
                    
                    self.timerLoop = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                        textlengthA = text.count
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            // 2秒後に実行する処理
                            textlengthB = text.count
                        }
                    }
                    //2秒間に5文字以上入力してたら実行
                    if textlengthB-textlengthA<5{
                        
                        
                        self.timerLoop = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                            
                            let randomnum = Int.random(in: 1..<4)
                            
                            if randomnum == 1 {
                                let randomwavescale = Int.random(in: 1..<4)
                         
                                //           playSound()
                  
                                moveWave(to:Int(100-(randomwavescale)*7),nums:3)
                                moveWave(to:Int(100-(randomwavescale)*9),nums:4)
                                
                   
                                self.timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { _ in
                                    
                                    backWave(nums:3)
                                    backWave(nums:4)
                                    
                                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                                        
                                        for i in 0..<randomwavescale {
                                            opArray[i]=0
                                        }
                                        if textArray.count>=randomwavescale{
                                            textArray.removeFirst(randomwavescale)
                                            for i in 0..<randomwavescale {
                                                opArray[i]=1
                                            }
                                        }
                                        
                                        if textArray.count<randomwavescale{
                                            textArray.removeFirst(textArray.count)
                                            for i in 0..<randomwavescale {
                                                opArray[i]=1
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            
                            
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                    self.onoff = false
                    
                    
                }
        }
        if onoff{
            Spacer()
            Button(action: {
                self.showActivityView.toggle()
                self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.rect)
                
                createPdfFromView(hosting: UIImageView(image: uiImage), saveToDocumentsWithFileName: "wavePDF")
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
            }}
    }
    
    
    
    func moveWave(to:Int,nums:Int){
        self.waveOffset[nums] = Angle(degrees: Double((time%6)*60)/2-180)
        withAnimation(Animation.linear(duration: 3)){
           // self.waveOffset[nums] = Angle(degrees: 180)
            self.waveOffset[nums] = Angle(degrees: Double((time%6)*60)/2)
            
            self.percent[nums] = to
        }
    }
    
   
    func backWave(nums:Int){
        self.waveOffset[nums] = Angle(degrees: Double((time%6)*60)/2-180)
        withAnimation(Animation.linear(duration: 3)){
           // self.waveOffset[nums] = Angle(degrees: 180)
            self.waveOffset[nums] = Angle(degrees: Double((time+Int(0.5))%6*60)/2)
            
            self.percent[nums] = 120
            
            
        }
    }
    //timerでoffset wavesetがmovewaveとbackwaveに上書きされちゃう
    func conWave(nums:Int){
        withAnimation(Animation.linear(duration:6).repeatForever(autoreverses: false)) {
            self.waveOffset[nums] = Angle(degrees: 360)
        }
        
    }
    //ランダムなdurationにするconwave 失敗
    /* func conWave(nums:Int){
     withAnimation(Animation.linear(duration: Double(10-Int(0.01)*(nums))).repeatForever(autoreverses: false)) {
     self.waveOffset[nums] = Angle(degrees: 360)
     }
     self.timerLoop = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
     withAnimation(Animation.linear(duration: Double(20-Int(0.01)*(nums))).repeatForever(autoreverses: false)) {
     self.waveOffset[nums] = Angle(degrees: Double(360*Int.random(in: 1...2)))
     }
     }
     }*/
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

extension String {
    func splitInto(_ length: Int) -> [String] {
        var str = self
        for i in 0 ..< (str.count - 1) / max(length, 1) {
            str.insert(",", at: str.index(str.startIndex, offsetBy: (i + 1) * max(length, 1) + i))
        }
        return str.components(separatedBy: ",")
    }
}



struct Wave: Shape {
    
    var offset: Angle
    var percent: Double
    
    var animatableData: AnimatablePair<Double, Double>{
        get {
            AnimatablePair(offset.degrees, percent)
        }
        set {
            offset = Angle(degrees: newValue.first)
            percent = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        // empirically determined values for wave to be seen
        // at 0 and 100 percent
        let lowfudge = 0.02
        let highfudge = 0.98
        
        let newpercent = lowfudge + (highfudge - lowfudge) * percent
        //waveHeight = wave座標（下に正）*定数 もしくは
        //movewave()の時、withaimationで3秒かけて0.02⇨0.08
        //backwave()の時、withaimationで3秒かけて0.08⇨0.02
        let waveHeight = 0.02 * rect.height
        let yoffset = CGFloat(1 - newpercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 4) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            //sin出てきた
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: -rect.height))
        p.addLine(to: CGPoint(x: 0, y: -rect.height))
        p.closeSubpath()
        
        return p
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



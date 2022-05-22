//
//  ContentView.swift
//  memo.test3
//
//  Created by Ryo  on 2022/05/17.
//

import SwiftUI

import Combine
//textfieldに直接入力できるようにするためのclass設定か、もしくはキーボードの動的高さ設定
//いずれ必要になりそうだから残しておこう
class KeyboardObserver: ObservableObject {

  @Published var keyboardHeight: CGFloat = 0.0

  func addObserver() {
    NotificationCenter
      .default
      .addObserver(self,
                   selector: #selector(self.keyboardWillChangeFrame(_:)),
                   name: UIResponder.keyboardWillChangeFrameNotification,
                   object: nil)
  }

  func removeObserver() {
    NotificationCenter
      .default
      .removeObserver(self,
                      name: UIResponder.keyboardWillChangeFrameNotification,
                      object: nil)
  }

    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = notification
          .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        let beginFrame = notification
          .userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
          let endFrameMinY: CGFloat = endFrame.cgRectValue.minY
          let beginFrameMinY: CGFloat = beginFrame.cgRectValue.minY
//keyboardHeightとかは要らないかも
          self.keyboardHeight = beginFrameMinY - endFrameMinY
          if self.keyboardHeight < 0 {
            self.keyboardHeight = 0
          }
        }
      }

    }

//乱数生成できたが、アプリ起動直後しか適用されない⇨できた！！！！
//let randomInt = Int.random(in: 1..<4)





//見た目を作る
struct ContentView: View {

  @ObservedObject var keyboard = KeyboardObserver()
  @State var text: String = ""
  @State private var rect: CGRect = .zero
  @State var uiImage: UIImage? = nil
  @State private var showActivityView: Bool = false
  @State var count = 0
  @State var timer :Timer?

  var body: some View {
      //下verをletに変えたら準警告が出なくなった
      let url = fileSave(fileName: "wavePDF.pdf")
      
      VStack {
      Text("Ethan's memo")
      
      ZStack {
          /*LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
          
                            .ignoresSafeArea()*/
          
          Image("wavess")
              .resizable()
              //.aspectRatio(contentMode: .fit)
              .offset(x: 0, y: 0)

              
              
          TextEditor(text: self.$text)
              .frame(minHeight: 100)
              .font(.system(size: 30))
              .multilineTextAlignment(.center)
              .background(Color.clear)
              .padding(.all)
              .offset(x: 0, y: 300)
          
      
      
          
          
          /*if self.text.isEmpty
          { Text("write here").opacity(0.25)
              .offset(x: 0, y: -20)
              .font(.system(size: 30))
          }*/
//Button(action以下をランダムのタイミングで実行してくれるシステム作る 装飾は除く
        
          Button(action: {
          timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            //確率で以下のdelete行為を実行するif文を書く
              //1-9範囲指定して、その中に5が含まれればdeleteを実行する
              let numbers = "123456789"
              let randomnumber1 = Int.random(in: 1..<10)
              let randomnumber2 = Int.random(in: 1..<10)
             

              var sub = ""

              if randomnumber1 > randomnumber2 {
                  possibility = ""
              } else {
                  let startIdx = s.index(s.startIndex, offsetBy: randomnumber1, limitedBy: s.endIndex) ?? s.endIndex
                  let endIdx = s.index(s.startIndex, offsetBy: randomnumber2 + 1, limitedBy: s.endIndex) ?? s.endIndex
                  possibility = String(s[startIdx..<endIdx])
              }
              
              if possibility.contain("5"){
                
                
              if
              
              let s = text
              let start = 0
              let end = 10

              var sub = ""

              if start > end {
                  sub = ""
              } else {
                  let startIdx = s.index(s.startIndex, offsetBy: start, limitedBy: s.endIndex) ?? s.endIndex
                  let endIdx = s.index(s.startIndex, offsetBy: end + 1, limitedBy: s.endIndex) ?? s.endIndex
                  sub = String(s[startIdx..<endIdx])
              }
              
              
//一行あたりの文字数を制限できないから、指定できん
              if (sub.contains("/n") == true   ){
                  let num = Int(text.count)
                  
                  self.text = String(text.dropFirst(num-1))
             
              
              /*}else if ( text.count >= 10){
                  
                  let num = 10
                  
                  self.text = String(text.dropFirst(num))*/
    
              
              }else{
                  
                  let num = text.count
                  
                  
                  self.text = String(text.dropFirst(text.count))
              }
              
          
          })
              
          }
             
              
                    
          
                    
                    //ボタンを押したら乱数生成⇨変数に代入
                         //乱数を代入できた
              //let randomInt = Int.random(in: 1..<10)
              
              // droplastをline数に変換できないかな
              
                     /* }){
                        //以下8行くらいは装飾
                          Image(systemName: "clear")
                          Text("Delete (random number) letters")
                                  .frame(width: 300, height: 60)
                                  .foregroundColor(Color.black)
                      }
                      .background(Color.white)
                      .offset(x: 0, y: 300)
                      .foregroundColor(Color.black)*/
          
                      
          
          
          
        }
      }
      //下のコードを忘れ、1時間スクショがずっと真っ白で死んでた
      .background(RectangleGetter(rect: $rect))
      
    .onAppear(perform: {
        self.keyboard.addObserver()
        UITextView.appearance().backgroundColor = .clear
    }).onDisappear(perform: {
        self.keyboard.removeObserver()
        UITextView.appearance().backgroundColor = nil
    }).padding(.bottom,
               self.keyboard.keyboardHeight)
      .animation(.easeOut)
      
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


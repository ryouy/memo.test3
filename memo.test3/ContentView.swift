//
//  ContentView.swift
//  memo.test3
//
//  Created by Ryo  on 2022/05/17.
//


import SwiftUI
import Foundation
import Combine
//textfieldに直接入力できるようにするためのclass設定か、もしくはキーボードの動的高さ設定
//いずれ必要になりそうだから残しておこう
/*class KeyboardObserver: ObservableObject {

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

    }*/

//乱数生成できたが、アプリ起動直後しか適用されない⇨できた！！！！
//let randomInt = Int.random(in: 1..<4)





//見た目を作る
struct ContentView: View {

//  @ObservedObject var keyboard = KeyboardObserver()
  @State var text: String = ""
  @State private var rect: CGRect = .zero
  @State var uiImage: UIImage? = nil
  @State private var showActivityView: Bool = false
  @State var count = 0
  @State var timer :Timer?
  //@State var textArray = [""]
  @State var textArray = ["1","2","3","4"]
    
    private let maxTextLength = 10

  var body: some View {
      //下verをletに変えたら準警告が出なくなった
      let url = fileSave(fileName: "wavePDF.pdf")
      
      VStack {
    
      Spacer()
      Text("Ethan's memo")
          
           
          
          
          
          
         //お試し
          Text(text)
              .background(Color.white)
      
      ZStack {
          
          /*LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
          
                            .ignoresSafeArea()*/
        
          Form {
              ForEach(textArray, id:\.self) { array in
                 Text(array)
             }
         }
         
          
         /* Image("wavess")
              .resizable()
              //.aspectRatio(contentMode: .fit)
              .offset(x: 0, y: 0)
              .onTapGesture {
               UIApplication.shared.closeKeyboard()
              }*/

          TextField("write here", text: self.$text)
             // .frame(minHeight: )
              .frame(maxHeight: 45)
              .font(.system(size: 30))
              .multilineTextAlignment(.center)
              .background(Color.white)
              .padding(.all)
              .offset(x: 0, y: 100)
              .onChange(of: text) { value in
                  
//                  入力変更されたとき、最後の行の文字数をチェック
//                  abcd\nefg -> ["abcd","efg"]
                //  var textArray=text.components(separatedBy:.newlines)
//                 efgだけを抽出
                  let newText=textArray.last!
//                  efgがmaxTextLengthより大きいと強制改行
                  //改行文字がきたらor10文字超えたら、textarrayに送って、一行目を削除する
                  if text.contains("\n"){
                      textArray.append(text)
                      textArray.removeFirst()
                      self.text = ""
                      
                  }
                  
                  if text.count > maxTextLength{
                      //text.removeFirst(10)
                      textArray.append(text)
                      textArray.removeFirst()
                      self.text = ""
/*                      textArray.append(contentsOf:[String(newText.dropFirst(maxTextLength-1))])
                      textArray[textArray.count-2] = String(newText.prefix(maxTextLength))
//                      \nで区切りにして文字列に戻す
                      text=textArray.joined(separator: "\n")*/
                    
                  }
              
          
/*          if text.contains("\n"){
              text.dropFirst(10)
          }*/
              }
          //TextArray.append(text)   text=""
          //もしくは TextArray.dropfirst(num=10)で消去
          //TextArray.removeFirst()
          
          /*if self.text.isEmpty{ Text("write here").opacity(0.25)
              .offset(x: 0, y: 180)
              .font(.system(size: 30))
          }*/
//Button(action以下をランダムのタイミングで実行してくれるシステム作る 装飾は除く
        
          
          Button("start wave", action: {
          timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
              
              
         
            //確率で以下のdelete行為を実行するif文を書く
              //1-9範囲指定して、その中に5が含まれればdeleteを実行する
              let randomnumber = Int.random(in: 1..<3)
//５より小さい時に一行目を消す
              if randomnumber == 1 {
                  
                  textArray.removeFirst()
/*                  let textArray=text.components(separatedBy:.newlines)
                  if textArray.count>1{
//                      一行目以降を残す
                      text=textArray[1..<textArray.count].joined(separator: "\n")
                      print(text)
                  }else{
                      text=""
                  }
                  
//                  textArray.append(contentsOf:
//                                    )
 */
              }
//一行あたりの文字数を制限できないから、指定できん
          }})
         .offset(x: 0, y: 200)
          ;
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
      //下のコードを忘れ、1時間スクショがずっと真っ白で死んでた
      .background(RectangleGetter(rect: $rect))
      
  /*  .onAppear(perform: {
        self.keyboard.addObserver()
        UITextView.appearance().backgroundColor = .clear
    }).onDisappear(perform: {
        self.keyboard.removeObserver()
        UITextView.appearance().backgroundColor = nil
    }).padding(.bottom,
               self.keyboard.keyboardHeight)
      .animation(.easeOut)
      */
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





//textinputarrayの配列をうまくずらすコードが欲しいね



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

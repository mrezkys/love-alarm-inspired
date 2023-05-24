//
//  TargetView.swift
//  LoveAlarmInspired
//
//  Created by Muhammad Rezky on 25/05/23.
//

import SwiftUI

struct TargetView: View {
    @State private var searchText = ""
    private var data: [String] = ["1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", ]
    
    var datas: [String] {
        let a = data.map{$0.lowercased()}
        return searchText == "" ? a : a.filter{
            $0.contains(searchText.lowercased())
        }
    }
        
    
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .center){
                    Text("Muhammad Rezky Sulihin")
                        .foregroundColor(.white).foregroundColor(.white)
                        .font(Font.system(size: 16, design: .rounded))
                    Spacer().frame(height: 4)
                    Text(verbatim:"mrezkysulihin@gmail.com")
                        .foregroundColor(.white.opacity(0.8))
                        .font(Font.system(size: 12, design: .rounded))
                }
                .padding(16)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("pink2"), Color("pink1")]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(16)
                .padding(24)
                List{
                    
                    ForEach(datas, id: \.self){ da in
                        HStack{
                            Text(da)
                            Spacer()
                        }
                    }
                }
            }
//            .searchable(text: $searchText)
                
        }
        .navigationTitle("Select Target")
        
    }
}

struct TargetView_Previews: PreviewProvider {
    static var previews: some View {
        TargetView()
    }
}

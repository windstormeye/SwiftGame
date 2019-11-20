//
//  FireContentView.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

struct FireContentView: View {
    @ObservedObject var viewModel: FireViewModel
    init(viewModel: FireViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            headerViewStack()
            bodyView()
        }.frame(alignment: .top)
        .background(Color.white)
            .alert(isPresented: $viewModel.isWin) { () -> Alert in
                
                return Alert(title: Text("\(viewModel.winString)"), dismissButton: .default(Text("重新开始"), action: {
                     self.viewModel.resetFire()
                }))
        }
    }
    
    func headerViewStack() -> some View {
        return HStack {
            button(title: "退出", color: Color.red) {
                // 退出事件
                self.viewModel.exit()
            }
            Spacer()
            Text("第\(viewModel.missionRecord.currentFireNumber)关")
            Spacer()
            button(title: "重置", color: Color.green) {
                // 重置事件
                self.viewModel.resetFire()
            }
        }.padding(.horizontal, 15)
    }
    
    func bodyView() -> some View {
        return VStack {
            HStack {
                Text("\(viewModel.timeString)")
                    .font(.system(size: 45))
                    .foregroundColor(Color.black)
                Spacer()
                Text("\(viewModel.redOrBlue ? "蓝": "红")方回合")
                    .font(.system(size: 44))
                    .foregroundColor(Color.black)
                
            }.padding(.horizontal, 15)
            Spacer()
            ForEach.init(viewModel.missionRecord.lights, id: \.id) { (element) in
                HStack(spacing:20.0) {
                    ForEach.init(element.rows, id: \.id) { (light) in
                        ZStack {
                            Circle()
                                .foregroundColor(light.countStatus ? light.currentSelectColor : .gray)
                                .opacity(light.status ? 0.8 : 0.5)
                                
                                .shadow(color: light.currentSelectColor, radius: light.countStatus ? 10 : 0)
                                .onTapGesture {
                                self.viewModel.nextSetp(column: light.id % self.viewModel.missionRecord.currentFireSize, row: element.id)
                            }
                            Text("\(light.count)")
                        }.frame(width: self.viewModel.circleWidth(),
                        height: self.viewModel.circleWidth())
                    }
                }
            }.padding(.vertical, 10)
            Spacer()
            HStack {
                Text("\(viewModel.answerString)")
                .font(.system(size: 18))
                .foregroundColor(self.viewModel.showAnswer ? .black : .clear)
            }.frame(height: 80.0, alignment: .center)
        }
    }
    
    func button(title: String, color: Color, action:@escaping () -> Void) -> some View {
        return ZStack {
            Rectangle()
                .frame(width: 60, height: 35, alignment: .center)
                .foregroundColor(color)
                .cornerRadius(15)
            Text(title)
            .bold()
        }.onTapGesture {
            action()
        }
    }
}

struct FireContent_preview: PreviewProvider {
    static var previews: some View {
        let viewModel = FireViewModel.init(pop: MainNavViewModel.init())
        return Group {
            FireContentView.init(viewModel: viewModel)
        }
    }
}

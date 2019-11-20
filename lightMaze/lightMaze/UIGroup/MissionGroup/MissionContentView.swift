//
//  MissionContentView.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

struct MissionContentView: View {
    @ObservedObject var viewModel: MissionViewModel
    init(viewModel: MissionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            headerViewStack()
            Text("第\(viewModel.missionRecord.currentMissionNumber)关").fontWeight(Font.Weight.medium).foregroundColor(Color.secondary).font(.system(size: 30)).padding(.top, 20)
            
            bodyView()
        }.frame(alignment: .top)
        .background(Color.white)
            .alert(isPresented: $viewModel.isWin) { () -> Alert in
                return Alert(title: Text("闯关成功，继续努力！"), dismissButton: .default(Text("下一关"), action: {
                    self.viewModel.nextMission()
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
            button(title: "重置", color: Color.green) {
                // 重置事件
                self.viewModel.resetMission()
            }
             Spacer()
            button(title: "提示", color: Color.yellow) {
                // 提示事件
                self.viewModel.tipsMission()
                
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
                Text("\(viewModel.clickTimes)步")
                    .font(.system(size: 44))
                    .foregroundColor(Color.black)
                
            }.padding(EdgeInsets.init(top: 20, leading: 15, bottom: 0, trailing: 15))
            
            ForEach.init(viewModel.missionRecord.lights, id: \.id) { (element) in
                HStack(spacing:20.0) {
                    ForEach.init(element.rows, id: \.id) { (light) in
                        ZStack {
                            Circle()
                                .foregroundColor(light.status ? .yellow : .gray)
                                .opacity(light.status ? 0.8 : 0.5)
                                
                                .shadow(color: .yellow, radius: light.status ? 10 : 0)
                                .onTapGesture {
                                    self.viewModel.clickTimes += 1
                                    self.viewModel.updateLightStatus(column: light.id % self.viewModel.missionRecord.currentMissionSize, row: element.id)
                            }
                            Text("\(light.number)")
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

struct MissionContent_preview: PreviewProvider {
    static var previews: some View {
        let viewModel = MissionViewModel.init(pop: MainNavViewModel.init())
        return Group {
            MissionContentView.init(viewModel: viewModel)
        }
    }
}

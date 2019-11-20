//
//  ContentView.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import SwiftUI

struct RandomContentView: View {
    
    let viewModel: RandomViewModel
    init(viewModel: RandomViewModel) {
        self.viewModel = viewModel
    }
    
    @ObservedObject var gameManager = GameManager.init(gameType: .random)
    
    @State var isShowHistory = false
    
    var body: some View {
        VStack {
            HStack {
                button(title: "退出", color: .red, size: CGSize.init(width: 60, height: 35)) {
                    self.gameManager.timerRestart()
                    self.viewModel.exit()
                }.padding(.leading,20)
                Spacer()
                button(title: "开始", color: .green, size: CGSize.init(width: 60, height: 35)) {
                    self.gameManager.timerRestart()
                    self.gameManager.loadRandomData()
                    self.gameManager.startRandomPlay()
                    
                }
                Spacer()
                button(title: "提示", color: .yellow, size: CGSize.init(width: 60, height: 35)) {
                    self.gameManager.showAnswer = true
                }.padding(.trailing,20)
            }
            
            HStack {
                Text("当前随机难度为：\(self.gameManager.recordCurrentLights.count)").frame( height: 35).font(.system(size: 25)).foregroundColor(self.gameManager.isStart ? Color.secondary : .clear).multilineTextAlignment(.leading).padding(.leading, 20)
                
                
            }.padding(.top, 20)
            
            HStack {
                Text("\(gameManager.timeString)")
                    .font(.system(size: 45))
                    .foregroundColor(Color.black).padding(.leading,20)
                Spacer()
                Text("\(gameManager.clickTimes)步")
                    .font(.system(size: 44))
                    .foregroundColor(Color.black).padding(.trailing,20)
                
            }.padding(.top, 40)
            
            ForEach(0..<gameManager.lights.count) { row in
                HStack {
                    ForEach(0..<self.gameManager.lights[row].count) { column in
                        ZStack{
                            Circle()
                                .foregroundColor(self.gameManager.lights[row][column].status ? .yellow : .gray)
                                .opacity(self.gameManager.lights[row][column].status ? 0.8 : 0.5)
                                .frame(width: self.gameManager.circleWidth(),
                                       height: self.gameManager.circleWidth())
                                .shadow(color: .yellow, radius: self.gameManager.lights[row][column].status ? 10 : 0)
                                .onTapGesture {
                                    self.gameManager.clickTimes += 1
                                    self.gameManager.updateLightStatus(column: column, row: row)
                            }.padding(5)
                            Text("\(self.gameManager.showAnswer ?  self.gameManager.lightsNums[row][column] : "")")
                        }
                    }
                }
            }.padding(.top, 20)
            
            Spacer()
            HStack {
                Text("\(gameManager.answerString)")
                    .font(.system(size: 18))
                    .foregroundColor(self.gameManager.showAnswer ? .black : .clear)
            }.padding(20)
            
        }
        .alert(isPresented: $gameManager.isWin) {
            Alert(title: Text("黑灯瞎火，摸鱼成功！"), dismissButton: .default(Text("继续摸鱼"), action: {
                self.gameManager.timerRestart()
                self.gameManager.loadRandomData()
                self.gameManager.startRandomPlay()
            }))
        }
    }
    
    func button(title: String, color: Color, size: CGSize, action:@escaping () -> Void) -> some View {
        return ZStack {
            Rectangle()
                .frame(width: size.width, height: size.height, alignment: .center)
                .foregroundColor(color)
                .cornerRadius(15)
            Text(title)
                .bold()
        }.onTapGesture {
            action()
        }
    }
}

struct RandomContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RandomViewModel.init(pop: MainNavViewModel.init())
        return Group {
            RandomContentView(viewModel: viewModel)
                .environment(\.colorScheme, .light)
            
            RandomContentView(viewModel: viewModel)
                .environment(\.colorScheme, .dark)
        }
    }
}

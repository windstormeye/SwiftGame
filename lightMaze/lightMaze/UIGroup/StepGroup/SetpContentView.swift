//
//  SetpContentView.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import SwiftUI

struct SetpContentView: View {
    
    let viewModel: SetpViewModel
    init(viewModel: SetpViewModel){
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color(UIColor.white)
                .edgesIgnoringSafeArea(.all)
            VStack {
                
                HStack {
                    Spacer()
                    Text("游戏规则").foregroundColor(Color.orange).bold().padding(.trailing, 20).onTapGesture {
                        self.viewModel.toRulePage()
                    }
                }.padding(.top, 30)
                
                VStack {
                    
                    Image("灯泡").resizable()
                        .aspectRatio(UIImage(named: "灯泡")!.size, contentMode: .fit).frame(width: 200, height: 200, alignment: .center)
                    Text("光影迷阵")
                        .bold()
                        .font(.system(size: 50))
                        .padding(.vertical, 10)
                }
                .frame(width: screenWidth, alignment: .center).padding(.top, 0)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 40) {
                    button(title: "随机模式", color: Color.yellow) {
                        // 跳转随机模式
                        self.viewModel.toRandomPage()
                    }
                    button(title: "关卡模式", color: .yellow) {
                        // 跳转关卡模式
                        self.viewModel.toMissionPage()
                    }
                    button(title: "分裂作战", color: .yellow) {
                        // 跳转到分裂作战模式
                        self.viewModel.toFirePage()
                    }
                }.padding(.bottom, 100)
                
                VStack {
                     Text("Copyright © 2018-2019 SwiftGame. All rights reserved.")
                             .font(.footnote)
                             .multilineTextAlignment(.center)
                             .foregroundColor(Color(.secondaryLabel))
                             .padding(.bottom, 10)
                             .frame(width: 300.0)
                }.frame(width: screenWidth - 60, height: 60, alignment: .center)
            }.frame(width: screenWidth, alignment: .top)
                
        }.frame(alignment: .top)
    }
    
    func button(title: String, color: Color, action:@escaping () -> Void) -> some View {
        return ZStack {
            Rectangle()
                .frame(width: screenWidth - 40, height: 60, alignment: .center)
                .foregroundColor(color)
                .cornerRadius(15)
            Text(title)
            .bold()
        }.onTapGesture {
            action()
        }
    }
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

struct SetpContentVeiw_Previews: PreviewProvider {
    static var previews: some View {
        let responder = MainNavViewModel.init()
        let viewModel = SetpViewModel.init(toRandom: responder, missonResponder: responder, ruleResponder: responder, fireResponder: responder)
        return Group {
            SetpContentView.init(viewModel: viewModel)
        }
    }
}

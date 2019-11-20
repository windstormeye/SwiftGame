//
//  RuleContentView.swift
//  lightMaze
//
//  Created by 豆沙馅丶 on 2019/11/16.
//  Copyright © 2019 aby. All rights reserved.
//

import SwiftUI
import Combine

struct RuleContentView: View {
    @ObservedObject var viewModel: RuleViewModel
    
    init(viewModel: RuleViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            backBtn()
            Spacer()
            randomRuleView()
            Spacer()
            missionRuleView()
            Spacer()
        }.background(Color.white)
    }

    func backBtn() -> some View {
        HStack {
            button(title: "返回", color: .green) {
                self.viewModel.exit()
            }.padding(.leading, 20)
            Spacer()
        }
        
    }
    
    func randomRuleView() -> some View {
        return HStack(alignment: .top) {
             Text("随机玩法规则：").foregroundColor(.yellow).padding(.leading, 10)
                       Text(viewModel.randomRule).foregroundColor(.gray).padding(.trailing, 10)
        }
    }
    
    func missionRuleView() -> some View {
        return HStack(alignment: .top) {
            Text("关卡玩法规则：").foregroundColor(.yellow).padding(.leading, 10)
            Text(viewModel.missionRule).foregroundColor(.gray).padding(.trailing, 10)
        }
    }
    
    func button(title: String, color: Color, action:@escaping () -> Void) -> some View {
        return ZStack {
            Rectangle()
                .frame(width: 60, height: 35, alignment: .center)
                .foregroundColor(color)
                .cornerRadius(10)
            Text(title)
            .bold()
        }.onTapGesture {
            action()
        }
    }
}

struct RuleContentView_preview: PreviewProvider {
    static var previews: some View {
        let viewModel = RuleViewModel.init(pop: MainNavViewModel.init())
        return Group {
            RuleContentView.init(viewModel: viewModel)
        }
    }
}

//
//  TurnOffLightGame.swift
//  SwiftGame
//
//  Created by pjhubs on 2022/12/18.
//

import SwiftUI

struct TurnOffLightGame: View {
    @ObservedObject var gameManager = GameManager(size: 5, lightSequence: [1, 2, 3])
    
    @State var isShowHistory = false
    
    var body: some View {
        VStack {
            HStack {
                Text("\(gameManager.timeString)")
                    .font(.system(size: 45))
                    
                Spacer()
                
                Text("\(gameManager.clickTimes)步")
                    .font(.system(size: 45))
                    
            }
            .padding(20)
            
            Spacer()
                        
            ForEach(0..<gameManager.lights.count, id: \.self) { row in
                HStack(spacing: 20) {
                    ForEach(0..<self.gameManager.lights[row].count, id: \.self) { column in
                        Circle()
                            .foregroundColor(self.gameManager.lights[row][column].status ? .yellow : .gray)
                            .opacity(self.gameManager.lights[row][column].status ? 0.8 : 0.5)
                            .frame(width: self.gameManager.circleWidth(),
                                   height: self.gameManager.circleWidth())
                            .shadow(color: .yellow, radius: self.gameManager.lights[row][column].status ? 10 : 0)
                            .overlay(RoundedRectangle(cornerRadius: self.gameManager.lights[row][column].selected ? self.gameManager.circleWidth() : 0 ).stroke(Color.black, lineWidth: self.gameManager.lights[row][column].selected ? 5 : 0 ))
                            .onTapGesture {
                                self.gameManager.clickTimes += 1
                                self.gameManager.updateLightStatus(column: column, row: row, userTouch: true)
                        }
                    }
                }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            }
            
            Spacer()
        }
            .alert(isPresented: $gameManager.isWin) {
                Alert(title: Text("黑灯瞎火，摸鱼成功！"), dismissButton: .default(Text("继续摸鱼"), action: {
                    self.gameManager.start([3, 2, 1])
                    self.gameManager.timerRestart()
                }))
        }
    }
}

struct TurnOffLightGame_Previews: PreviewProvider {
    static var previews: some View {
        TurnOffLightGame()
    }
}

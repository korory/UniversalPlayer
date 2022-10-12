//
//  PlayerView.swift
//  UniversalPlayer
//
//  Created by Arnau Rivas Rivas on 11/10/22.
//

import SwiftUI

struct PlayerView: View {
    
    @StateObject var playerViewModel = PlayerViewModel()
        
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(playerViewModel.backgroundColorGray), Color(playerViewModel.backgroundColorDark)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack (spacing: 10){
                Spacer()
                
                //Album Cover
                albumCoverComponent
                
                Spacer()
                
                //Slider Timer
                sliderTimerComponent
                
                //Music Controls
                musicControlsComponents
                
                Spacer()
                
            }
        }
    }
}

extension PlayerView {
    
    var musicControlsComponents: some View {
        HStack (spacing: 60){
            
            //Previous Song Button
            previousSongButtonComponent
            
            //Play Button
            playComponent
            
            //Next Song Button
            nextSongButtonComponent
        }
        .padding(.top, 40)
    }
    
    var previousSongButtonComponent: some View {
        Image(systemName: playerViewModel.previousSongButtonAsset)
            .resizable()
            .scaledToFill()
            .frame(width: 15, height: 25)
            .foregroundColor(.white)
    }
    
    var playComponent: some View {
        Button {
            playerViewModel.audioPlay()
        } label: {
            Image(systemName: playerViewModel.playPauseTextButton)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
        }
    }
    
    var nextSongButtonComponent: some View {
        Image(systemName: playerViewModel.nextSongButtonAsset)
            .resizable()
            .scaledToFill()
            .frame(width: 15, height: 25)
            .foregroundColor(.white)
    }
    
    var sliderTimerComponent: some View {
        ZStack (alignment: .leading) {
            RoundedRectangle(cornerRadius: 2)
                .stroke(lineWidth: 4)
                .fill(Color.white)
                .frame(width: playerViewModel.dragOffsetCircle.width, height: 1)
                .opacity(1.0)
            
            RoundedRectangle(cornerRadius: 2)
                .stroke(lineWidth: 4)
                .fill(Color.gray)
                .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                .opacity(0.2)
            
            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)
                .offset(x: playerViewModel.dragOffsetCircle.width)
                .gesture(DragGesture()
                    .onChanged({ value in
                        playerViewModel.onChangeCircleCurrentTimeBar(value: value)
                        print(playerViewModel.dragOffsetCircle.width)
                    })
                    .onEnded({ value in
                        playerViewModel.onChangeCircleCurrentTimeBar(value: value)
                    }))
        }
    }
    
    var albumCoverComponent: some View {
        Image("albumTest")
            .resizable()
            .scaledToFit()
            .frame(width: 350, height: 350)
            .padding(.leading, 20)
            .padding(.trailing, 20)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}

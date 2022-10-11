//
//  PlayerView.swift
//  UniversalPlayer
//
//  Created by Arnau Rivas Rivas on 11/10/22.
//

import SwiftUI

struct PlayerView: View {
    
    var playerViewModel = PlayerViewModel()
    
    var body: some View {
        VStack {
            Button {
                playerViewModel.audioPlay()
            } label: {
                Text("Play")
            }

        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}

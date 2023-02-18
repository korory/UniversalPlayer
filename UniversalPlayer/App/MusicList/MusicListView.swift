//
//  MusicListView.swift
//  UniversalPlayer
//
//  Created by Arnau Rivas Rivas on 18/2/23.
//

import SwiftUI

struct MusicListView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors:[
                    Color(backgroundColorGray),
                    Color(backgroundColorDark)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                VStack {
                    List {
                        ForEach(0..<20) {_ in
                            NavigationLink {
                                PlayerView()
                            } label: {
                                MusicListCellView(imageSong: "imagePlaceholder", titleSong: "Test", authorSong: "Test")
                            }
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .buttonStyle(PlainButtonStyle())
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .padding(.trailing, 15)
                }
            }
            .navigationTitle("Songs")
            .preferredColorScheme(.dark)
        }
    }
}

struct MusicListView_Previews: PreviewProvider {
    static var previews: some View {
        MusicListView()
    }
}

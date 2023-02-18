//
//  MusicListCellView.swift
//  UniversalPlayer
//
//  Created by Arnau Rivas Rivas on 18/2/23.
//

import SwiftUI

struct MusicListCellView: View {
    
    var imageSong: String
    var titleSong: String
    var authorSong: String
    
    var body: some View {
        HStack (spacing: 10){
            Image(imageSong)
                .resizable()
                .frame(width: 50, height: 50)
            
            VStack (alignment: .leading, spacing: 5){
                Text(titleSong)
                    .font(.system(size: 15, weight: .heavy, design: .default))
                    .lineLimit(1)
                    .foregroundColor(.white)
                Text(authorSong)
                    .font(.system(size: 15))
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

struct MusicListCellView_Previews: PreviewProvider {
    static var previews: some View {
        MusicListCellView(imageSong: "imagePlaceholder", titleSong: "Title Song", authorSong: "Author Song")
            .previewLayout(.sizeThatFits)
    }
}

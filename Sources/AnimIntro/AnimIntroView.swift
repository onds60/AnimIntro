//https://www.youtube.com/watch?v=o0fQC7JU-Ts
//  AnimIntroView.swift
//  AnimIntro
//
//  Created by Olivier NERON DE SURGY on 30/10/2023.
//

import SwiftUI

/// Vue avec animation de 2 secondes, pouvant servir d'écran de lancement
/// Cliquer sur le bouton "GO!" pour la fermer
///
/// - Parameters:
///   - titre: titre qui apparaît dans la vue avec une animation et un mask
///   - taille: taille de police du titre
///   - pictureName: nom du fichier de l'image (à placer dans le dossier Assets) qui est affichée sous le titre à la fin de l'animation avec le bouton "GO!"
///   - isButtonTapped: booléen de contrôle qui permet de fermer cette vue quand on le passe à true
public struct AnimIntroView: View {
    var titre: String
    var taille: CGFloat
    var pictureName: String
    @Binding var isButtonTapped: Bool
    
    @State private var fontSize: CGFloat = 0.0
    @State private var showButton = false
    
    let url = URL(string: "https://picsum.photos/id/34/3872/2592")
    
    public init(titre: String, taille: CGFloat, pictureName: String, isButtonTapped: Binding<Bool>) {
        self.titre = titre
        self.taille = taille
        self.pictureName = pictureName
        self._isButtonTapped = isButtonTapped
    }

    public var body: some View {
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(.white)
                        .overlay(
                            ProgressView()
                        )
                case .failure:
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                case .success(let returnedImage):
                    returnedImage
                        .resizable()
                        .scaledToFill()
                        .mask {
                            Text(titre.uppercased())
                                .font(.system(size: fontSize))
                                .bold()
                                .offset(y: -100)
                                .onAppear{
                                    withAnimation(.linear(duration: 2.0)) {
                                        fontSize = taille
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        showButton = true
                                    }
                                }
                        }
                default:
                    Image(systemName: "questionmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.orange)
                }
            }
            
            if showButton {
                Image(pictureName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 77)
                    .foregroundColor(.orange)
                
                Button(role: .cancel) {
                    withAnimation(.linear(duration: 0.5)) {
                        isButtonTapped = true
                    }
                } label: {
                    HStack{
                        Image("Logo", bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        
                        Text("GO!")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                    }
                    .padding(15)
                    .background(.green)
                    .cornerRadius(18)
                }
                .offset(y: 200)
            }
        }
    }
}

#Preview {
    AnimIntroView(titre: "titre", taille: 80, pictureName: "Logo", isButtonTapped: .constant(false))
}

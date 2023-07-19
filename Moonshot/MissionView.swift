//
//  MissionView.swift
//  Moonshot
//
//  Created by Danielle Lewis on 7/18/23.
//

import SwiftUI

struct MissionView: View {
    let mission: Mission
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let crew: [CrewMember]
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missions \(member.name)")
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.6)
                        .padding(.top)
                    
                    VStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)
                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        
                        Text(mission.description)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)
                        
                        Text("Crew")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(crew, id: \.role) { crewMember in
                                    NavigationLink {
                                        Text("Astronaut details")
                                    } label: {
                                        HStack {
                                            Image(crewMember.astronaut.id)
                                                .resizable()
                                                .clipped()
                                                .clipShape(Rectangle())
                                                .frame(width:150, height: 100)
                                                .overlay (
                                                    Rectangle()
                                                        .strokeBorder(crewMember.role == "Commander" ? .yellow : .white, lineWidth: 3)
                                                )
                                               
                                                
                                            VStack(alignment: .leading) {
                                                Text(crewMember.astronaut.name)
                                                    .foregroundColor(.white)
                                                    .font(crewMember.role == "Commander" ? .title2 : .headline)
                                                Text(crewMember.role)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    
    static var previews: some View {
        MissionView(mission: missions[1], astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}

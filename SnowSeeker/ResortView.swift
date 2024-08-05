//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Igor Florentino on 05/08/24.
//

import SwiftUI

struct ResortView: View {
	let resort: Resort
	@Environment(\.horizontalSizeClass) var horizontalSizeClass
	@Environment(\.dynamicTypeSize) var dynamicTypeSize
	@State private var selectedFacility: Facility?
	@State private var showingFacility = false
	@Environment(Favorites.self) var favorites

	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 0) {
				ZStack {
					Image(decorative: resort.id)
						.resizable()
						.scaledToFit()
					
					Text("Photo: \(resort.imageCredit)")
						.font(.caption)
						.padding(6)
						.background(Color.black.opacity(0.7))
						.foregroundColor(.white)
						.cornerRadius(10)
						.padding([.bottom, .trailing], 10)
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
				}
				
				HStack {
					if horizontalSizeClass == .compact && dynamicTypeSize > .large {
						VStack(spacing: 10) { ResortDetailsView(resort: resort) }
						VStack(spacing: 10) { SkiDetailsView(resort: resort) }
					} else {
						ResortDetailsView(resort: resort)
						SkiDetailsView(resort: resort)
					}				}
				.padding(.vertical)
				.background(.primary.opacity(0.1))
				Group {
					Text(resort.description)
						.padding(.vertical)
					
					Text("Facilities")
						.font(.headline)
					
					HStack {
						ForEach(resort.facilityTypes) { facility in
							Button {
								selectedFacility = facility
								showingFacility = true
							} label: {
								facility.icon
									.font(.title)
							}

						}
					}
					.padding(.vertical)
				}
				.padding(.horizontal)
			}
			Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
				if favorites.contains(resort) {
					favorites.remove(resort)
				} else {
					favorites.add(resort)
				}
			}
			.buttonStyle(.borderedProminent)
			.padding()
		}
		.navigationTitle("\(resort.name), \(resort.country)")
		.navigationBarTitleDisplayMode(.inline)
		.alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
		} message: { facility in
			Text(facility.description)
		}
	}
}


#Preview {
	ResortView(resort: .example)
		.environment(Favorites())
}

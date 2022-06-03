//
//  TestApp.swift
//  Test
//
//  Created by Ivan Ruiz Monjo on 3/6/22.
//

import ComposableArchitecture
import SwiftUI

@main
struct TestApp: App {
	var body: some Scene {
		WindowGroup {
			AppView(
				store: .init(
					initialState: .init(),
					reducer: appReducer.combined(
						with: updateUserReducer.optional().pullback(
							state: \.updateUser,
							action: /AppAction.updateUser,
							environment: { _ in .init() }
						)
					),
					environment: .init()
				)
			)
		}
	}
}

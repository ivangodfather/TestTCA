//
//  UpdateUserView.swift
//  Test
//
//  Created by Ivan Ruiz Monjo on 3/6/22.
//

import ComposableArchitecture
import SwiftUI

struct UpdateUserState: Equatable {
	var user: User?
	var username = ""
	var isLoading = false
}

enum UpdateUserAction: Equatable {
	case onAppear
	case usernameChanged(String)
	case updateUser
	case userUpdated(Result<User, AppError>)
}

struct UpdateUserEnvironment {}

let updateUserReducer = Reducer<UpdateUserState, UpdateUserAction, UpdateUserEnvironment> { state, action, environment in
	switch action {
	case .onAppear:
		state.username = state.user?.username ?? ""
		return .none
	case .usernameChanged(let username):
		state.username = username
		return .none
	case .updateUser:
		state.isLoading = true
		// Perform any environment.updateUserEffect(state.username).catchToEffect.map(userUpdated)
		let action = UpdateUserAction.userUpdated(.success(User(username: state.username)))
		return Effect(value: action)
	case .userUpdated(.success(let user)):
		return .none // we don't really need to do nothing here since the appReducer will dismiss me and set nil to my optional state
	case .userUpdated(.failure(let error)):
		state.isLoading = false
		return .none
	}
}

struct UpdateUserView: View {
	let store: Store<UpdateUserState, UpdateUserAction>

	var body: some View {
		WithViewStore(store) { viewStore in
			VStack {
				TextField(
					"Placerholder for username",
					text: viewStore.binding(
						get: \.username,
						send: UpdateUserAction.usernameChanged
					)
				)
				Button("Update user", action: { viewStore.send(.updateUser) })
			}
			.onAppear {
				viewStore.send(.onAppear)
			}
		}
	}
}

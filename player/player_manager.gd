extends Node


enum ControlScheme {WASD_SPACE, ARROWS_SHIFT, CONTROLLER1, CONTROLLER2, CONTROLLER3, CONTROLLER4}
enum Action {MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN, DASH_ACCEPT, BACK}


var players_control_schemes: Array[ControlScheme] = []
var players_characters: Array[CharacterData.Character] = []


func get_control_scheme_action(control_scheme: ControlScheme, button: Action) -> String:
	var control_scheme_action: String = ""
	
	match button:
		Action.MOVE_LEFT:
			control_scheme_action = "move_left_"
		Action.MOVE_RIGHT:
			control_scheme_action = "move_right_"
		Action.MOVE_UP:
			control_scheme_action = "move_up_"
		Action.MOVE_DOWN:
			control_scheme_action = "move_down_"
		Action.DASH_ACCEPT:
			control_scheme_action = "dash_"
	
	match control_scheme:
		ControlScheme.WASD_SPACE:
			control_scheme_action += "wasd"
		ControlScheme.ARROWS_SHIFT:
			control_scheme_action += "arrow"
		ControlScheme.CONTROLLER1:
			control_scheme_action += "controller1"
		ControlScheme.CONTROLLER2:
			control_scheme_action += "controller2"
		ControlScheme.CONTROLLER3:
			control_scheme_action += "controller3"
		ControlScheme.CONTROLLER4:
			control_scheme_action += "controller4"
	
	return control_scheme_action

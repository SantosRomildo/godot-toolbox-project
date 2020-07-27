tool
extends GridContainer

const ControlMenuAction = preload("res://scenes/ui/controls/ControlMenuAction.tscn")

export(String) var filter_actions:String = "^game_"

export var pretty_action_names = {
	"game_left" : "Left",
	"game_right" : "Right",
	"game_up" : "Up",
	"game_down" : "Down",
	"game_jump" : "Jump",
	"game_interact" : "Interact",
	"game_switch_demo" : "Switch Demo",
	"game_switch_skin" : "Switch Skin",
	"game_pause" : "Pause"
}

func _ready():
	add_actions()

func add_actions():
	
	# Clear prev children
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	# get settings
	var settingsControls = PersistenceMngr.get_state("settingsControls")
	
	# ready regex to filter actions
	var regex = RegEx.new()
	regex.compile(filter_actions)
	
	# add one ControlMenuAction per InputMap action
	for action_name in settingsControls.keys():
		
		# skip filtered actions
		if !regex.search(action_name):
			continue
		
		# create and add instance
		var menu_action_inst = ControlMenuAction.instance()
		menu_action_inst.init(action_name)
		add_child(menu_action_inst)
	
	var all_control_btns = get_tree().get_nodes_in_group("MenuControlButton")
	if all_control_btns.size() > 0:
		all_control_btns[0].grab_focus()

func reset_to_default():
	PersistenceMngr.set_state("settingsControls", StateMngr.default_options_controls)
	
	add_actions()
	
	
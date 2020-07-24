tool
extends Node

#############################################################
# CONSTANTS
onready var Screen = preload("res://scenes/screens/Screen.gd")

#############################################################
# STATE
var screen_history = []

#############################################################
# LIFECYCLE
func _ready():
	for child in get_tree().root.get_children():
		if child is Screen:
			screen_history = [child]
			break
	if screen_history.size() != 1:
		D.e(D.LogCategory.SCREEN_MANAGER, ["Initial scene is not a is not inherited from Screen.tscn!"])
	
	
#############################################################
# SWITCHING

# Switch to one of the Screens as specified in enum Config.Screen
func ___enter_screen(screen):
	# add scene
	get_tree().root.add_child(screen)
	
	# Debug log & Signal
	D.l(D.LogCategory.SCREEN_MANAGER, ["Switched screen to", screen.name])
	SignalMngr.emit_signal("screen_entered", screen)
	
	return true
	

func ___exit_screen():
	# remove scene
	get_tree().root.remove_child(screen_history[0])
	
	# Debug log & Signal
	D.l(D.LogCategory.SCREEN_MANAGER, ["Exited screen", screen_history[0].name])
	SignalMngr.emit_signal("screen_left", screen_history[0])
	
	return true

#############################################################
# INTERFACE
func reload_screen():
	___exit_screen()
	___enter_screen(screen_history[0])
	
func push_screen(screen_scene):
	
	var screen_inst = screen_scene.instance()
	
	if !screen_inst is Screen:
		D.e(D.LogCategory.SCREEN_MANAGER, ["Tried pushing Screen, but it is not a PackedScene, inherited from Screen.tscn"])
		return false
		
	#yield(cur_screen.get_node("Transition"), "on_closed")
	# Exit previous if existent
	___exit_screen()
	# Try changing scene
	if ___enter_screen(screen_inst):
		screen_history.push_front(screen_inst)
		return true
	return false

func pop_screen():
	if screen_history.size() <= 1:
		D.e(D.LogCategory.SCREEN_MANAGER, ["Tried popping Screen, but the screen_history buffer would have been empty"])
		return false
	
	___exit_screen()
	
	var last_screen = screen_history.pop_front()
	last_screen.queue_free()
	
	if ___enter_screen(screen_history[0]):
		return true

func exit_game():
	get_tree().quit()

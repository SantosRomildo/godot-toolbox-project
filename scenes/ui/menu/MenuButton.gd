extends Button

#############################################################
# CUSTOMIZATION

# Determines wether to switch the screen on click
export(bool) var pushes_screen = true
# Screen to switch to if pushes_screen==true
export(PackedScene) var screen_to_switch_to

# Determines wether to go to last screen on click
export(bool) var pops_screen = false

# Determines wether to quit the game on click
export(bool) var quits_game = false

# Determines wether to put initial focus on this button
export(bool) var grabs_focus = false

#############################################################
# LIFECYCLE
func _enter_tree():
	if grabs_focus:
		grab_focus()

func _process(delta):
	if pops_screen and Input.is_action_just_pressed("ui_cancel"):
		_on_MenuButton_pressed()
		
#############################################################
# CALLBACKS
func _on_MenuButton_pressed():
	if pops_screen:
		SoundMngr.play_ui_sound(SoundMngr.UI_BACK)
		ScreenMngr.pop_screen()
		
	if pushes_screen:
		SoundMngr.play_ui_sound(SoundMngr.UI_SELECT)
		ScreenMngr.push_screen(screen_to_switch_to)
		
	if quits_game:
		ScreenMngr.exit_game()

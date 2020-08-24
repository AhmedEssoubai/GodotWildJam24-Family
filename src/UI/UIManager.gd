extends Control


# - - - - - - Public properties

# Is the game paused
var paused := false setget set_paused;


# - - - - - - Nodes

# Time left label UI
onready var time_ui := $BreakTime;
# Pause UI panel
onready var pause_ui := $PausePanel;
# Animation player
#onready var animation := $Animation;
# Scene tree
onready var tree := get_tree();


func _unhandled_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		self.paused = !paused;
		tree.set_input_as_handled();
	elif event.is_action_pressed("reload"):
		assert(get_tree().reload_current_scene() == OK);


# Hide the ui
func hide_ui(hide) -> void:
	time_ui.visible = !hide;


# Set time left to break the gem to the UI
func set_time_left(time_left) -> void:
	var sec = clamp(int(time_left), 0, 99);
	var mil = clamp(int(fmod(time_left, float(sec)) * 100), 0, 99);
	if sec < 10:
		sec = "0" + String(sec);
	else:
		sec = String(sec);
	if mil < 10:
		mil = "0" + String(mil);
	else:
		mil = String(mil);
	time_ui.text = sec + " : " + mil;
	if time_left <= 5:
		time_ui.set("custom_colors/font_color", Color(0.9, 0.28, 0.18));
	else:
		time_ui.set("custom_colors/font_color", Color.white);


# Pause the game
func set_paused(value) -> void:
	paused = value;
	pause_ui.visible = value;
	tree.paused = value;


# Go back to the main menu
func main_menu():
	tree.paused = false;
	assert(get_tree().change_scene("res://src/Scenes/MainScreen.tscn") == OK);

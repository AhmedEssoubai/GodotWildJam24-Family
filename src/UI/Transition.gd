extends Node


# - - - - - - Signels

# When it focus on an object IN
signal on_ifocused;
# When the transition finished IN
signal on_ifinished;
# When it focus on an object OUT
signal on_ofocused;
# When the transition finished OUT
signal on_ofinished;
# When it focus on an object DEAD
signal on_dfocused;
# When the transition finished DEAD
signal on_dfinished;


# - - - - - - Exported Properties

# Other dark background color
export(NodePath) var OtherBackground;
# UI manager
export(NodePath) var UIMnager;


# - - - - - - Nodes

# Background dark color
onready var dark = $Dark;
# Sport light
onready var light = $Light;
# Animation player
onready var aplayer = $Player;
# Other dark background color
onready var odark = get_node(OtherBackground);
# The UI manager
onready var ui_manager := get_node(UIMnager);

# Called when the node enters the scene tree for the first time.
func _ready():
	Properties.player_dead = false;


# Start in transition [pos : focused node position]
func trans_in(pos):
	aplayer.play("In");
	display(true);
	light.global_position = pos;


# Start out transition [pos : focused node position]
func trans_out(pos):
	aplayer.play("Out");
	display(true);
	light.global_position = pos;
	ui_manager.hide_ui(true);


# Start dead transition [pos : focused node position]
func trans_dead(pos):
	light.texture = load("res://assets/vfx/dead.png");
	aplayer.play("Dead");
	display(true);
	light.global_position = pos;
	ui_manager.hide_ui(true);


# Show or hide transition tools
func display(enable):
	dark.visible = enable;
	light.visible = enable;
	if odark != null:
		odark.visible = enable;


# When the transition finished
func finished(type):
	display(false);
	match(type):
		0:
			emit_signal("on_ifinished");
		1:
			emit_signal("on_ofinished");
		2:
			emit_signal("on_dfinished");


# When it focus on an object
func focused(type):
	match(type):
		0:
			emit_signal("on_ifocused");
			ui_manager.hide_ui(false);
		1:
			emit_signal("on_ofocused");
		2:
			emit_signal("on_dfocused");

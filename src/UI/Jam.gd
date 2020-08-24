extends Control


# - - - - - - Nodes

# Animation player
onready var animation := $Animation;


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Show");


func _unhandled_input(event) -> void:
	if event is InputEventKey and event.pressed:
		next();


# Go to main menu
func next():
	assert(get_tree().change_scene("res://src/Scenes/MainScreen.tscn") == OK);

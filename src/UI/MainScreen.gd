extends Control


# - - - - - - Nodes

# Animation player
onready var animation := $Animation;


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Show");


func _unhandled_input(event) -> void:
	if event is InputEventKey and event.pressed:
		assert(get_tree().change_scene(Properties.get_next_level()) == OK);


# Play label idel animation
func idel():
	animation.play("Idel");

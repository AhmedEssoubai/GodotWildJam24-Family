extends Control


# - - - - - - Nodes

# Animation player
onready var animation := $Animation;
# Coins count
onready var count := $Count;


# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Show");
	count.text = String(Properties.get_coins_count()) + "/8";


func _unhandled_input(event) -> void:
	if event is InputEventKey and event.pressed:
		assert(get_tree().change_scene("res://src/Scenes/MainScreen.tscn") == OK);


# Play label idel animation
func idel():
	animation.play("Idel");

extends StaticBody2D


# - - - - - - Nodes

# Animation
onready var animation = $Animation;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false);
	set_physics_process(false);
	hide_block();


# Show
func show_block():
	animation.play("Show");


# Hide
func hide_block():
	animation.play("Hide");

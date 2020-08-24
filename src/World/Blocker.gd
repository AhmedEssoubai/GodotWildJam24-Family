extends StaticBody2D


# - - - - - - Nodes

# Block collision
onready var collision = $Collision;


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false;
	collision.disabled = true;


# Activate
func activate():
	visible = true;
	collision.disabled = false;

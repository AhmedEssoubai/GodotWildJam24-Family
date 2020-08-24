extends StaticBody2D


# - - - - - - Exported Properties

# Audio manager
export(NodePath) var AudioManager;


# - - - - - - Private Members

# Is the block moving
var _is_moving := false;


# - - - - - - Nodes

# Animation
onready var animation = $Animation;
# Rays to detect the player
onready var ray_left = $DetectPlayerLeft;
onready var ray_right = $DetectPlayerRight;
# Ground ray detection
onready var ray_ground = get_node("Danger/Ground");
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the character
onready var audio_player = $Audio;
# Danger collision
onready var dcollision = get_node("Danger/Collision");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !_is_moving and (ray_left.is_colliding() or ray_right.is_colliding()):
		_is_moving = true;
		animation.play("Move");
	dcollision.disabled = !ray_ground.is_colliding();


# When the block land on the ground
func land():
	audio_manager.play("land", audio_player);


# When the movement finished
func finished():
	_is_moving = false;

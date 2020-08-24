extends KinematicBody2D

enum Status {IDEL, MOVING, RETURNING}


# - - - - - - Exported Properties

# The acceleration of the block when moving
export(float) var Acceleration := 0.0;
# The max speed of the block when moving
export(float) var MaxSpeed := 0.0;
# Audio manager
export(NodePath) var AudioManager;


# - - - - - - Public Properties

# The velocity of the block
var motion := Vector2.ZERO;


# - - - - - - Private Members

# The status of the block
var _status = Status.IDEL;


# - - - - - - Nodes

# Animation
onready var animation = $Animation;
# Rays to detect the player
onready var ray_left = $DetectPlayerLeft;
onready var ray_right = $DetectPlayerRight;
# Ground ray detection
onready var ray_ground = $Ground;
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the character
onready var audio_player = $Audio;
# Timer to return to the original position
onready var timer = $Timer;
# Danger collision
onready var dcollision = get_node("Danger/Collision");


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _status == Status.IDEL and (ray_left.is_colliding() or ray_right.is_colliding()):
		_status = Status.MOVING;
		animation.play("Shake");
	dcollision.disabled = !ray_ground.is_colliding();


func _physics_process(_delta) -> void:
	var up = Vector2(0, -1);
	match _status:
		Status.MOVING:
			motion.y += Acceleration;
		Status.RETURNING:
			up = Vector2(0, 1);
			motion.y -= Acceleration / 8;
	motion = move_and_slide(motion, up);
	if is_on_floor():
		if _status == Status.MOVING:
			set_physics_process(false);
			audio_manager.play("land", audio_player);
			timer.start();
		else:
			_status = Status.IDEL;
			set_physics_process(false);


# Start moving
func move() -> void:
	motion = Vector2.ZERO;
	set_physics_process(true);


# Return back to the original position
func return_back():
	_status = Status.RETURNING;
	set_physics_process(true);

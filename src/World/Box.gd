extends KinematicBody2D

# - - - - - - Constants

# The defalut up direction
const UP = Vector2(0, -1);


# - - - - - - Exported Properties

# The friction
export(float) var SlowDown = 0.05;
# The gravity of the box
export(float) var Gravity = 15;


# - - - - - - Public Properties

# The velocity of the box
var motion := Vector2.ZERO;


# - - - - - - Nodes

# Animation
onready var animation = $Animation;
# Collision
onready var collision = $Collision;
# Area
onready var area = $PickUpArea;


func _physics_process(_delta) -> void:
	# Applay the movement to the box
	motion.y += Gravity;
	motion.x = lerp(motion.x, 0, SlowDown);
	motion = move_and_slide_with_snap(motion, Vector2(0, -1), UP);


# Play animation and stop movement when picked
func picked():
	animation.play("picked");
	set_physics_process(false);
	set_collision_layer_bit(1, false);


# Activate the physics process
func activate_process():
	set_physics_process(true);
	area.set_collision_mask_bit(1, true);


func collide_with_ground(_body):
	set_collision_layer_bit(1, true);
	area.set_collision_mask_bit(1, false);

extends KinematicBody2D


# - - - - - - Constants

# The defalut up direction
const UP = Vector2(0, -1);


# - - - - - - Exported Properties

# The max speed of the player movement
export(float) var MaxSpeed = 100;
# The gravity of the player
export(float) var Gravity = 25;
# The added value to reach the max speed movement
export(float) var Acceleration = 25;
# The gem friction
export(float) var Friction = 0.4;
# The value the player slow down with when want to stop
export(float) var Bounce = 0.8;
# The velocity of the gem
export(Vector2) var Velocity = Vector2.ZERO;


# - - - - - - Private Members

# The parent s
var _parent;


# Called when the node enters the scene tree for the first time.
func _ready():
	_parent = get_parent();
	pass # Replace with function body.



func _physics_process(delta):
	pass


# Delete the gem from the scene
func disabled():
	#_parent.remove_child(self);
	queue_free();


# Hide the gem
#func launch(velocity):
#	print(_parent);

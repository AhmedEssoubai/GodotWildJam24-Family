extends Node2D


# - - - - - - Exported Properties

# The target node path for the camera
export(NodePath) var Target;
# The left and top limit of the cameraman
export(Vector2) var LeftTop := Vector2.ZERO;
# The left and top limit of the cameraman
export(Vector2) var RightBottom := Vector2(1000, 1000);


# - - - - - - Nodes

# The target node to the camera
onready var target = get_node(Target);
# Camera 2d
onready var camera = $Camera;


# Start
func _ready():
	camera.limit_left = LeftTop.x;
	camera.limit_top = LeftTop.y;
	camera.limit_right = RightBottom.x;
	camera.limit_bottom = RightBottom.y;

# Update
func _physics_process(_delta):
	if target != null:
		set_global_position(target.global_position);

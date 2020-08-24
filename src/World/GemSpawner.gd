extends Node2D


# - - - - - - Exported Properties

# Audio manager
export(NodePath) var AudioManager;
# Transition path
export(NodePath) var Transition;
# Camera man
export(NodePath) var CameraMan;
# The start linear velocity for the spawned gem
export(Vector2) var Velocity := Vector2.ZERO;
# Player color
export(Color) var TextureColor;

# - - - - - - Private Members

# The gem the player holding
var _gem := load("res://src/World/Gem.tscn");


# - - - - - - Nodes

# Camera man
onready var camera_man = get_node(CameraMan);
# Transition
onready var transition = get_node(Transition);


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn(true);


# Spawn a gem
func spawn(highlight=false) -> void:
	var gem = _gem.instance();
	gem.AudioManager = AudioManager;
	add_child(gem);
	gem.throw(global_position, Velocity, TextureColor);
	get_parent().get_node("BreakTimer").update(gem);
	camera_man.target = gem;
	if highlight:
		transition.connect("on_ifocused", self, "to_active");
		transition.trans_in(global_position);


# Activate the gem
func to_active() -> void:
	camera_man.target.luanch();
	transition.disconnect("on_ifocused", self, "to_active");

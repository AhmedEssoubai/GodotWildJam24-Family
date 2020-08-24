extends RigidBody2D


# - - - - - - Exported Properties

# Audio manager
export(NodePath) var AudioManager;
# Transition path
export(NodePath) var Transition;
# Camera man
export(NodePath) var CameraMan;
# Break the gem on start
export(bool) var BreakOnStart := false;
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
# Breaking
onready var breaking = $Breaking;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BreakOnStart:
		cbreak(true);


# Break the container
func cbreak(highlight=false) -> void:
	if highlight:
		transition.connect("on_ifocused", self, "to_active");
		transition.trans_in(global_position);
	else:
		to_active();


# Activate the gem
func to_active() -> void:
	var gem = _gem.instance();
	gem.AudioManager = AudioManager;
	gem.throw(global_position, Velocity, TextureColor);
	get_parent().add_child(gem);
	get_parent().get_node("BreakTimer").update(gem);
	camera_man.target = gem;
	breaking.emitting = true;
	$Collision.disabled = true;
	$Sprite.visible = false;
	$Timer.start();
	#transition.disconnect("on_ifocused", self, "to_active");


# Remove when particles animation ends
func _on_Timer_timeout() -> void:
	queue_free();

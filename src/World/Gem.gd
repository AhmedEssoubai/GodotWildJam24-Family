extends RigidBody2D


# - - - - - - Exported Properties

# Audio manager
export(NodePath) var AudioManager;


# - - - - - - Private Members

# The texture color fo the gem
var _color := Color.white;


# - - - - - - Nodes

# Gem collision shape
onready var collision = $Collision;
# Gem light
onready var light = $Light;
# Gem sprite
onready var sprite = $Sprite;
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the gem
onready var audio_player = $Audio;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.modulate = _color;


# First luanch
func luanch() -> void:
	var v = linear_velocity;
	sleeping = false;
	linear_velocity = v;


# Throw the gem
func throw(pos, velocity, color) -> void:
	linear_velocity = velocity;
	global_position = pos;
	if sprite != null:
		sprite.modulate = color;
	_color = color;


# When holding time is over
func times_over() -> void:
	sleeping = true;
	collision.disabled = true;
	light.visible = false;


# Time to break the gem
func time_to_break() -> void:
	visible = false;


# Delete the gem from the scene
func free() -> void:
	queue_free();


# Freeze the gem in it's place
func freeze() -> void:
	sleeping = true;


# When collide with walls
func _on_Gem_body_entered(_body) -> void:
	audio_manager.play("collide", audio_player);


# Set x position to the sprite
func set_xpos(value) -> void:
	sprite.position.x = value;


# Get x position to the sprite
func get_xpos() -> float:
	return sprite.position.x;


# Set x sprite modulate
func set_color(value) -> void:
	sprite.modulate = value;


# Get x sprite modulate
func get_color() -> Color:
	return sprite.modulate;


# Get gloabl position
func get_gpos() -> Vector2:
	return global_position;


# Get gem color
func get_texture_color() -> Color:
	return _color;

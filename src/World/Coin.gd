extends Area2D


# - - - - - - Exported Properties

# Is the coin hidden
export(bool) var Hidden = false;
# Audio manager
export(NodePath) var AudioManager;
# The index of the coin
export(int) var Index;


# - - - - - - Nodes

# Area collision
onready var collision = $Collision;
# Animation player
onready var animation = $Animation;
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the coin
onready var audio_player = $Audio;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Properties.coins[Index]:
		queue_free();
	visible = !Hidden;
	#collision.disabled = Hidden;
	if !Hidden:
		animation.play("Idel");


# Show the coin
func show() -> void:
	#Hidden = false;
	visible = true;
	#collision.set_disabled(false);
	animation.play("Idel");


# Delete the coin
func picked() -> void:
	Properties.coins[Index] = true;
	queue_free();


# Player picking up the coin
func _on_Coin_body_entered(_body) -> void:
	animation.play("Pick");
	collision.disabled = true;
	audio_manager.play("coin", audio_player);

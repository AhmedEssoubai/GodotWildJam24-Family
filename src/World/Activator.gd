extends Area2D


# - - - - - - Signels

# When it activated or deactivated
signal on_activated_changed;


# - - - - - - Exported Properties

# Audio manager
export(NodePath) var AudioManager;


# - - - - - - Private Members

# Is it active
var _is_active := false;
# The count of objects bushs this activator
var _activators_count := 0;


# - - - - - - Nodes

# Animation
onready var animation = $Animation;
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the character
onready var audio_player = $Audio;


# When an object bush or leave
func activate(_body, active):
	if _is_active == active:
		if _is_active:
			_activators_count += 1;
		return;
	_is_active = active;
	if active:
		_activators_count += 1;
		animation.play("Activate");
		audio_manager.play("pick", audio_player);
		emit_signal("on_activated_changed", true);
	else:
		_activators_count -= 1;
		if _activators_count <= 0:
			_activators_count = 0;
			animation.play_backwards("Activate");
			emit_signal("on_activated_changed", false);

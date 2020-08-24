extends StaticBody2D


# - - - - - - Exported Properties

# Audio manager
export(NodePath) var AudioManager;


# - - - - - - Private Members

# Is it active
var _is_active := false;


# - - - - - - Nodes

# Animation
onready var animation = $Animation;
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the character
onready var audio_player = $Audio;


# When the player walk on the trap
func falling(body):
	if _is_active:
		return;
	_is_active = true;
	animation.play("Fall");
	#audio_manager.play("land", audio_player);


# When the movement finished
func finished():
	_is_active = false;

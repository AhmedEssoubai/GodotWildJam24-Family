extends Node2D


# - - - - - - Exported Properties

# Time between each switch
export(float) var TimeBetween := 0.0;
# Audio manager
export(NodePath) var AudioManager;
# Hidden red blocks
export(Array, NodePath) var RedBlocks;
# Hidden blue blocks
export(Array, NodePath) var BlueBlocks;


# - - - - - - Private Members

# Is it active
var _is_active := false;
# Is the turn on the blue or red to show
var _red = false;


# - - - - - - Nodes

# Hidden red blocks
onready var red_blocks := [];
# Hidden blue blocks
onready var blue_blocks := [];
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the character
onready var audio_player = $Audio;
# Timer to return to the original position
onready var timer = $Timer;


# Called when the node enters the scene tree for the first time.
func _ready():
	for p in RedBlocks:
		red_blocks.append(get_node(p));
	for p in BlueBlocks:
		blue_blocks.append(get_node(p));


func switch():
	hs_blocks(red_blocks, _red);
	hs_blocks(blue_blocks, !_red);
	_red = !_red;


# Hide or show blocks
func hs_blocks(blocks, show):
	for b in blocks:
		if show:
			b.show_block();
		else:
			b.hide_block();


# When activator status changes
func activate(active):
	if _is_active == active:
		return;
	_is_active = active;
	if active:
		_red = !_red;
		switch();
		timer.start(TimeBetween);
	else:
		timer.stop();
		if _red:
			hs_blocks(blue_blocks, false);
		else:
			hs_blocks(red_blocks, false);


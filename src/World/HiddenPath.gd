extends TileMap

# - - - - - - Constants

# The speed of revealing animation
const REVEALING_SPEED := 1.5;


# - - - - - - Private Members

# The entrance
var _reveal_area := load("res://src/World/PathRevealArea.tscn");
# Is the path revealed
var _revealed := false;

# - - - - - - Exported Properties

# The position of the reveal area
export(Array, Vector2) var EntrancesPosition := [Vector2.ZERO];
# The size of the reveal area
export(Array, Vector2) var EntrancesSize := [Vector2(0.2, 0.8)];
# An item in the hidden path
export(NodePath) var HiddenItem;
# Audio manager
export(NodePath) var AudioManager;


# - - - - - - Nodes

# Entrance
onready var reveal_areas = [];
# An item in the hidden path
onready var hidden_item = get_node(HiddenItem);
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the path
onready var audio_player = $Audio;


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false);
	for i in range(EntrancesPosition.size()):
		var ra = _reveal_area.instance();
		ra.scale = EntrancesSize[i];
		ra.global_position = EntrancesPosition[i];
		add_child(ra);
		ra.connect("body_entered", self, "reveal");
		reveal_areas.append(ra);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if modulate.a > 0:
		modulate.a -= delta * REVEALING_SPEED;
	else:
		queue_free();


# When the player/gem get entered
func reveal(_body):
	print("_revealed");
	if _revealed:
		return;
	_revealed = true;
	set_process(true);
	if hidden_item != null:
		hidden_item.show();
	audio_manager.play("secret", audio_player);

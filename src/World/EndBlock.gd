extends StaticBody2D

# - - - - - - Constants

# Block center point
const CENTER := Vector2.ZERO;
# The mass of the gem, for the animation
const GEM_MASS := 40;

# - - - - - - Signels

# When dragging a gem
signal on_dragging;
# When the block attached with a gem
signal on_complete;


# - - - - - - Exported Properties

# The max speed of the player movement
export(float) var MaxSpeed = 10;
# The added value to reach the max speed movement
export(float) var Acceleration = 0.2;
# Block color
export(Color) var TextureColor;
# Is the block active or not
export(bool) var IsActive := false;
# Is it the last block to go to the next level
export(bool) var IsLast := false;
# Transition path
export(NodePath) var Transition;
# Audio manager
export(NodePath) var AudioManager;


# - - - - - - Private Members

# Is the player dead or not
var _is_dragging := false;
# Gem velocity when it's dragged
var _motion := Vector2(0, 20);


# - - - - - - Nodes

# Gem
onready var gem = $Gem;
# Waves particle system
onready var waves = $Waves;
# Transition
onready var transition = get_node(Transition);
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the block
onready var audio_player = $Audio;


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Sprite.modulate = TextureColor;
	$Effect.modulate = Color(TextureColor.r, TextureColor.g, TextureColor.b, 0.3);
	waves.modulate = Color(TextureColor.r, TextureColor.g, TextureColor.b, waves.modulate.a);


func _physics_process(delta):
	if _is_dragging:
		var dist = CENTER - gem.get_position();
		var l = GEM_MASS * MaxSpeed / dist.length_squared();
		var a = dist.angle();
		_motion += Vector2(cos(a) * l, sin(a) * l);
		l = dist.length();
		if l < 3:
			_is_dragging = false;
			gem.set_rotation(0);
			gem.set_position(CENTER);
			if IsLast and !Properties.player_dead:
				transition.connect("on_ofocused", self, "_attach");
				transition.connect("on_ofinished", self, "_next");
				transition.trans_out(global_position);
			else:
				_attach();
			return;
		elif l < 10:
			_motion *= 0.9;
		gem.position += _motion * delta;
		gem.set_rotation(-a);


# When the gem enter the drag area
func _on_DragArea_body_entered(body):
	if !IsActive:
		return;
	emit_signal("on_dragging");
	if body.get_collision_layer_bit(0):
		if body.IsIdel:
			return;
		var g = body.get_node("Control");
		g.sleep();
		gem.global_position = g.global_position;
		gem.modulate = TextureColor;
	else:
		gem.global_position = body.global_position;
		gem.modulate = TextureColor;
		gem.set_rotation(body.get_rotation());
		body.free();
	audio_manager.play("drag", audio_player);
	gem.visible = true;
	_is_dragging = true;
	IsActive = false;


# Attach the gem with block
func _attach():
	$Animation.play("Attached");


# The gem placed
func _placed():
	if IsLast:
		audio_manager.stop_music(false);
	emit_signal("on_complete");
	audio_manager.play("placed", audio_player);


# Go to the next level
func _next():
	if !Properties.player_dead:
		Properties.next_level();
		assert(get_tree().change_scene(Properties.get_next_level()) == OK);


# Activate the block
func activate():
	IsActive = true;

extends Node

# - - - - - - Constants

# The speed of shaking
const SHAKING_SPEED := 40;
# Time to start shaking the gem
const STIME := 10;

# - - - - - - Exported Properties

# The max time before the gem break [with seconds]
export(float) var MaxTime = 20;
# The min time before the gem break [with seconds]
export(float) var MinTime = 12;
# The subtracted value from min time for each time update
export(float) var SubTime = 1;
# Gem explosion particles system path
export(NodePath) var GemExplosion;
# Transition path
export(NodePath) var Transition;
# UI manager
export(NodePath) var UIMnager;
# Audio manager
export(NodePath) var AudioManager;
# Audio player
export(NodePath) var AudioPlayer;


# - - - - - - Public Properties

# The gem sprite
var gem;


# - - - - - - Private Members

# The time left to break the gem
var _time_left := 0.0;
# The current max value
var _max_time := 0.0;
# The current min value
var _min_time := 0.0;
# Gem sprite start position
var _gem_spos := 0.0;
# The current value of shaking
var _shaking_value := 0.0;


# - - - - - - Nodes

# Gem explosion particles system
onready var gem_exp := get_node(GemExplosion);
# Transition path
onready var transition := get_node(Transition);
# The UI manager
onready var ui_manager := get_node(UIMnager);
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player
onready var audio_player = get_node(AudioPlayer);


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false);
	_max_time = MaxTime;
	_min_time = clamp(MaxTime - SubTime, MinTime, _max_time);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_time_left -= delta;
	if _time_left <= 0:
		gem.set_xpos(_gem_spos);
		gem.times_over();
		set_process(false);
		_time_left = 0;
		transition.connect("on_dfocused", self, "break_gem");
		transition.connect("on_dfinished", self, "restart");
		transition.trans_dead(gem.global_position);
	elif _time_left < STIME:
		_shaking_value += delta;
		gem.set_color(Color(lerp(gem.get_color().r, 0.9, delta / 3), lerp(gem.get_color().g, 0.28, delta / 3), lerp(gem.get_color().b, 0.18, delta / 3)));
		gem.set_xpos(gem.get_xpos() + sin(_shaking_value * SHAKING_SPEED) * ((STIME - _time_left) / STIME));
	set_time_to_ui();


# Reset the timer
func update(g):
	if gem != null:
		gem.set_xpos(_gem_spos);
	gem = g;
	_gem_spos = gem.get_xpos();
	_time_left = rand_range(_min_time, _max_time);
	_max_time = clamp(_max_time - SubTime, MinTime, MaxTime);
	_min_time = clamp(_min_time - SubTime, MinTime, _max_time);
	set_time_to_ui();
	set_process(true);


# Break the gem
func break_gem():
	gem_exp.global_position = gem.get_gpos();
	gem_exp.set_emitting(true);
	gem.time_to_break();
	audio_manager.play("break", audio_player);


# Restart the level
func restart():
	audio_manager.save();
	assert(get_tree().reload_current_scene() == OK);


# Show the time left in the UI
func set_time_to_ui():
	if ui_manager == null:
		return;
	ui_manager.set_time_left(_time_left);


# When the gem reach the end block or player dead
func freeze():
	set_process(false);

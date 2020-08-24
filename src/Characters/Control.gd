extends Sprite


# - - - - - - Exported Properties

# The power / speed the gem will be thrown
export(float) var ThrowPower = 200;


# - - - - - - Public Properties

# The velosity of the player
#var motion := Vector2.ZERO;


# - - - - - - Private Members

# The gem the player holding
var _gem := load("res://src/World/Gem.tscn");
# The thrown gem
var _tgem;
# Gem texture color
var _texture_color;


# - - - - - - Nodes

# The conected character
onready var player = get_parent();
# Pick up area
onready var pickup_area = get_parent().get_node("PickUpArea").get_node("Collision");


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = !player.IsIdel;
	set_process_input(visible);

func _input(event) -> void:
	if event.is_action_pressed("throw"):
		var gem = _gem.instance();
		var dir = (get_global_mouse_position() - global_position).normalized();
		dir.y -= 0.8;
		gem.AudioManager = player.AudioManager;
		gem.throw(global_position, dir * ThrowPower, _texture_color);
		get_parent().get_parent().add_child(gem);
		player.get_parent().get_node("BreakTimer").update(gem);
		player.camera_man.target = gem;
		_tgem = gem;
		sleep();
		player.audio_manager.play("throw", player.audio_player);


func _process(_delta):
	if _tgem == null || (_tgem.global_position - global_position).length() > 100:
		pickup_area.disabled = false;
		set_process(false);

func _on_PickUpArea_body_entered(body) -> void:
	if body.collision_layer == 4:
		player.dead();
		set_process_input(false);
		pickup_area.disabled = true;
		visible = false;
	else:
		modulate = body.get_texture_color();
		_texture_color = modulate;
		body.free();
		visible = true;
		set_process_input(true);
		player.wake_up();
		player.get_parent().get_node("BreakTimer").update(self);


# When holding time is over
func times_over() -> void:
	set_process_input(false);
	player.freeze();


# Time to break the gem
func time_to_break() -> void:
	visible = false;


# When the player hold another object or throw it
func other_package(holding) -> void:
	if holding:
		if is_processing_input():
			position.y -= 12;
		set_process_input(false);
	else:
		if !is_processing_input():
			position.y += 12;
			if position.y > -8:
				position.y = -8;
		set_process_input(true);


# When the player looses the gem will go to sleep
func sleep() -> void:
	visible = false;
	set_process_input(false);
	player.sleep();
	pickup_area.disabled = true;
	set_process(true);


# Set x position to the sprite
func set_xpos(value) -> void:
	position.x = value;


# Get x position to the sprite
func get_xpos() -> float:
	return position.x;


# Set x sprite modulate
func set_color(value) -> void:
	modulate = value;


# Get x sprite modulate
func get_color() -> Color:
	return modulate;


# Get gloabl position
func get_gpos() -> Vector2:
	return global_position;

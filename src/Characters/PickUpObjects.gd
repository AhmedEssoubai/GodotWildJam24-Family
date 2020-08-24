extends Player

# - - - - - - Signals
signal on_holder_changed(holding);


# - - - - - - Exported Properties

# The given position to the payload
export(Vector2) var HoldingPosition := Vector2.ZERO;
# The size of the collision when holding payload
export(Vector2) var CollisionScale := Vector2.ZERO;
# The power / speed the payload will be thrown
export(float) var ThrowPower = 200;
# Pick up text UI
export(NodePath) var PickUi;
# Pick up animation
export(NodePath) var PickAnimation;


# - - - - - - Private Members

# The count of objects in reach and the player can pick up
var _pickups_in_range := 0;
# The target object the player will pick when pressing PickUp action
var _target;
# Is the player currently holding an object
var _is_holding_obj := false;
# The object the player currently holding
var payload;
# The start collision scale
var _start_scollision := Vector2.ZERO;
# The start collision position
var _start_pcollision := Vector2.ZERO;


# - - - - - - Nodes

# Pick up text UI
onready var pick_ui = get_node(PickUi);
# Pick up animation
onready var pick_animation = get_node(PickAnimation);


# When it's enters the scene tree for the first time
func _ready() -> void:
	_start_pcollision = collision.position;
	_start_scollision = collision.scale;
	jump_audio = "heavy_jump";


func _physics_process(_delta) -> void:
	if _is_holding_obj:
		# Move the payload with player velocity
		#payload.move_and_slide_with_snap(motion, Vector2(0, -1), UP);
		payload.global_position = global_position + HoldingPosition;


# Input event
func _input(event) -> void:
	if !IsIdel and !_is_dead and !Properties.player_dead:
		if event.is_action_pressed("pickup"):
			var retargeted = payload;
			pick_animation.play_backwards("Show");
			if  _pickups_in_range > 0 and _target != null:
				if _is_holding_obj:
					retargeted = payload;
					_pickups_in_range += 1;
					_throw_obj(Vector2.ZERO, true);
				_pickup_obj();
			elif _is_holding_obj:
				retargeted = payload;
				_throw_obj(Vector2.ZERO, false);
			if retargeted != null:
				_target = retargeted;
				pick_ui.set_global_position(_target.global_position - Vector2(0, 16));
				pick_animation.play("Show");
			if payload != null:
				audio_manager.play("pick", audio_player);
		elif event.is_action_pressed("throw") and _is_holding_obj:
			var dir = (get_global_mouse_position() - global_position).normalized();
			dir.y *= 0.45;
			dir.y -= 0.3;
			_throw_obj(dir * ThrowPower, false);
			audio_manager.play("throw", audio_player);


# A big bug will happen if the area it self is the target object
func _on_PickUpArea_area_entered(area) -> void:
	if area.get_parent() == payload:
		return;
	_target = area.get_parent();
	_pickups_in_range += 1;
	if !IsIdel:
		pick_ui.set_global_position(_target.global_position - Vector2(0, 16));
		pick_animation.play("Show");


# Another bug will happen if an pickup area inside of area. 
# ->1->2-> after of the inside one and still the first in range with this code it will pick the 2 even if not in range
func _on_PickUpArea_area_exited(area) -> void:
	if area.get_parent() == payload:
		return;
	_pickups_in_range -= 1;
	if _pickups_in_range <= 0:
		_target = null;
		_pickups_in_range = 0;
		if !IsIdel:
			pick_animation.play_backwards("Show");


# Pick up the payload
func _pickup_obj() -> void:
	payload = _target;
	_pickups_in_range -= 1;
	_target = null;
	payload.picked();
	if !_is_holding_obj:
		_is_holding_obj = true;
		emit_signal("on_holder_changed", _is_holding_obj);
		collision.scale = CollisionScale;
		collision.position = Vector2.ZERO;
	payload.global_position = global_position + HoldingPosition;


# Throw up the payload
func _throw_obj(power, holding) -> void:
	payload.motion = power;
	payload.activate_process();
	payload = null;
	if _is_holding_obj != holding:
		emit_signal("on_holder_changed", holding);
		collision.scale = _start_scollision;
		collision.position = _start_pcollision;
	_is_holding_obj = holding;

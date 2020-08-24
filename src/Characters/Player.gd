extends KinematicBody2D
class_name Player

# - - - - - - Constants

# The defalut up direction
const UP = Vector2(0, -1);


# - - - - - - Signels

# When the player dead
signal on_dead;


# - - - - - - Exported Properties

# The max speed of the player movement
export(float) var MaxSpeed = 100;
# The power of the dash
export(float) var DashPawer = 400;
# The time of the dash [sec]
export(float) var DashTime = 0.1;
# The gravity of the player
export(float) var Gravity = 15;
# The added value to reach the max speed movement
export(float) var Acceleration = 25;
# The value the player slow down with when want to stop
export(float) var SlowDown = 0.1;
# The jump hieght of the player
export(float) var JumpHeight = 300;
# The direction the player go to
export(int) var Direction = 0;
# The time the jump action will be active after pressing jump
export(float) var OnJumpTime = 0.13;
# The time the player will still grouned after his physicly not
export(float) var OnGroundTime := 0.2;
# The time the player runs with his max speed
export(float) var MaxSpeedTime := 2.0;
# Is the player is idel or not [true = can not be controlled]
export(bool) var IsIdel := true;
# Can the player dash
export(bool) var CanDash := false;
# How many times the player can jump (from the first on the grounth to n-1 in the air)
export(int) var JumpTimes := 1;
# Player sprite sheet
export(Texture) var SpriteTexture;
# Player color
export(Color) var TextureColor;
# Audio manager
export(NodePath) var AudioManager;
# Transition path
export(NodePath) var Transition;
# Camera man
export(NodePath) var CameraMan;


# - - - - - - Public Properties

# The velocity of the player
var motion := Vector2.ZERO;
# Jump sound name
var jump_audio := "light_jump";

# Is the player frozen
#var is_frozen := false;


# - - - - - - Private Members

# Is the player dead or not
var _is_dead := false;
# Is the player currently dashing
var _is_dashing := false;
# Is dash is disabled [When the player use it]
var _is_dash_disabled := false;
# The time left to jump
var _on_jump_time_left := 0.0;
# The time left the player will not be grounded
var _on_ground_time_left := 0.0;
# The number of objects that slows the player
var _sd_object_count := 0;
# The current slow down value
var _slowing_value := 0.0;
# The time left the player running with his maximal speed
var _max_speed_time_left := 0.0;
# Is the player jumping
#var _is_jumping := false;
# Is the player on the floor
var _is_on_floor := true;
# Is the player just land on the ground
var _just_land := false;
# Is the player just land on the ground
var _just_jumped := false;
# Is the player just wake up
var _just_wakeup := false;
# Time left to end the dash
var _dash_time_left := 0.0;
# Time to creat a dash shadow
var _dash_shadow_time := 0.0;
# How many times jumps left for the player to fail
var _jump_times_left := 0;


# - - - - - - Nodes

# Sprite
onready var sprite = $Sprite;
# Sprite
onready var light = $Light;
# Animation
onready var animation = $Animation;
# Squash Animation
onready var squash_animation = $SquashAnimation;
# Dash shadow
var _dash_shadow = load("res://src/Characters/Shadow.tscn");
# The player collision
onready var collision = $Collision;
# Sleep particale system
onready var zzz = $zzz;
# Audio manager
onready var audio_manager = get_node(AudioManager);
# Audio player of the character
onready var audio_player = $Audio;
# Camera man
onready var camera_man = get_node(CameraMan);


# When it's enters the scene tree for the first time
func _ready() -> void:
	_jump_times_left = JumpTimes;
	sprite.texture = SpriteTexture;
	zzz.modulate = TextureColor;
	if IsIdel:
		animation.play("Idel");
		light.visible = false;
	else:
		animation.play("Stand");
		light.visible = true;
	zzz.set_emitting(IsIdel);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if !_is_dead and !Properties.player_dead:
		# Apply the gravity
		if !_is_dashing:
			motion.y += Gravity;
		# Handle the jump
		var isJumping = _handle_jumping(delta);
		# Handle dash
		if CanDash and !IsIdel:
			_handle_dash(delta);
		# Handle the movement
		var isRunning = _handle_movement(isJumping);
		# Update the sprite and animation of the player
		_update_sprite_and_animation(isJumping, isRunning);
		# If is dashing : Set no movement direction after setting the sprite direction to dash dir
		if _is_dashing:
			Direction = 0;


func _physics_process(_delta) -> void:
	if !_is_dead:
		# Applay the movement to the player
		motion = move_and_slide_with_snap(motion, Vector2(0, -1), UP);


# Sprite and animation and audio
func _update_sprite_and_animation(isJumping, isRunning) -> void:
	# Change the sprite direction
	if Direction == 1:
		sprite.flip_h = false;
	elif Direction == -1:
		sprite.flip_h = true;
	
	if Direction != 0:
		zzz.position.x = Direction * abs(zzz.position.x);
	
	# Change the animation
	if IsIdel:
		animation.play("Idel");
	elif isJumping:
		if motion.y > 0:
			animation.play("Jump");
		else:
			animation.play("Land");
	elif isRunning:
		animation.play("Run");
	else:
		animation.play("Stand");
	if _just_jumped:
		_just_jumped = false;
		squash_animation.play("Jump");
		audio_manager.play(jump_audio, audio_player);
	elif _just_land:
		_just_land = false;
		squash_animation.play("Land");
		if _just_wakeup:
			_just_wakeup = false;
		else:
			audio_manager.play("land", audio_player);


# Handle the jumping
func _handle_jumping(delta) -> bool:
	# Check if the player grounded
	if is_on_floor():
		#_can_double_jump = true;
		_on_ground_time_left = OnGroundTime;
		_is_dash_disabled = false;
		if !_is_on_floor:
			_just_land = true;
			_jump_times_left = JumpTimes;
		_is_on_floor = true;
	
	# Check if the player press jump
	if Input.is_action_just_pressed("ui_up") and !IsIdel and !_is_dashing:
		_on_jump_time_left = OnJumpTime;
	
	# Check if the player want to jump
	if _on_jump_time_left > 0 and _jump_times_left > 0:
		_on_ground_time_left = 0;
		_on_jump_time_left = 0;
		motion.y = -JumpHeight;
		_just_jumped = true;
		_jump_times_left -= 1;
		_is_on_floor = false;
	
	# Check if the player left the ground with the timer
	if _on_ground_time_left <= 0:
		if Input.is_action_just_released("ui_up") and motion.y < -JumpHeight / 2:
			motion.y = -JumpHeight / 2;
		if _is_on_floor:
			_jump_times_left -= 1;
		_is_on_floor = false;
	
	# The jump action goes with time
	if _on_jump_time_left > 0:
		_on_jump_time_left -= delta;
	
	# On ground goes with time
	if _on_ground_time_left > 0:
		_on_ground_time_left -= delta;

	return !_is_on_floor;


# Handle the movement of the player
func _handle_movement(isJumping) -> bool:
	if _is_dashing:
		return false;
	# Get movement direction
	if !IsIdel:
		Direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");

	# Is the player running
	var isRunning = Direction != 0;

	# Save the acceleration of movement to slow it down if the player jumping
	var _acceleration = Acceleration;

	# Calcul the slow down movement and local acceleration
	if (isJumping):
		_acceleration = _acceleration / 1.5;
		if !isRunning:
			motion.x = lerp(motion.x, 0, SlowDown / 2);
	else:
		if !isRunning:
			motion.x = lerp(motion.x, 0, SlowDown);
	
	# Calcul the speed movement of the player
	if Direction > 0:
		motion.x = min(motion.x + Acceleration, MaxSpeed);
	elif Direction < 0:
		motion.x = max(motion.x - Acceleration, -MaxSpeed);
	return isRunning;


# Handle the dash of the player
func _handle_dash(delta) -> void:
	if _is_dashing:
		if _dash_time_left < 0 or motion == Vector2.ZERO:
			_is_dashing = false;
			return;
		_dash_time_left -= delta;
		if _dash_time_left >= _dash_shadow_time:
			_dash_shadow_time += DashTime / 3.1;
			var ds = _dash_shadow.instance();
			ds.set_props(sprite.texture, sprite.frame, position);
			get_parent().add_child(ds);
	elif Input.is_action_pressed("dash") and !_is_dash_disabled:
		#var hdir = round(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"));
		#var vdir = round(Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"));
		#if hdir + vdir == 0:
		var hdir = 1;
		if sprite.flip_h:
			hdir = -1;
		motion = Vector2(hdir * DashPawer, 0);
		Direction = hdir;
		_is_dashing = true;
		_is_dash_disabled = true;
		_dash_time_left = DashTime;
		_dash_shadow_time = DashTime / 3.1;


# The player hit an enemy of danger thing
func dead() -> void:
	camera_man.target = self;
	emit_signal("on_dead");
	zzz.set_emitting(false);
	_is_dead = true;
	collision.set_deferred("disabled", true);
	var trans = get_node(Transition);
	trans.connect("on_dfocused", self, "dead_particles");
	trans.connect("on_dfinished", self, "restart");
	trans.trans_dead(global_position);
	Properties.player_dead = true;
	light.visible = false;


# Luanch dead particles
func dead_particles():
	$DeadParticles.emitting = true;
	sprite.visible = false;
	audio_manager.play("game_over", audio_player);


# Luanch dead particles
func restart():
	audio_manager.save();
	assert(get_tree().reload_current_scene() == OK);


# The character can be controlled
func wake_up() -> void:
	camera_man.target = self;
	motion.y = -JumpHeight / 2;
	IsIdel = false;
	light.visible = true;
	zzz.set_emitting(false);
	zzz.visible = false;
	audio_manager.play("wake", audio_player);
	_just_wakeup = true;


# The character can't be controlled
func sleep() -> void:
	Direction = 0;
	_on_jump_time_left = 0;
	IsIdel = true;
	light.visible = false;
	zzz.set_emitting(true);
	zzz.visible = true;


# Freeze the player
func freeze() -> void:
	#is_frozen = true;
	animation.stop(false);
	set_process(false);
	set_physics_process(false);
	light.visible = false;


# When the player collide with dangerous area
func _on_DeadArea_area_entered(_area) -> void:
	dead();


# When the player collide with dangerous body
func _on_DeadArea_body_entered(_body) -> void:
	dead();


# Play animation and stop movement when picked
func picked():
	squash_animation.play("Jump");
	set_physics_process(false);


# Activate the physics process
func activate_process():
	set_physics_process(true);

extends Sprite

# - - - - - - Constants

# The speed of fading
const FADING_SPEED := 2;


# Fading
func _process(delta) -> void:
	if modulate.a > 0:
		modulate.a -= delta * FADING_SPEED;
	else:
		queue_free();


# Set the shadow texture and fram
func set_props(texture, frame, pos) -> void:
	self.texture = texture;
	self.frame = frame;
	self.position = pos;

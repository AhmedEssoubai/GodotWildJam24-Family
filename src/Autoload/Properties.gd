extends Node


# The last position of background music
var music_pos := 0.0;
# Is there a player deads
var player_dead := false;
# The coins the player gather
var coins := [false, false, false, false, false, false, false, false];
# The current level
var level := 1;


func next_level():
	if level < 5:
		level += 1;


func get_next_level() -> String:
	if level == 5:
		return "res://src/Scenes/Thanks.tscn";
	return "res://src/Scenes/Level" + String(level) + ".tscn";


func get_coins_count() -> int:
	var n = 0;
	for c in coins:
		if c:
			n += 1;
	return n; 

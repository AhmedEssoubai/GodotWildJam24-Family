extends Node


# - - - - - - Exported Properties

# The background music
export(Resource) var Music;
# SFXs sources
export(Array, Resource) var AudioSources;
# SFXs names
export(Array, String) var AudioNames;


# - - - - - - Nodes

# Audio player
onready var audio_player = $Audio;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Music != null:
		audio_player.stream = Music;
		audio_player.play(Properties.music_pos);


# Play an audio
func play(name, mplayer) -> bool:
	var index = _get_audio_index(name);
	if index == -1:
		return false;
	mplayer.stream = AudioSources[index];
	mplayer.play();
	return true;


# Search for an audio
func _get_audio_index(name) -> int:
	var s = clamp(AudioNames.size(), 0, AudioSources.size());
	for i in range(s):
		if name == AudioNames[i]:
			return i;
	return -1;


# Stop the background music with the option of saving the current position to play from it next time
func stop_music(save):
	if save:
		Properties.music_pos = audio_player.get_playback_position();
	else:
		Properties.music_pos = 0;
	audio_player.stop();


# Save the current position to play from it next time
func save():
	Properties.music_pos = audio_player.get_playback_position();

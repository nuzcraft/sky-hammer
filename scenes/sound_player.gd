extends Node

# music
const MENU_LOOP = preload("res://assets/sounds/Of Far Different Nature - Tribal (CC0).wav")
const BATTLE_LOOP = preload("res://assets/sounds/BattleLoop2.ogg")
#effects
const CLICK_1 = preload("res://assets/sounds/click1.ogg")
const ROLLOVER_1 = preload("res://assets/sounds/rollover1.ogg")
const ROLLOVER_2 = preload("res://assets/sounds/rollover2.ogg")

const IMPACT_PLANK = preload("res://assets/sounds/impactPlank_medium_000.ogg")
const IMPACT_PUNCH = preload("res://assets/sounds/impactPunch_medium_000.ogg")

@onready var audio_players: Node = $AudioPlayers
@onready var music_players: Node = $MusicPlayers

func play_sound(sound):
	for audioStreamPlayer: AudioStreamPlayer in audio_players.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
			
func play_music(sound):
	for audioStreamPlayer: AudioStreamPlayer in music_players.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.volume_db = 0
			audioStreamPlayer.play()
			break
			
func stop_music():
	for audioStreamPlayer: AudioStreamPlayer in music_players.get_children():
		if audioStreamPlayer.playing:
			audioStreamPlayer.stop()
			
func transition_music(sound):
	var playingStream: AudioStreamPlayer
	for audioStreamPlayer: AudioStreamPlayer in music_players.get_children():
		if audioStreamPlayer.playing:
			playingStream = audioStreamPlayer
			break
	var notPlayingStream: AudioStreamPlayer
	for audioStreamPlayer: AudioStreamPlayer in music_players.get_children():
		if not audioStreamPlayer == playingStream:
			notPlayingStream = audioStreamPlayer
			break
	notPlayingStream.volume_db = -80
	notPlayingStream.stream = sound
	if playingStream:
		if not notPlayingStream.stream == playingStream.stream:
			notPlayingStream.play(5.0)
			var tween = get_tree().create_tween()
			tween.tween_property(playingStream, "volume_db", -80, 1.5).set_ease(Tween.EASE_IN_OUT)
			tween.parallel().tween_property(notPlayingStream, "volume_db", 0, 1.5).set_ease(Tween.EASE_IN_OUT)
			tween.tween_callback(playingStream.stop)
	else:
		notPlayingStream.play()
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(notPlayingStream, "volume_db", 0, 1.5).set_ease(Tween.EASE_IN_OUT)
			
			

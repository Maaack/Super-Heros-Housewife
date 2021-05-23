extends Control


signal start_game_pressed
signal credits_pressed

func _on_StartButton_pressed():
	emit_signal("start_game_pressed")

func _on_CreditsButton_pressed():
	emit_signal("credits_pressed")

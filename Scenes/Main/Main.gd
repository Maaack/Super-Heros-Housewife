extends Control


var credits_scene : PackedScene = preload("res://Scenes/Credits/Credits.tscn")

func _on_MainMenu_start_game_pressed():
	$MainMenu.hide()
	$GameUI.show()
	$GameUI.start_game()

func _on_MainMenu_credits_pressed():
	var credits_instance : Node = credits_scene.instance()
	add_child(credits_instance)

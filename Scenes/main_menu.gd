extends Control

func _ready():
	%StartButton.grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

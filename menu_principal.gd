extends Control

func _on_button_pressed():
	# mata a cena atual e carrega a nova.
	get_tree().change_scene_to_file("res://mundo.tscn")

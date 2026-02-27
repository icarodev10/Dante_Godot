extends Control

func _on_button_pressed():
	# 1. Despausa o jogo
	get_tree().paused = false
	
	# 2. Reinicia a cena atual
	get_tree().reload_current_scene()

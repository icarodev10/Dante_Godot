extends Control

func _ready():
	# Atualiza o texto do Label puxando o valor do nosso Singleton
	$HighScoreLabel.text = "Recorde Máximo: " + str(Global.high_score)

func _on_button_pressed():
	
	# mata a cena atual e carrega a nova.
	get_tree().change_scene_to_file("res://mundo.tscn")

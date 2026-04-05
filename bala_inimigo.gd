extends Area2D

# Deixei um pouco mais lento que a sua poção pra você ter tempo de dar o Dash
const SPEED = 350.0 

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta

func _on_body_entered(body):
	# 1. FOGO AMIGO DESATIVADO: Se bater em outro monstro, ignora e passa reto!
	if body.is_in_group("monstros"):
		return

	# 2. SE BATER NO JOGADOR...
	if body.name == "Dante":
		
		# AQUI ENTRAM OS I-FRAMES! Só mata se o Dante não estiver no Dash
		if not body.dashing:
			print("VOCÊ FOI BALEADO!")
			body.morto = true
			# Como a bala e o Dante são "filhos" do Mundo, a gente acessa o Game Over pelo pai
			get_parent().game_over()
	
	# 3. Se bateu na parede ou no Dante, a bala some do mapa
	queue_free()

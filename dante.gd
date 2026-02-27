extends CharacterBody2D

var scene_bala = preload("res://bala.tscn")
const SPEED = 400.0

# 1. Variável de controle
var morto = false

# Variável para controlar o tempo entre tiros 
var pode_atirar = true

func _physics_process(_delta):
	# Se morreu, não faz mais nada.
	if morto:
		return
	
	# --- MOVIMENTO (WASD) ---
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	# Impede que o personagem saia da tela (resolução 1152x648)
	# clamp(valor_atual, minimo, maximo)
	global_position.x = clamp(global_position.x, 0, 1152)
	global_position.y = clamp(global_position.y, 0, 648)
	
	# --- TIRO (SETINHAS) ---
	# Captura um vetor baseado nas setinhas
	var vetor_tiro = Input.get_vector("tiro_esq", "tiro_dir", "tiro_cima", "tiro_baixo")
	
	# Se o vetor não for zero (ou seja, está apertando alguma seta) E puder atirar
	if vetor_tiro != Vector2.ZERO and pode_atirar:
		atirar(vetor_tiro)
		
	# Verifica se bateu em algo 
	for i in get_slide_collision_count():
		var colisao = get_slide_collision(i)

		# checa o GRUPO
		if colisao.get_collider().is_in_group("monstros"):
			print("VOCÊ MORREU!")
			
			# Ativa a trava pra não entrar aqui de novo
			morto = true
			
			# Chama a função de Game Over do Mundo
			get_parent().game_over()
			
			return 
			# O return faz o código parar IMEDIATAMENTE

func atirar(direcao):
	var nova_bala = scene_bala.instantiate()
	nova_bala.global_position = global_position
	
	# A bala vai rodar para apontar na direção da setinha
	nova_bala.rotation = direcao.angle()
	
	get_parent().add_child(nova_bala)
	
	# Toca o som
	$AudioStreamPlayer.play()
	
	
	# Cooldown
	pode_atirar = false
	await get_tree().create_timer(0.2).timeout # Espera 0.2 segundos
	pode_atirar = true
	

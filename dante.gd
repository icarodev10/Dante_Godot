extends CharacterBody2D

var scene_bala = preload("res://bala.tscn")
var ghost_scene = preload("res://ghost.tscn")
var cena_tiro_escopeta = preload("res://tiro_escopeta.tscn")
const SPEED = 400.0
var nivel_magia = 1 # 1 = normal, 2 = cone
var dash_speed = 1200.0 # Velocidade do impulso (3x mais rápido que o normal)
var dashing = false     # Controla se ele está no meio da animação do dash
var pode_dash = true    # Controla o cooldown (se a habilidade carregou)

func evoluir_arma():
	nivel_magia = 2
	print("MAGIA EVOLUÍDA!")

# 1. Variável de controle
var morto = false

# Variável para controlar o tempo entre tiros 
var pode_atirar = true

func _physics_process(_delta):
	if morto:
		return
	
# --- MOVIMENTO E DASH ---
	# Só deixa controlar no WASD se NÃO estiver no meio de um dash
	if not dashing:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		if direction:
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
			
		# GATILHO DO DASH: 
		# "ui_select" é a Barra de Espaço nativa da Godot
		# Ele só dá o dash se apertar espaço, tiver a habilidade carregada e estiver andando
		if Input.is_action_just_pressed("ui_select") and pode_dash and direction != Vector2.ZERO:
			dar_dash(direction)

	move_and_slide()
	
	# Impede que o personagem saia da tela
	global_position.x = clamp(global_position.x, 0, 1152)
	global_position.y = clamp(global_position.y, 0, 648)
	
	# --- TIRO (SETINHAS) ---
	var vetor_tiro = Input.get_vector("tiro_esq", "tiro_dir", "tiro_cima", "tiro_baixo")
	
	if vetor_tiro != Vector2.ZERO and pode_atirar:
		atirar(vetor_tiro)
		
	# --- COLISÃO COM MONSTROS ---
	for i in get_slide_collision_count():
		var colisao = get_slide_collision(i)

		if colisao.get_collider().is_in_group("monstros"):
			if not dashing:
				print("VOCÊ MORREU!")
				morto = true
				get_parent().game_over()
				return 

func atirar(direcao):
	
	# Avisa a cena do Mundo (o pai) para tremer a câmera
	get_parent().tremer_tela()
	
	if nivel_magia == 1:
		# TIRO NORMAL 
		var nova_bala = scene_bala.instantiate()
		nova_bala.global_position = global_position
		nova_bala.rotation = direcao.angle()
		get_parent().add_child(nova_bala)
	else:
		# TIRO EM CONE (A "Escopeta")
		var angulos_cone = [-0.2, 0.0, 0.2] 
		for desvio in angulos_cone:
			var nova_pocao = cena_tiro_escopeta.instantiate() 
			nova_pocao.global_position = global_position 
			nova_pocao.rotation = direcao.angle() + desvio 
			get_parent().add_child(nova_pocao)
	
	$AudioStreamPlayer.play()
	
	pode_atirar = false
	await get_tree().create_timer(0.2).timeout
	pode_atirar = true
	
func dar_dash(direcao_dash):
	dashing = true      # Trava o controle do jogador
	pode_dash = false   # Gasta a habilidade

	# Aplica o impulso violento na direção que o jogador estava indo
	velocity = direcao_dash * dash_speed
	
	# --- EFEITO VISUAL DE RASTRO ---
	# Criamos 3 clones em sequência rápida
	for i in 3:
		# Só solta o rastro se ainda estiver no dash (por segurança)
		if dashing:
			instance_ghost()
			# Espera um curtíssimo tempo (0.06s) antes de soltar o próximo
			# 3 * 0.06 = 0.18s, quase o tempo total do dash (0.2s)
			await get_tree().create_timer(0.06).timeout
	
	

	# O Dash dura só 0.2 segundos (uma escorregada rápida)
	await get_tree().create_timer(0.2).timeout
	
	# O impulso acabou! Libera o controle do WASD de novo
	dashing = false 

	# Cooldown de 1.5 segundos até poder usar de novo (pra não spammar)
	await get_tree().create_timer(1.5).timeout
	pode_dash = true
	
func instance_ghost():
	var g = ghost_scene.instantiate()
	
	# Garante que o clone nasça exatamente onde o Mago está
	g.global_position = global_position
	
	# COPIA A APARÊNCIA ATUAL (Essencial)
	# Assumindo que o seu nó de imagem se chama "Sprite2D"
	g.texture = $Sprite2D.texture
	g.flip_h = $Sprite2D.flip_h
	g.rotation = $Sprite2D.rotation # Se o mago gira
	
	# Joga o clone no mundo (get_parent())
	get_parent().add_child(g)

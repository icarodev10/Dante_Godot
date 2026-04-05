extends CharacterBody2D

# Carrega o molde da explosão
var scene_explosao = preload("res://Explosao.tscn")
@export var hp = 1 #por padrao - morre com 1 tiro
var bala_inimigo = preload("res://bala_inimigo.tscn")
var dante = null

func _ready():
	dante = get_parent().get_node("Dante")
	
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.autostart = true
	timer.timeout.connect(atirar)
	add_child(timer)

func _physics_process(_delta):
	if dante != null:
		var distancia = global_position.distance_to(dante.global_position)
		
		# NOVA DISTÂNCIA: Só anda se estiver a mais de 600 pixels de distância (metade da tela)
		if distancia > 600:
			var direcao = global_position.direction_to(dante.global_position)
			velocity = direcao * 100.0 
		else:
			# Se chegou a 600 de distância, finca o pé no chão e vira uma torreta
			velocity = Vector2.ZERO 
		
		move_and_slide()

func atirar():
	# Só atira se o Dante estiver no raio de visão (650 pixels)
	if dante != null and global_position.distance_to(dante.global_position) <= 650:
		var nova_bala = bala_inimigo.instantiate()
		
		# Calcula a direção do tiro primeiro
		var direcao_tiro = global_position.direction_to(dante.global_position)
		
		# O SEGREDO DO CANO DA ARMA: A bala nasce 40 pixels na frente do Atirador!
		nova_bala.global_position = global_position + (direcao_tiro * 40)
		
		nova_bala.rotation = direcao_tiro.angle()
		
		get_parent().add_child(nova_bala)
		
func tomar_dano():
	# Diminui a vida
	hp -= 1
	
	# 1. Pisca Amarelo (Modulate = cor cheia)
	modulate = Color.YELLOW 
	
	# 2. Espera um pouco (0.1s)
	await get_tree().create_timer(0.1).timeout
	
	# 3. Volta ao normal (Remove a tinta)
	modulate = Color.WHITE
	
	if hp <= 0:
		# Cria a explosão
		var nova_explosao = scene_explosao.instantiate()
		nova_explosao.global_position = global_position

		get_parent().add_child(nova_explosao)
	
		# Morre
		queue_free()

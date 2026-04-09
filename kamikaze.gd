extends CharacterBody2D

var dante = null

var cena_visual_explosao = preload("res://explosao_kamikaze.tscn")
# Carrega o molde da explosão
var scene_explosao = preload("res://Explosao.tscn")
@export var hp = 1 #por padrao - morre com 1 tiro


const SPEED = 280.0 
var explodindo = false

func _ready():
	# Acha o nosso herói na arena
	dante = get_parent().get_node("Dante")

func _physics_process(_delta):
	# Se a bomba já armou ou o Mago sumiu, ele não sai mais do lugar
	if explodindo or dante == null:
		return 
		
	var distancia = global_position.distance_to(dante.global_position)
	
	# Corre igual um louco atrás do Mago
	if distancia > 150:
		var direcao = global_position.direction_to(dante.global_position)
		velocity = direcao * SPEED
		move_and_slide()
	else:
		# Chegou perto o suficiente! Trava as rodinhas e liga o pavio.
		iniciar_explosao()

func iniciar_explosao():
	explodindo = true
	
	# AVISO VISUAL: O bicho fica vermelho sangue na hora!
	modulate = Color.RED 
	
	await get_tree().create_timer(0.8).timeout
	
	# 💥 CRIA A EXPLOSÃO PRIMEIRO
	print("EXPLODIU")
	var boom = cena_visual_explosao.instantiate()
	boom.global_position = global_position
	get_parent().add_child(boom)
	
	# Depois vê se mata o player
	if dante != null:
		if global_position.distance_to(dante.global_position) <= 150:
			if not dante.dashing:
				print("KABOOM! Dante virou cinzas!")
				dante.morto = true
				get_parent().game_over()
	
	# Tremor
	if get_parent().has_method("tremer_tela"):
		get_parent().forca_tremor = 25.0
	
	queue_free()
	
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
		
		get_parent().aumentar_score() # <-- Ele só te dá a alma quando o HP zera!
		# Cria a explosão
		var nova_explosao = scene_explosao.instantiate()
		nova_explosao.global_position = global_position

		get_parent().add_child(nova_explosao)
	
		# Morre
		queue_free()

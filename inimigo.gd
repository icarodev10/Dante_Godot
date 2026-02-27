extends CharacterBody2D

# Carrega o molde da explosão
var scene_explosao = preload("res://Explosao.tscn")

@export var speed = 150.0
@export var hp = 1 #por padrao - morre com 1 tiro
var dante = null

func _ready():
	# Assim que o jogo começa, ele procura o nó chamado "Dante" na cena
	dante = get_parent().get_node("Dante")

func _physics_process(delta):
	if dante:
		# Vetor: Calcula a direção DO inimigo PARA o dante
		var direction = global_position.direction_to(dante.global_position)
		
		# Anda naquela direção
		velocity = direction * speed
		move_and_slide()
		
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
		
		# --- LÓGICA DE VITÓRIA ---
		if is_in_group("boss"):
			get_parent().vencer_jogo()
	
		# Morre
		queue_free()

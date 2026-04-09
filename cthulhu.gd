extends CharacterBody2D

var dante = null
var tomando_dano = false
@export var hp = 50 # Ele é um Deus, tem que aguentar porrada!
var morto = false
var atacando = false

const SPEED = 120.0 # Ele flutua imponente, não precisa correr como um doido

# --- VARIÁVEIS DO ATAQUE ---
var tempo_entre_ataques = 2.5 # Ele ataca a cada 2.5 segundos
var cronometro = 0.0

func _ready():
	dante = get_parent().get_node("Dante")
	# Começa voando/parado
	$AnimatedSprite2D.play("fly") 

func _physics_process(delta):
	if morto or atacando or tomando_dano or dante == null:
		return
		
	# --- RELÓGIO DE ATAQUE ---
	cronometro += delta
	if cronometro >= tempo_entre_ataques:
		atacar()
		return # Para de processar o movimento neste frame para ele focar no ataque
		
	# 1. Movimentação (Persegue o Dante)
	var direcao = global_position.direction_to(dante.global_position)
	velocity = direcao * SPEED
	move_and_slide()
	
	# 2. Lógica de "Olhar" para o lado certo
	if direcao.x > 0:
		$AnimatedSprite2D.flip_h = false # Olha para a direita
	else:
		$AnimatedSprite2D.flip_h = true  # Olha para a esquerda (depende do seu asset)

	# 3. Troca para animação de movimento se ele estiver andando
	if velocity.length() > 0:
		$AnimatedSprite2D.play("fly") # Ou "walk", se preferir
	else:
		$AnimatedSprite2D.play("idle")
		
		# --- A MÁQUINA DE BATER ---
func atacar():
	atacando = true
	cronometro = 0.0 # Zera o relógio para o próximo ataque
	
	# Sorteia um número: 0 ou 1
	var tipo_ataque = randi() % 2 
	var alcance_do_golpe = 0
	
	if tipo_ataque == 0:
		# ATAQUE 1: SOCÃO (Alcance Curto)
		$AnimatedSprite2D.play("1atk")
		alcance_do_golpe = 500
	else:
		# ATAQUE 2: TENTÁCULOS (Alcance Longo)
		$AnimatedSprite2D.play("2atk")
		alcance_do_golpe = 587
		
	# Espera a animação rodar inteira até o fim!
	await $AnimatedSprite2D.animation_finished
	
# ==========================================
	# O JULGAMENTO (BOX DE ATAQUE REALISTA)
	# ==========================================
	if dante != null:
		var distancia_real = global_position.distance_to(dante.global_position)
		var diff_x = dante.global_position.x - global_position.x
		var diff_y = abs(dante.global_position.y - global_position.y) # Distância vertical absoluta
		
		var dante_ta_na_frente = false
		
		# 1. Checa se está no lado certo (X)
		if $AnimatedSprite2D.flip_h == false: # Olhando pra DIREITA
			if diff_x > 0: dante_ta_na_frente = true
		else: # Olhando pra ESQUERDA
			if diff_x < 0: dante_ta_na_frente = true
		
		# 2. O FILTRO DE ALTURA (A "CAIXA" DO GOLPE)
		var altura_valida = diff_y < 400
		
		# 3. SÓ MATA SE: Estiver na frente E na distância E na altura certa
		if dante_ta_na_frente and distancia_real <= alcance_do_golpe and altura_valida:
			if not dante.dashing:
				print("💀 K.O! Cthulhu acertou em cheio!")
				dante.morto = true
				get_parent().game_over()
			else:
				print("💨 Dante desviou por baixo do golpe!")
		else:
			print("🛡️ Errou! Dante estava fora da zona de impacto.")
				
	# Volta ao estado normal
	atacando = false

func tomar_dano():
	if morto: return
	
	hp -= 1
	
	if hp <= 0:
		morrer()
		
	# Trava ele pra tocar a animação de dor sem bugar com vários tiros rápidos
	if not tomando_dano:
		tomando_dano = true
		
		$AnimatedSprite2D.play("hurt") # Toca o frame dele sofrendo
		modulate = Color.RED # Fica vermelhão junto pra dar o "Suco"
		
		# Espera um tempinho curtinho (o tempo do mini-stun)
		await get_tree().create_timer(0.2).timeout
		
		modulate = Color.WHITE # Tira a tinta vermelha
		tomando_dano = false # Libera ele pra voltar a voar/atacar

func morrer():
	morto = true
	$AnimatedSprite2D.play("death")
	
	# Espera a animação de morte acabar para sumir
	await $AnimatedSprite2D.animation_finished
	get_parent().vencer_jogo_final()
	queue_free()

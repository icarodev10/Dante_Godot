extends Sprite2D

func _ready():
	# Define a opacidade inicial (0.6 é 60% visível)
	modulate.a = 0.6
	
	# Cria uma animação rápida via código (Tween)
	var tween = create_tween()
	
	# Anima a propriedade "modulate:a" (alfa/transparência) para 0.0 em 0.4 segundos
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	
	# Ao final da animação, mata o clone para não pesar o jogo
	tween.tween_callback(queue_free)

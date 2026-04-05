extends Node

var high_score = 0
var save_path = "user://highscore.save" # O user:// é a pasta segura do próprio sistema operacional (Windows/Linux/Mac)

func _ready():
	# Toda vez que o jogo abrir, a primeira coisa que ele faz é tentar ler o arquivo
	carregar_jogo()

func salvar_jogo():
	# Abre o arquivo em modo de ESCRITA (WRITE)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	# Grava a variável high_score como um número inteiro de 32 bits
	file.store_32(high_score)

func carregar_jogo():
	# Primeiro verifica se o arquivo já existe na máquina do cara
	if FileAccess.file_exists(save_path):
		# Se existe, abre em modo de LEITURA (READ)
		var file = FileAccess.open(save_path, FileAccess.READ)
		# Puxa o número gravado e joga na nossa variável
		high_score = file.get_32()

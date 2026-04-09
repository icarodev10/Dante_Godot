# 💀 A Descida de Dante (Godot MVP)

Um jogo de sobrevivência em arena desenvolvido na Godot Engine 4. Este projeto foi criado como um MVP (Minimum Viable Product) para praticar lógica de programação, Orientação a Objetos e arquitetura de estados.



https://github.com/user-attachments/assets/252f080f-4507-4f4a-bb56-63921977d5fa



## 💻 Desafios Técnicos e Aprendizados
Como desenvolvedor Backend, utilizei este projeto para aplicar conceitos de engenharia de software no desenvolvimento de jogos:

* **Orientação a Objetos (Herança):** Criação de uma classe base de `inimigos` e derivação para monstros com comportamentos diferentes (Fantasmas lentos, Diabinhos rápidos, atirador, kamikaze, o Ciclope e o Cthulhu).
* **Lógica de Spawn Seguro (Safe Spawn):** Implementação de um loop de validação (while) com cálculo de vetores (`distance_to`) para garantir que os inimigos nunca nasçam muito perto do jogador.
* **Máquina de Estados (Progressão):** Sistema dinâmico que altera a dificuldade, a música e o ambiente visual (Círculos do Inferno) com base na pontuação do jogador.
* **Limitações Matemáticas:** Uso da função `clamp` para manter o jogador dentro dos limites da tela sem a necessidade de criar objetos físicos de colisão (Paredes invisíveis via código).
* **UI e Game Loop:** Telas de Menu, Game Over e Vitória, com gerenciamento do `Process Mode` para pausar instâncias físicas enquanto a interface continua responsiva.

## 🛠️ Tecnologias
* Godot Engine 4.x
* GDScript

## 🎮 Como Jogar
Baixe o repositório, abra o arquivo `project.godot` na Godot Engine e dê Play (F5).

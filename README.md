# 💀 A Descida de Dante (Godot MVP)

Um jogo de sobrevivência em arena (*bullet hell / roguelite*) desenvolvido na Godot Engine 4. Este projeto foi criado como um MVP (Minimum Viable Product) para praticar lógica de programação, Orientação a Objetos e arquitetura de estados.

https://github.com/user-attachments/assets/252f080f-4507-4f4a-bb56-63921977d5fa

## 💻 Desafios Técnicos e Aprendizados
Como desenvolvedor Backend, utilizei este projeto para aplicar conceitos sólidos de engenharia de software no desenvolvimento de jogos:

* **Orientação a Objetos (Herança):** Criação de uma classe base de `inimigos` e derivação para monstros com comportamentos diferentes (Fantasmas lentos, Diabinhos rápidos, Atiradores, Kamikazes, além dos chefões Ciclope e Cthulhu).
* **Lógica de Spawn Seguro (Safe Spawn):** Implementação de um loop de validação (`while`) com cálculo de vetores (`distance_to`) para garantir que os inimigos nunca nasçam muito perto do jogador.
* **Máquina de Estados (Progressão e Waves):** Sistema dinâmico que altera a dificuldade, a música e o ambiente visual (Círculos do Inferno) com base na pontuação do jogador. O spawner gerencia o RNG para invocar diferentes *raids* de inimigos dependendo do nível atual.
* **Limitações Matemáticas:** Uso da função `clamp` para manter o jogador dentro dos limites da tela sem a necessidade de criar objetos físicos de colisão (Paredes invisíveis via código).
* **UI e Game Loop:** Telas de Menu, Game Over e Vitória, com gerenciamento do `Process Mode` para pausar instâncias físicas enquanto a interface continua responsiva.
* **Hitboxes Direcionais e Otimização:** Implementação de ataques complexos de chefões (Cthulhu) baseados em cálculo de vetores, validação de eixo direcional (`flip_h`) e filtros de altura (`diff_y`). Isso permitiu criar áreas de dano precisas sem a necessidade de processar *CollisionShapes* adicionais na engine de física.
* **Persistência de Dados (Singleton):** Criação de um *Autoload* (`Global.gd`) para gerenciar e salvar o *High Score* localmente no disco, persistindo o recorde do jogador entre as sessões.
* **Game Feel & Feedback:** Programação de *Screen Shake* dinâmico controlado por interpolação matemática (`lerp`) e implementação de *Hit Stops* (mini-stuns) atrelados à sincronização de animação (`await animation_finished`). Além da implementação de *Dash*, que também deixa o player invencível por algum tempo.

## 👹 O Bestiário
* **Minions da Arena:** Fantasmas (perseguição direta), Diabinhos (velocidade), Kamikazes (explosão em área com temporizador) e Atiradores (combate à distância).
* **Mid-Boss (Ciclope):** Marca a transição para o Círculo 3, suportando alto dano e liberando a evolução de arma (Escopeta).
* **Final Boss (Cthulhu):** Batalha com múltiplos padrões de ataque randômicos (curto e longo alcance), exigindo leitura de *hitboxes* invisíveis e uso de *i-frames* (Dash) para esquiva.

* V2:

https://github.com/user-attachments/assets/4c398052-2037-4f45-881b-95b7002ff7ec


## 🛠️ Tecnologias
* Godot Engine 4.x
* GDScript

## 🎮 Como Jogar
Baixe o repositório, abra o arquivo `project.godot` na Godot Engine e dê Play (F5). Sobreviva às hordas, acumule almas e derrote o Deus Ancião para escapar do abismo!

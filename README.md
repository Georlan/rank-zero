# RANK ZERO

Protótipo para Godot 4.4.1, em português. Usa GDScript e direção visual experimental em pixel art gerada com IA; não requer plugins.

## Executar no Windows
1. Instale/abra a Godot 4.4.1 ou uma versão 4.x compatível.
2. Clone este repositório com `git clone https://github.com/Georlan/rank-zero.git` (a conta precisa ter acesso ao repositório privado), ou baixe o ZIP pelo GitHub e extraia.
3. No Gerenciador de Projetos da Godot, selecione **Importar**, escolha `project.godot` na pasta extraída e abra o projeto.
4. Pressione **F5** para executar o projeto. No menu, clique em **Entrar no combate** ou em **Testar sala de técnicas**. Clique nas cartas e depois em **Encerrar turno**; reinicie pela tela de resultado.

## Estado
Um confronto isolado: mão, energia, compra/embaralhamento, intenções, ataque, Guarda, Abertura, Desequilíbrio, contra-ataque, vitória e derrota. Personagens em folhas de sprites são animados sobre cenários independentes; as cartas e os painéis são desenhados e operados na Godot. O jab apresenta aproximação, preparação, extensão e retorno, com reação visual do rival. Guarda e Finta usam poses próprias. São animações iniciais com poucos quadros; Projeção, contra-ataque e golpes do rival ainda precisam de coreografias próprias. O painel do Sistema mostra energia e estado de reação, sem habilidades próprias nesta versão. Após a vitória, a sala de técnicas oferece uma cópia de Finta, Projeção ou Contra de Encontro, ou permite seguir sem carta. A cópia fica no deck da tentativa enquanto o jogo está aberto; uma nova tentativa a remove. Cada próxima luta começa com vida cheia, provisoriamente, contra o mesmo rival. Também é possível visitar a sala pelo botão de teste. Ainda não há mapa, compras, treinamento de atributos, quests, Despertar, salvamento, Steam ou campanha.

## Testes
Com o executável da Godot 4.4.1 disponível no terminal: `godot --headless --path . --script res://tests/combat_test.gd` e `godot --headless --path . --script res://tests/ui_test.gd` e `godot --headless --path . --script res://tests/presentation_test.gd`, `godot --headless --path . --script res://tests/card_interaction_test.gd` e `godot --headless --path . --script res://tests/room_journey_test.gd`. Os valores provisórios estão em `data/cards.gd`, `scripts/combat.gd` e `docs/BALANCE_NOTES.md`.

# RANK ZERO

Protótipo inicial de combate 1×1 para Godot 4.4.1, em português. O projeto usa apenas GDScript e desenhos vetoriais originais programáticos; não requer plugins.

## Executar no Windows
1. Instale/abra a Godot 4.4.1 ou uma versão 4.x compatível.
2. Clone este repositório com `git clone https://github.com/Georlan/rank-zero.git` (a conta precisa ter acesso ao repositório privado), ou baixe o ZIP pelo GitHub e extraia.
3. No Gerenciador de Projetos da Godot, selecione **Importar**, escolha `project.godot` na pasta extraída e abra o projeto.
4. Pressione **F5** para executar o projeto. No menu, clique em **Iniciar confronto**. Clique nas cartas e depois em **Encerrar turno**; reinicie pela tela de resultado.

## Estado
Um confronto isolado: mão, energia, compra/embaralhamento, intenções, ataque, Guarda, Abertura, Desequilíbrio, contra-ataque, vitória e derrota. Os personagens e cenário são ilustrações geométricas provisórias feitas no próprio código; não são arte final. O painel do Sistema mostra energia e estado de reação, sem habilidades próprias nesta versão. Mapa, recompensas, quests, atributos, Despertar, persistência, Steam e campanha ainda não foram implementados.

## Testes
Com o executável da Godot 4.4.1 disponível no terminal: `godot --headless --path . --script res://tests/combat_test.gd`. Os valores provisórios estão em `data/cards.gd`, `scripts/combat.gd` e `docs/BALANCE_NOTES.md`.

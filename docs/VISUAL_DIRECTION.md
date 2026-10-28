# Direção visual inicial

Cobertura escolar urbana à noite, grafite e azul petróleo, com ciano para o Sistema e coral para ações ofensivas. Os lutadores ficam em lados opostos, com espaço para a leitura das intenções e dos estados. Cartas têm dimensões fixas, cores por função e textos oriundos dos dados de combate. O efeito de clarão utiliza Tween na Godot e não controla a resolução das regras.

A imagem `assets/art/rooftop_duel.png` foi gerada para este projeto com a ferramenta integrada de geração de imagens da OpenAI: cenário de cobertura escolar chuvosa à noite, dois lutadores originais em posições opostas, estética de ilustração de luta, sem texto ou interface. É uma imagem de conceito com personagens incorporados, não usada no combate atual. A consistência visual das próximas poses e recursos ainda precisará ser trabalhada. Os painéis e cartas são desenhados em GDScript; a fonte é a padrão da Godot. Referências narrativas são conceituais e não foram incluídos ativos das obras mencionadas.

## Lutadores em camadas

Os arquivos `fighter_protagonist.png` e `fighter_caio.png` são imagens originais geradas com fundo transparente, em posições de combate voltadas uma para a outra. `rooftop_empty.png` é o cenário separado, sem personagens. Os três foram criados com a ferramenta integrada de imagens da OpenAI. O protagonista usa AnimatedSprite2D com guarda, preparação e extensão para o jab, além de uma pose de guarda alta. A apresentação inclui aproximação e retorno, enquanto o rival recebe pose de reação sincronizada. A pose fighter_jab.png foi criada com a ferramenta integrada de imagens da OpenAI a partir do personagem. A Finta alterna preparação e guarda; outros golpes ainda usam deslocamentos provisórios por Tween. A sequência ainda precisa de quadros intermediários e refinamento. Os pés são alinhados a um plano comum e cada entidade desenha sombra de contato. A imagem anterior `rooftop_duel.png` permanece como referência de conceito, não é usada no combate.

As imagens e GIFs fornecidos pelo usuário servem de referência para composição, plano de chão e leitura do combate; nenhum deles é distribuído no projeto. A técnica do jab foi consultada no manual da Boxing Canada e na documentação oficial de animação 2D da Godot.

## Interface do Sistema

A marca RANK ZERO do menu é desenhada com traços geométricos próprios no código, como lettering específico para o título; não é uma fonte completa. Para leitura, o projeto inclui Noto Sans Regular e Noto Sans Condensed ExtraBold, distribuídas sob licença SIL Open Font License 1.1, com texto e créditos em assets/fonts/LICENSE-NOTO.txt.

Painéis escuros semitransparentes mantêm dados sobre a arena; ciano representa Sistema e defesa, coral destaca ataques e intenções, violeta distingue condições. Os símbolos de ataque, defesa, efeito e reação são desenhados por código para o projeto. As cartas mantêm texto e custo reais de data/cards.gd, com estado de energia, foco de teclado e destaque ao passar o mouse. Referências de jogos fornecidas pelo usuário orientaram a hierarquia e a relação entre arena e mão, sem distribuir imagens ou elementos desses jogos.

## Cartas ilustradas

Cada técnica possui ilustração separada em assets/cards; a carta interativa é montada em scripts/card_view.gd, com texto e custo dos dados de jogo. Ao passar o mouse ou receber foco do teclado, a carta sobe levemente e destaca sua borda; sem energia suficiente, fica dessaturada e não pode ser ativada. As imagens são interpretações conceituais de técnicas, não representam os personagens oficiais do jogo. O cabeçalho usa uma faixa discreta para preservar a arena.

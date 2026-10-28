# Direção de coreografia — RANK ZERO

Este documento é uma proposta de apresentação para as regras já definidas. As coreografias descritas abaixo não estão todas implementadas. São hipóteses de ritmo visual, sem alteração de dano, custo, condições ou duração de efeitos.

## Referências e tradução

- A WEBTOON credita Lookism a Taejun Pak, Viral Hit a Taejun Pak e Kim Junghyun, e Questism a TAEWAN e YuNuni. As obras fornecem contexto de rivalidade, aprendizado de luta e progressão extraordinária, respectivamente; não assumimos uma autoria única para todas. [Lookism](https://us.webtoons.com/en/drama/lookism/list?page=1&title_no=1049), [Viral Hit](https://sg.webtoons.com/en/action/viral-hit/list?title_no=2268), [Questism](https://m.webtoons.com/en/fantasy/questism/list?title_no=3767&webtoon-platform-redirect=true).
- As cinco imagens fornecidas pelo usuário sugerem, como leitura visual desta equipe: contraste entre pausa e aceleração; silhueta e linha de força claras; reação corporal na direção do impacto; perspectiva expressiva e diferença de escala entre confrontos; e movimentos acrobáticos para momentos excepcionais. Elas são referências, não quadros a reproduzir nem recursos do projeto.
- As capturas anteriores de Slay the Spire orientam composição: palco com personagens ancorados, intenção visível, cartas legíveis e impacto breve, sem reproduzir seus elementos de interface ou arte.
- Para fundamento físico, um jab usa a mão dianteira e preserva a guarda posterior. No judô, desequilibrar, posicionar e executar são partes relacionadas de uma projeção ([Boxing Canada](https://www.fqbo.qc.ca/modules/publications/Apprentice%20Coach%20Manual-%20June%2020%2C%202016.pdf), [IJF](https://www--gcp.ijf.org/news/show/nage-no-kata-more-than-a-sequence-of-throws)). A direção é uma interpretação de fantasia para o jogo, não instrução de treinamento.

## Gramática comum

1. **Leitura:** postura e breve preparação revelam a técnica.
2. **Ação:** deslocamento coerente de peso, mão ou quadril; linha visual indica direção.
3. **Contato:** resposta do alvo e efeito localizado, com pausa visual muito curta quando apropriado.
4. **Recuperação:** ambos regressam a posturas reconhecíveis; o chão e os pés não devem deslizar.

A animação não determina dano nem a disponibilidade da próxima ação: o motor resolve a carta imediatamente. Eventos visuais consultam os resultados reais; Guarda absorvida, dano à vida e condições devem ter leituras distintas. Evitar que uma fila de efeitos esconda a intenção, a mão ou o resultado e evitar que um golpe rápido interrompido deixe o personagem fora da posição.

## Propostas por carta

### Jab — Boxe
- Guarda compacta; leve transferência de peso para o pé da frente; braço dianteiro segue reto, mão de trás protege o rosto.
- No momento da extensão, traço curto e estreito na direção do rival. Se o golpe atingir a vida, reação curta na parte superior do corpo; se for absorvido, mostrar choque na Guarda. O punho volta pelo mesmo trajeto.
- Ritmo-alvo provisório: 0,30–0,45 s. Golpe básico deve ser mais contido que um especial. Protótipo implementado: aproximação, preparação, extensão, retorno e reação sincronizada do rival. A sequência ainda precisa de mais quadros e melhor continuidade entre poses.

### Guarda — Boxe
- Cotovelos se fecham, queixo baixa e base estabiliza; uma borda ciano breve identifica a Guarda recebida. A proteção só reage quando dano é efetivamente absorvido.
- Ritmo-alvo: 0,25–0,40 s. Não representar a defesa como cancelamento da ação inimiga. Existe uma pose inicial de guarda alta.

### Finta — Boxe
- Um início curto de ombro e mão sugere um golpe; ele é recolhido antes da extensão. O rival reage com pequena abertura de postura. Um sinal discreto identifica a condição Abertura sem simular dano.
- Ritmo-alvo: 0,30–0,45 s. A finta indica uma condição, não exige sequência fixa para o combo. Existe uma sequência curta de preparação e retorno.

### Projeção — Judô
- A aproximação e a pegada precisam ser legíveis; com Abertura, o rival perde o eixo, o protagonista entra na distância e gira o quadril, e o rival segue um arco com contato no solo. Recuperação mostra ambos de volta às suas posições de jogo.
- Sem Abertura, apresentar uma versão mais curta da técnica, consistente com o dano básico, sem indicar Desequilíbrio. Com Abertura, enfatizar o deslocamento e mostrar a condição após a resolução. Nunca sugerir que o turno do rival foi cancelado.
- Ritmo-alvo: 0,65–1,0 s. As condições de jogo permanecem as existentes. Poses, deslocamentos coordenados e contato ainda precisam ser produzidos e testados.

### Contra de Encontro — Boxe
- Preparação: base firme e cotovelo junto ao corpo, com marcador de reação ativo. Quando uma ação ofensiva inimiga acontece, manter a resposta por golpe do ataque para dano/Guarda; depois mostrar uma única resposta do contra, mesmo se a ação tiver múltiplos golpes.
- Contra: desvio curto de tronco e golpe direto, seguido de recuperação. Não reproduzir uma reação extra por golpe nem criá-la quando nenhuma ação ofensiva acontece.
- Ritmo-alvo: 0,45–0,70 s após a ação. Poses e sincronização ainda pendentes.

## Progressão e prioridades de produção

Golpes básicos usam animação concisa; combinações condicionais podem acrescentar uma pose, contraste e um efeito localizado; Despertar futuro pode ganhar enquadramento especial e pausa mais longa, sem encobrir estado nem atrasar regras. Acrobacias e exageros físicos são reservados a habilidades que as justifiquem, não ao jab inicial. Não implementar Despertar apenas por esta proposta.

Próximo pacote: poses coerentes de guarda, preparação, extensão, impacto e retorno; reação do rival com mesma escala e apoio; sincronização visual com dano real e Guarda; teste de jogadas repetidas, resultado e reinício. Depois produzir a finta e uma projeção coordenada entre os dois lutadores. Validar gravações reais da Godot em movimento, além de testes automatizados.

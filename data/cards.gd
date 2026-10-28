extends RefCounted
const ALL = {
 "jab": {"name":"Jab", "cost":1, "type":"ATAQUE · BOXE", "description":"Causa 6 de dano.", "effect":"damage", "value":6},
 "guard": {"name":"Guarda", "cost":1, "type":"DEFESA · BOXE", "description":"Recebe 7 de Guarda.", "effect":"guard", "value":7},
 "feint": {"name":"Finta", "cost":1, "type":"EFEITO · BOXE", "description":"Aplica Abertura ao rival.", "effect":"opening", "value":1},
 "throw": {"name":"Projeção", "cost":2, "type":"ATAQUE · JUDÔ", "description":"8 de dano. Com Abertura: +4 e Desequilíbrio.", "effect":"throw", "value":8},
 "counter": {"name":"Contra de Encontro", "cost":1, "type":"REAÇÃO · BOXE", "description":"Prepare um contra-ataque de 5 por ação ofensiva neste turno.", "effect":"counter", "value":5}
}
const STARTER = ["jab", "jab", "jab", "guard", "guard", "guard", "feint", "throw", "counter", "jab"]

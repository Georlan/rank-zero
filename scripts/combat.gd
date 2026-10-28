extends RefCounted
const Cards = preload("res://data/cards.gd")
var rng := RandomNumberGenerator.new()
var hp := 50
var enemy_hp := 45
var guard := 0
var enemy_guard := 0
var energy := 3
var opening := 0
var off_balance := 0
var counter := 0
var turn := 1
var hand: Array = []
var deck: Array = []
var discard: Array = []
var intent: Dictionary = {}
var result := ""
var log := "O confronto começou."
func start(seed_value: int = 1) -> void:
 rng.seed = seed_value
 hp = 50; enemy_hp = 45; guard = 0; enemy_guard = 0; energy = 3
 opening = 0; off_balance = 0; counter = 0; turn = 1; result = ""
 hand = []; discard = []; deck = Cards.STARTER.duplicate()
 _shuffle(deck)
 _draw(5)
 _choose_intent()
func _shuffle(pile: Array) -> void:
 for i in range(pile.size() - 1, 0, -1):
  var j = rng.randi_range(0, i)
  var tmp = pile[i]; pile[i] = pile[j]; pile[j] = tmp
func _draw(count: int) -> void:
 for i in range(count):
  if deck.is_empty():
   deck = discard; discard = []
   _shuffle(deck)
  if deck.is_empty(): break
  hand.append(deck.pop_back())
func _choose_intent() -> void:
 # The announced action remains fixed until it resolves; conditions modify its execution.
 if enemy_hp <= 18 and turn % 2 == 0:
  intent = {"kind":"guard", "value":8, "label":"DEFENDER · 8 de Guarda"}
 elif turn % 3 == 0:
  intent = {"kind":"multi", "value":4, "hits":2, "label":"COMBO · 4 × 2"}
 else:
  intent = {"kind":"attack", "value":9, "label":"ATAQUE · 9 de dano"}
func _damage_enemy(amount: int) -> void:
 var absorbed = mini(enemy_guard, amount)
 enemy_guard -= absorbed
 enemy_hp = maxi(0, enemy_hp - (amount - absorbed))
func _damage_player(amount: int) -> void:
 var absorbed = mini(guard, amount)
 guard -= absorbed
 hp = maxi(0, hp - (amount - absorbed))
func play(index: int) -> bool:
 if result != "" or index < 0 or index >= hand.size(): return false
 var id: String = hand[index]
 var card: Dictionary = Cards.ALL[id]
 if card.cost > energy: return false
 energy -= card.cost
 hand.remove_at(index)
 discard.append(id)
 match card.effect:
  "damage": _damage_enemy(card.value)
  "guard": guard += card.value
  "opening": opening = 1
  "counter": counter = card.value
  "throw":
   var damage: int = card.value
   if opening > 0:
    damage += 4; opening = 0; off_balance = 1
   _damage_enemy(damage)
 log = "%s foi usada." % card.name
 if enemy_hp <= 0: result = "vitória"
 return true
func end_turn() -> void:
 if result != "": return
 discard.append_array(hand); hand.clear()
 enemy_guard = 0
 if intent.kind == "guard":
  enemy_guard += intent.value
  log = "O rival se protegeu."
 else:
  var hits: int = intent.get("hits", 1)
  var per_hit: int = maxi(0, int(intent.value) - (2 if off_balance > 0 else 0))
  off_balance = 0
  for i in range(hits):
   _damage_player(per_hit)
  if counter > 0:
   _damage_enemy(counter)
  log = "O rival atacou: %d × %d. Contra: %d." % [per_hit, hits, counter]
 counter = 0
 if hp <= 0: result = "derrota"; return
 if enemy_hp <= 0: result = "vitória"; return
 turn += 1
 guard = 0
 energy = 3
 _draw(5)
 _choose_intent()

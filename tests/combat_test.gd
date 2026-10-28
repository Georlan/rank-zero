extends SceneTree
const Combat = preload("res://scripts/combat.gd")
var failures := 0
func check(ok: bool, message: String) -> void:
 if not ok:
  failures += 1; push_error(message)
func _initialize() -> void:
 var b = Combat.new(); b.start(7)
 check(b.hand.size() == 5 and b.energy == 3, "mão e energia iniciais")
 var a = Combat.new(); a.start(7)
 check(a.hand == b.hand and a.intent == b.intent, "semente determinística")
 b.hand = ["jab"]; b.energy = 0
 check(not b.play(0) and b.enemy_hp == 45, "custo impede jogada")
 b.energy = 3; b.enemy_guard = 4; b.play(0)
 check(b.enemy_hp == 43 and b.enemy_guard == 0 and b.energy == 2, "dano e guarda")
 b.hand = ["feint", "throw"]; b.energy = 3; b.play(0); b.play(0)
 check(b.opening == 0 and b.off_balance == 1 and b.enemy_hp == 31, "abertura e projeção")
 b.intent = {"kind":"multi", "value":4, "hits":2, "label":"teste"}; b.guard = 3; b.counter = 5
 var hp_before = b.hp; var enemy_before = b.enemy_hp
 b.end_turn()
 check(b.hp == hp_before - 1 and b.enemy_hp == enemy_before - 5, "guarda por golpe, desequilíbrio e reação por ação")
 check(b.energy == 3 and b.hand.size() == 5, "início do turno")
 b.enemy_hp = 18; b.turn = 2; b._choose_intent()
 check(b.intent.kind == "guard", "IA condicional")
 var announced = b.intent.duplicate(); b.hand = ["jab"]; b.play(0)
 check(b.intent == announced, "intenção permanece anunciada")
 print("TESTES: %s" % ("OK" if failures == 0 else "%d falhas" % failures))
 quit(0 if failures == 0 else 1)

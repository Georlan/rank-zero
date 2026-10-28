extends SceneTree
var frames_seen: Array[int] = []
var rival_hit := false
func _initialize(): call_deferred("run")
func run():
 var scene = load("res://scenes/main.tscn").instantiate()
 root.add_child(scene)
 await process_frame
 scene._start()
 scene.battle.hand = ["jab"]; scene.battle.energy = 3
 var sprite = scene.hero_actor.sprite
 sprite.frame_changed.connect(func():
  if sprite.animation == "jab": frames_seen.append(sprite.frame)
 )
 scene.rival_actor.sprite.animation_changed.connect(func():
  if scene.rival_actor.sprite.animation == "hit": rival_hit = true
 )
 scene._play(0)
 var immediate = scene.battle.enemy_hp == 39
 await create_timer(1.1).timeout
 var jab_ok = immediate and 1 in frames_seen and 2 in frames_seen and 3 in frames_seen and rival_hit and sprite.animation == "guard" and abs(scene.hero_actor.position.x - scene.hero_actor.home_x) < 0.1
 scene._start(); scene.battle.hand = ["guard", "feint"]; scene.battle.energy = 3
 scene._play(0)
 var guard_ok = sprite.animation == "defend" and scene.battle.guard == 7
 scene._play(0)
 var feint_ok = sprite.animation == "feint" and scene.battle.opening == 1
 scene._start(); rival_hit = false
 scene.battle.enemy_guard = 10; scene.battle.hand = ["jab"]; scene._play(0)
 await create_timer(0.6).timeout
 var blocked_ok = not rival_hit and scene.battle.enemy_hp == 45 and scene.battle.enemy_guard == 4
 scene._start(); scene.battle.enemy_hp = 1; scene.battle.hand = ["jab"]; scene._play(0)
 var lethal_immediate = scene.battle.result == "vitória" and scene.buttons.is_empty()
 await create_timer(1.1).timeout
 var result_ok = scene.buttons.size() == 2
 var ok = jab_ok and guard_ok and feint_ok and blocked_ok and lethal_immediate and result_ok
 print("APRESENTAÇÃO: ", "OK" if ok else "FALHOU", " ", [jab_ok, guard_ok, feint_ok, blocked_ok, lethal_immediate, result_ok])
 quit(0 if ok else 1)

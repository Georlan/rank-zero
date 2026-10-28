extends SceneTree
func _initialize(): call_deferred("run")
func run():
 var scene = load("res://scenes/main.tscn").instantiate()
 root.add_child(scene)
 await process_frame
 scene._start()
 scene.battle.hand = ["jab"]; scene.battle.energy = 3
 scene._play(0)
 var resolved = scene.battle.enemy_hp == 39
 await process_frame
 var moved = scene.hero_tween.is_running() and scene.rival_tween.is_running()
 await create_timer(0.45).timeout
 var returned = abs(scene.hero_shift) < 0.1 and abs(scene.rival_shift) < 0.1
 print("resolvido=", resolved, " moveu=", moved, " voltou=", returned, " deslocamentos=", scene.hero_shift, ",", scene.rival_shift)
 var ok = resolved and moved and returned
 print("APRESENTAÇÃO: ", "OK" if ok else "FALHOU")
 quit(0 if ok else 1)

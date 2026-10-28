extends SceneTree
var observed: Array[int] = []
func _initialize(): call_deferred("run")
func run():
 var scene = load("res://scenes/main.tscn").instantiate()
 root.add_child(scene)
 await process_frame
 scene._start()
 scene.battle.hand = ["jab"]; scene.battle.energy = 3
 var sprite = scene.hero_actor.sprite
 sprite.frame_changed.connect(func():
  if sprite.animation == "jab": observed.append(sprite.frame)
 )
 scene._play(0)
 var resolved = scene.battle.enemy_hp == 39
 var started = sprite.animation == "jab" and sprite.is_playing()
 await create_timer(0.8).timeout
 var extension = 1 in observed
 var recovered = sprite.animation == "guard"
 var grounded = scene.hero_actor.position.y == scene.rival_actor.position.y
 var ok = resolved and started and extension and recovered and grounded
 print("APRESENTAÇÃO: ", "OK" if ok else "FALHOU", " (dano, início, extensão, retorno, apoio: ", [resolved, started, extension, recovered, grounded], ")")
 quit(0 if ok else 1)

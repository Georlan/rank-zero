extends SceneTree
var failed = false
func _initialize(): call_deferred("run")
func run():
 var scene = load("res://scenes/main.tscn").instantiate()
 root.add_child(scene)
 await process_frame
 scene._start()
 await process_frame
 var first = scene.buttons[0]
 var prev = scene.battle.hand.size()
 var ev = InputEventMouseButton.new()
 ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true
 first._gui_input(ev)
 if scene.battle.hand.size() != prev - 1: failed = true
 scene._end_turn()
 if scene.battle.turn != 2 or scene.battle.hand.size() != 5: failed = true
 scene.battle.enemy_hp = 1; scene.battle.hand = ["jab"]; scene.battle.energy = 3
 scene._play(0)
 if scene.battle.result != "vitória": failed = true
 scene._start()
 if scene.battle.result != "" or scene.battle.hand.size() != 5: failed = true
 print("INTERFACE: ", "FALHOU" if failed else "OK")
 quit(1 if failed else 0)

extends SceneTree
func _initialize(): call_deferred("run")
func run():
 var scene = load("res://scenes/main.tscn").instantiate(); root.add_child(scene)
 await process_frame
 scene._test_room()
 var opened = scene.screen == "room" and scene.run_cards.is_empty() and scene.buttons.size() == 5 and scene.buttons[3].disabled
 scene._confirm_room()
 var cannot_confirm_empty = scene.screen == "room" and scene.run_cards.is_empty()
 scene.buttons[0].selected.emit(); scene.buttons[1].selected.emit()
 var selection = scene.room_choice == "throw" and not scene.buttons[3].disabled
 scene.buttons[3].pressed.emit()
 var pile = scene.battle.hand + scene.battle.deck + scene.battle.discard
 var one_added = scene.screen == "battle" and scene.run_cards == ["throw"] and pile.size() == 11 and pile.count("throw") == 2
 scene._confirm_room()
 var no_double = scene.run_cards.size() == 1
 scene._show_room(); scene._skip_room()
 var skip = scene.run_cards.size() == 1 and scene.screen == "battle"
 scene._new_run()
 var fresh = scene.run_cards.is_empty() and (scene.battle.hand + scene.battle.deck).size() == 10
 var ok = opened and cannot_confirm_empty and selection and one_added and no_double and skip and fresh
 print("SALA: ", "OK" if ok else "FALHOU", " ", [opened,cannot_confirm_empty,selection,one_added,no_double,skip,fresh])
 quit(0 if ok else 1)

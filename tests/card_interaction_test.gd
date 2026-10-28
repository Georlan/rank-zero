extends SceneTree
const CardView = preload("res://scripts/card_view.gd")
const Cards = preload("res://data/cards.gd")
var selected := 0
func _initialize(): call_deferred("run")
func run():
 var view = CardView.new(); view.size = Vector2(186,204)
 view.configure(Cards.ALL["jab"], true)
 root.add_child(view); view.selected.connect(func(): selected += 1)
 await process_frame
 view.grab_focus()
 var key = InputEventAction.new(); key.action = "ui_accept"; key.pressed = true
 view._gui_input(key)
 var focused = view.has_focus() and selected == 1
 view.configure(Cards.ALL["jab"], false)
 var click = InputEventMouseButton.new(); click.button_index = MOUSE_BUTTON_LEFT; click.pressed = true
 view._gui_input(click)
 var disabled = selected == 1
 var art_ok = CardView.ART.size() == 5
 var ok = focused and disabled and art_ok
 print("CARTAS: ", "OK" if ok else "FALHOU", " ", [focused, disabled, art_ok])
 quit(0 if ok else 1)

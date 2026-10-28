extends Control
const Combat = preload("res://scripts/combat.gd")
const Cards = preload("res://data/cards.gd")
const CardView = preload("res://scripts/card_view.gd")
const Rooftop = preload("res://assets/art/rooftop_empty.png")
const FighterActor = preload("res://scripts/fighter_actor.gd")
var battle = Combat.new()
var screen := "title"
var buttons: Array[Control] = []
var flash := 0.0
var hero_actor: Node2D
var rival_actor: Node2D
var pending_jab_result := ""
var fight_serial := 0
var result_visible := false
func _ready() -> void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 hero_actor = FighterActor.new(); hero_actor.setup(true); hero_actor.position = Vector2(270, 425); add_child(hero_actor)
 rival_actor = FighterActor.new(); rival_actor.setup(false); rival_actor.position = Vector2(995, 425); add_child(rival_actor)
 hero_actor.jab_impact.connect(_jab_impact)
 _show_title()
func _clear_buttons() -> void:
 for b in buttons: b.queue_free()
 buttons.clear()
func _button(label: String, pos: Vector2, size: Vector2, callback: Callable, color: Color = Color("233449")) -> Button:
 var b = Button.new()
 b.text = label
 b.position = pos; b.size = size
 b.add_theme_font_size_override("font_size", 18)
 b.add_theme_color_override("font_color", Color("eef7ff"))
 var box = StyleBoxFlat.new(); box.bg_color = color; box.border_color = Color("59d9e8"); box.set_border_width_all(1); box.set_corner_radius_all(4); box.content_margin_left = 10; box.content_margin_right = 10
 b.add_theme_stylebox_override("normal", box)
 var hover = box.duplicate(); hover.bg_color = color.lightened(0.18); b.add_theme_stylebox_override("hover", hover)
 var disabled = box.duplicate(); disabled.bg_color = Color("17202b"); disabled.border_color = Color("384554"); b.add_theme_stylebox_override("disabled", disabled)
 b.pressed.connect(callback)
 add_child(b); buttons.append(b)
 return b
func _show_title() -> void:
 fight_serial += 1; pending_jab_result = ""
 screen = "title"; hero_actor.reset_actor(); rival_actor.reset_actor(); hero_actor.hide(); rival_actor.hide(); _clear_buttons()
 _button("INICIAR CONFRONTO  →", Vector2(90, 510), Vector2(310, 58), _start, Color("13505d"))
 queue_redraw()
func _start() -> void:
 fight_serial += 1; pending_jab_result = ""; result_visible = false
 hero_actor.reset_actor(); rival_actor.reset_actor()
 battle.start(randi()); screen = "battle"; hero_actor.show(); rival_actor.show(); _refresh()
func _refresh() -> void:
 _clear_buttons()
 if battle.result != "":
  result_visible = true
  hero_actor.hide(); rival_actor.hide()
  _button("JOGAR NOVAMENTE", Vector2(485, 480), Vector2(310, 58), _start, Color("13505d"))
  _button("MENU", Vector2(485, 550), Vector2(310, 45), _show_title)
 else:
  for i in range(battle.hand.size()):
   var card: Dictionary = Cards.ALL[battle.hand[i]]
   var view = CardView.new()
   view.position = Vector2(32 + i * 197, 501)
   view.size = Vector2(186, 177)
   view.configure(card, card.cost <= battle.energy)
   view.selected.connect(_play.bind(i))
   add_child(view); buttons.append(view)
  _button("ENCERRAR\nTURNO  →", Vector2(1040, 520), Vector2(205, 86), _end_turn, Color("193e4b"))
 queue_redraw()
func _play(index: int) -> void:
 if index < 0 or index >= battle.hand.size(): return
 var id: String = battle.hand[index]
 var effect: String = Cards.ALL[id].effect
 var old_hp: int = battle.enemy_hp
 var old_guard: int = battle.enemy_guard
 if battle.play(index):
  if id == "jab":
   pending_jab_result = "hit" if battle.enemy_hp < old_hp else "guard" if battle.enemy_guard < old_guard else "none"
   hero_actor.action("jab")
   if battle.result != "":
    _clear_buttons()
    var serial = fight_serial
    get_tree().create_timer(0.85).timeout.connect(func():
     if serial == fight_serial and screen == "battle": _refresh()
    )
   else: _refresh()
  else:
   pending_jab_result = ""
   hero_actor.action(effect)
   if effect in ["damage", "throw"]: rival_actor.action("hit")
   _pulse(); _refresh()
func _jab_impact() -> void:
 if screen != "battle" or pending_jab_result == "": return
 if pending_jab_result == "hit": rival_actor.action("hit")
 elif pending_jab_result == "guard": rival_actor.action("guard")
 if pending_jab_result != "none": _pulse()
 pending_jab_result = ""
func _end_turn() -> void:
 pending_jab_result = ""
 hero_actor.reset_actor()
 var offensive: bool = battle.intent.get("kind", "") != "guard"
 battle.end_turn()
 rival_actor.action("attack" if offensive else "guard")
 if offensive: hero_actor.action("hit")
 _pulse(); _refresh()
func _pulse() -> void:
 flash = 0.55
 var tween = create_tween()
 tween.tween_property(self, "flash", 0.0, 0.3)
 tween.tween_callback(queue_redraw)
func _process(_delta: float) -> void:
 if flash > 0.0: queue_redraw()
func _text(value: String, x: float, y: float, size: int, color: Color = Color("ecf5fa")) -> void:
 draw_string(ThemeDB.fallback_font, Vector2(x,y), value, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)
func _draw() -> void:
 draw_texture_rect(Rooftop, Rect2(0,0,1280,720), false)
 draw_rect(Rect2(0,0,1280,720), Color(0.02,0.04,0.08,0.24))
 if screen == "title":
  draw_rect(Rect2(0,0,620,720), Color(0.025,0.045,0.075,0.80))
  _text("SISTEMA  /  ARQUIVO 001", 90, 100, 16, Color("58d8e6"))
  _text("RANK", 82, 240, 100)
  _text("ZERO", 82, 335, 100, Color("61dbe5"))
  _text("ASCENDA A PARTIR DO NADA.", 90, 390, 20, Color("aabcc9"))
  _text("PROTÓTIPO  /  COMBATE 1×1", 90, 465, 16, Color("aabcc9"))
  return
 # Frame the floor inside the playable arena, above the card tray.
 draw_texture_rect_region(Rooftop, Rect2(0,0,1280,445), Rect2(0,120,1956,684))
 draw_rect(Rect2(0,0,1280,445), Color(0.02,0.04,0.08,0.14))
 draw_rect(Rect2(0,0,1280,150), Color(0.025,0.045,0.075,0.85))
 draw_rect(Rect2(0,445,1280,275), Color(0.025,0.045,0.075,0.96))
 draw_line(Vector2(0,445), Vector2(1280,445), Color("54c8d6"), 2)
 draw_rect(Rect2(430,53,420,72), Color(0.025,0.045,0.075,0.87))
 _text("RANK ZERO   //   CONFRONTO 01", 35, 38, 19, Color("6ee2ed"))
 _text("TURNO %d" % battle.turn, 1120, 38, 18)
 _text("PROTAGONISTA", 60, 89, 19)
 _text("VIDA %d / 50     GUARDA %d" % [battle.hp, battle.guard], 60, 118, 18, Color("8ce2ee"))
 _text("RIVAL  /  CAIO", 868, 89, 19)
 _text("VIDA %d / 45     GUARDA %d" % [battle.enemy_hp, battle.enemy_guard], 868, 118, 18, Color("ffa5a5"))
 draw_rect(Rect2(60,130,300,7), Color("283b49")); draw_rect(Rect2(60,130,300.0*battle.hp/50,7), Color("5bd6e2"))
 draw_rect(Rect2(868,130,300,7), Color("49303a")); draw_rect(Rect2(868,130,300.0*battle.enemy_hp/45,7), Color("f17b81"))
 _text("INTENÇÃO: " + battle.intent.label, 450, 77, 18, Color("ffc78d"))
 _text("ABERTURA %d   ·   DESEQUILÍBRIO %d" % [battle.opening, battle.off_balance], 450, 105, 16, Color("c7d5df"))
 _text("SISTEMA  /  ENERGIA %d / 3     CONTRA %d" % [battle.energy, battle.counter], 38, 475, 18, Color("73dce7"))
 _text("%s  ·  COMPRA %d  /  DESCARTE %d" % [battle.log, battle.deck.size(), battle.discard.size()], 38, 708, 14, Color("9db1bf"))
 if flash > 0: draw_rect(Rect2(0,0,1280,440), Color(0.5,0.9,1.0,flash * 0.2))
 if battle.result != "" and result_visible:
  draw_rect(Rect2(0,0,1280,720), Color(0.02,0.04,0.08,0.91))
  _text("CONFRONTO ENCERRADO", 470, 250, 22, Color("72dce7"))
  _text(battle.result.to_upper(), 465, 350, 70)
  _text("O resultado desta luta é apenas o início.", 465, 405, 18, Color("b2c4cd"))

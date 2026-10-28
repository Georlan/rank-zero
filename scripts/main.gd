extends Control
const Combat = preload("res://scripts/combat.gd")
const Cards = preload("res://data/cards.gd")
const CardView = preload("res://scripts/card_view.gd")
const Rooftop = preload("res://assets/art/rooftop_empty.png")
const Hero = preload("res://assets/art/fighter_protagonist.png")
const Rival = preload("res://assets/art/fighter_caio.png")
var battle = Combat.new()
var screen := "title"
var buttons: Array[Control] = []
var flash := 0.0
var hero_shift := 0.0
var rival_shift := 0.0
var elapsed := 0.0
var hero_tween: Tween
var rival_tween: Tween
func _ready() -> void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
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
 screen = "title"; _clear_buttons()
 _button("INICIAR CONFRONTO  →", Vector2(90, 510), Vector2(310, 58), _start, Color("13505d"))
 queue_redraw()
func _start() -> void:
 battle.start(randi()); screen = "battle"; hero_shift = 0; rival_shift = 0; _refresh()
func _refresh() -> void:
 _clear_buttons()
 if battle.result != "":
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
 var effect: String = Cards.ALL[battle.hand[index]].effect
 if battle.play(index):
  if effect in ["damage", "throw"]:
   _move_fighter(true, 35.0)
   _move_fighter(false, 12.0)
  elif effect in ["guard", "counter"]:
   _move_fighter(true, -9.0)
  else:
   _move_fighter(true, 14.0)
  _pulse(); _refresh()
func _end_turn() -> void:
 var offensive: bool = battle.intent.get("kind", "") != "guard"
 battle.end_turn()
 if offensive:
  _move_fighter(false, -35.0)
  _move_fighter(true, -12.0)
 else:
  _move_fighter(false, 9.0)
 _pulse(); _refresh()
func _move_fighter(hero: bool, distance: float) -> void:
 # Pure presentation: combat is already resolved and never waits for animation.
 if hero and is_instance_valid(hero_tween): hero_tween.kill()
 if not hero and is_instance_valid(rival_tween): rival_tween.kill()
 var tween = create_tween()
 if hero: hero_tween = tween
 else: rival_tween = tween
 var property = "hero_shift" if hero else "rival_shift"
 tween.tween_property(self, property, distance, 0.10).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
 tween.tween_property(self, property, 0.0, 0.24).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
func _pulse() -> void:
 flash = 0.55
 var tween = create_tween()
 tween.tween_property(self, "flash", 0.0, 0.3)
 tween.tween_callback(queue_redraw)
func _process(delta: float) -> void:
 elapsed += delta
 if screen == "battle": queue_redraw()
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
 # Independent transparent character layers; subtle idle sway and action offsets.
 var idle = sin(elapsed * 2.1) * 2.0
 draw_texture_rect(Hero, Rect2(155 + hero_shift, 163 + idle, 232, 283), false)
 draw_texture_rect(Rival, Rect2(880 + rival_shift, 163 - idle, 232, 283), false)
 draw_rect(Rect2(0,0,1280,150), Color(0.025,0.045,0.075,0.85))
 draw_rect(Rect2(0,445,1280,275), Color(0.025,0.045,0.075,0.96))
 draw_line(Vector2(0,445), Vector2(1280,445), Color("54c8d6"), 2)
 draw_rect(Rect2(430,155,420,78), Color(0.025,0.045,0.075,0.87))
 _text("RANK ZERO   //   CONFRONTO 01", 35, 38, 19, Color("6ee2ed"))
 _text("TURNO %d" % battle.turn, 1120, 38, 18)
 _text("PROTAGONISTA", 60, 89, 19)
 _text("VIDA %d / 50     GUARDA %d" % [battle.hp, battle.guard], 60, 118, 18, Color("8ce2ee"))
 _text("RIVAL  /  CAIO", 868, 89, 19)
 _text("VIDA %d / 45     GUARDA %d" % [battle.enemy_hp, battle.enemy_guard], 868, 118, 18, Color("ffa5a5"))
 draw_rect(Rect2(60,130,300,7), Color("283b49")); draw_rect(Rect2(60,130,300.0*battle.hp/50,7), Color("5bd6e2"))
 draw_rect(Rect2(868,130,300,7), Color("49303a")); draw_rect(Rect2(868,130,300.0*battle.enemy_hp/45,7), Color("f17b81"))
 _text("INTENÇÃO: " + battle.intent.label, 450, 177, 18, Color("ffc78d"))
 _text("ABERTURA %d   ·   DESEQUILÍBRIO %d" % [battle.opening, battle.off_balance], 450, 207, 16, Color("c7d5df"))
 _text("SISTEMA  /  ENERGIA %d / 3     CONTRA %d" % [battle.energy, battle.counter], 38, 475, 18, Color("73dce7"))
 _text("%s  ·  COMPRA %d  /  DESCARTE %d" % [battle.log, battle.deck.size(), battle.discard.size()], 38, 708, 14, Color("9db1bf"))
 if flash > 0: draw_rect(Rect2(0,0,1280,440), Color(0.5,0.9,1.0,flash * 0.2))
 if battle.result != "":
  draw_rect(Rect2(0,0,1280,720), Color(0.02,0.04,0.08,0.91))
  _text("CONFRONTO ENCERRADO", 470, 250, 22, Color("72dce7"))
  _text(battle.result.to_upper(), 465, 350, 70)
  _text("O resultado desta luta é apenas o início.", 465, 405, 18, Color("b2c4cd"))

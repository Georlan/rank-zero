extends Control
const Combat = preload("res://scripts/combat.gd")
const Cards = preload("res://data/cards.gd")
const Style = preload("res://scripts/ui_style.gd")
const CardView = preload("res://scripts/card_view.gd")
const Rooftop = preload("res://assets/art/rooftop_empty.png")
const TitleArt = preload("res://assets/art/rooftop_duel.png")
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
 b.add_theme_font_override("font", Style.DISPLAY)
 b.add_theme_color_override("font_color", Color("eef7ff"))
 var box = StyleBoxFlat.new(); box.bg_color = color; box.border_color = Color("7ce9f2"); box.set_border_width_all(1); box.set_corner_radius_all(3); box.content_margin_left = 10; box.content_margin_right = 10
 b.add_theme_stylebox_override("normal", box)
 var hover = box.duplicate(); hover.bg_color = color.lightened(0.18); b.add_theme_stylebox_override("hover", hover)
 var disabled = box.duplicate(); disabled.bg_color = Color("17202b"); disabled.border_color = Color("384554"); b.add_theme_stylebox_override("disabled", disabled)
 b.pressed.connect(callback)
 add_child(b); buttons.append(b)
 return b
func _show_title() -> void:
 fight_serial += 1; pending_jab_result = ""
 screen = "title"; hero_actor.reset_actor(); rival_actor.reset_actor(); hero_actor.hide(); rival_actor.hide(); _clear_buttons()
 _button("ENTRAR NO COMBATE", Vector2(90, 510), Vector2(300, 58), _start, Color("18556a"))
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
   view.position = Vector2(32 + i * 197, 486)
   view.size = Vector2(186, 204)
   view.configure(card, card.cost <= battle.energy)
   view.selected.connect(_play.bind(i))
   add_child(view); buttons.append(view)
  _button("ENCERRAR TURNO", Vector2(1040, 533), Vector2(205, 60), _end_turn, Color("174459"))
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
 draw_string(Style.BODY, Vector2(x,y), value, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)
func _display(value: String, x: float, y: float, size: int, color: Color = Style.TEXT) -> void:
 draw_string(Style.DISPLAY, Vector2(x,y), value, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)
func _panel(rect: Rect2, edge: Color = Color("588a9d")) -> void:
 draw_rect(rect, Color(0.035, 0.10, 0.16, 0.91))
 draw_rect(rect, edge, false, 1)
 draw_line(rect.position, rect.position + Vector2(24, 0), Style.CYAN, 2)
func _mark(label: String, x: float, y: float, scale: float, color: Color) -> void:
 # Original geometric wordmark, not a general-purpose typeface.
 var paths = {
  "R": [[0,1,0,0,0.72,0,1,0.22,0.72,0.47,0,0.47],[0.46,0.47,1,1]],
  "A": [[0,1,0.45,0,0.60,0,1,1],[0.18,0.63,0.82,0.63]],
  "N": [[0,1,0,0,1,1,1,0]],
  "K": [[0,0,0,1],[1,0,0.05,0.55,1,1]],
  "Z": [[0,0,1,0,0,1,1,1]],
  "E": [[1,0,0,0,0,1,1,1],[0,0.5,0.78,0.5]],
  "O": [[0.18,0,0.82,0,1,0.18,1,0.82,0.82,1,0.18,1,0,0.82,0,0.18,0.18,0]]
 }
 var cursor = x
 for letter in label:
  if letter == " ": cursor += scale * 0.35; continue
  for path in paths.get(letter, []):
   var points = PackedVector2Array()
   for i in range(0,path.size(),2): points.append(Vector2(cursor + path[i]*scale*0.7, y + path[i+1]*scale))
   draw_polyline(points, color, maxf(3.0, scale*0.09), true)
  cursor += scale * 0.94
func _draw() -> void:
 draw_texture_rect(TitleArt if screen == "title" else Rooftop, Rect2(0,0,1280,720), false)
 draw_rect(Rect2(0,0,1280,720), Color(0.01,0.035,0.07,0.28))
 if screen == "title":
  draw_rect(Rect2(0,0,605,720), Color(0.02,0.07,0.12,0.93))
  draw_line(Vector2(65,76),Vector2(65,572),Color("5bcfe1"),2)
  _text("UM CONFRONTO. UM NOVO COMEÇO.",90,110,14,Style.CYAN)
  _mark("RANK", 90, 175, 75, Style.TEXT)
  _mark("ZERO", 90, 275, 75, Style.CYAN)
  draw_line(Vector2(90,395),Vector2(430,395),Color("497a8f"),1)
  _display("ASCENDA A PARTIR DO NADA",90,437,23,Style.TEXT)
  _text("Protótipo de combate · 1 contra 1",90,469,14,Style.MUTED)
  return
 draw_texture_rect_region(Rooftop, Rect2(0,0,1280,445), Rect2(0,120,1956,684))
 draw_rect(Rect2(0,0,1280,445), Color(0.02,0.04,0.08,0.12))
 draw_rect(Rect2(0,0,1280,42),Color(0.025,0.08,0.13,0.95))
 _display("RANK ZERO",30,29,20,Style.TEXT)
 _text("CONFRONTO",165,28,12,Style.MUTED)
 _display("TURNO %d" % battle.turn,1160,28,16,Style.CYAN)
 # HUD lives on a single quiet scrim so the arena remains the focus.
 draw_rect(Rect2(0,42,1280,103),Color(0.025,0.055,0.085,0.78))
 _display("PROTAGONISTA",40,78,17,Style.TEXT)
 _display("CAIO",950,78,17,Style.TEXT)
 _text("VIDA",40,104,11,Style.MUTED)
 _display("%d / 50" % battle.hp,78,105,16,Style.TEXT)
 _text("GUARDA",220,104,11,Style.MUTED)
 _display(str(battle.guard),285,105,16,Style.CYAN)
 _text("VIDA",950,104,11,Style.MUTED)
 _display("%d / 45" % battle.enemy_hp,988,105,16,Style.TEXT)
 _text("GUARDA",1130,104,11,Style.MUTED)
 _display(str(battle.enemy_guard),1195,105,16,Style.CYAN)
 draw_rect(Rect2(40,118,285,5), Color("284454")); draw_rect(Rect2(40,118,285.0*battle.hp/50,5), Style.CYAN)
 draw_rect(Rect2(950,118,285,5), Color("4f3940")); draw_rect(Rect2(950,118,285.0*battle.enemy_hp/45,5), Style.CORAL)
 draw_line(Vector2(374,58),Vector2(374,119),Color("75b4c3"),2)
 _text("INTENÇÃO DO RIVAL",390,76,11,Style.MUTED)
 _display(battle.intent.label,390,101,18,Style.CORAL)
 _text("Abertura %d    Desequilíbrio %d" % [battle.opening,battle.off_balance],630,101,12,Style.TEXT)
 draw_rect(Rect2(0,445,1280,275),Color(0.025,0.07,0.115,0.97))
 draw_line(Vector2(0,445),Vector2(1280,445),Color("71dbe9"),2)
 _display("SISTEMA",32,476,17,Style.CYAN)
 _text("ENERGIA",145,475,12,Style.MUTED)
 for i in range(3):
  var cx = 227 + i * 23
  var gem = PackedVector2Array([Vector2(cx,463),Vector2(cx+7,470),Vector2(cx,477),Vector2(cx-7,470)])
  draw_colored_polygon(gem,Style.CYAN if i < battle.energy else Color("365364"))
 _text("CONTRA %d" % battle.counter,320,475,12,Style.MUTED)
 _text("%s  ·  COMPRA %d  /  DESCARTE %d" % [battle.log, battle.deck.size(), battle.discard.size()], 38, 708, 12, Style.MUTED)
 if flash > 0: draw_rect(Rect2(0,0,1280,440), Color(0.5,0.9,1.0,flash * 0.2))
 if battle.result != "" and result_visible:
  draw_rect(Rect2(0,0,1280,720), Color(0.02,0.04,0.08,0.94))
  _panel(Rect2(430,205,420,230))
  _text("CONFRONTO ENCERRADO",468,251,15,Style.CYAN)
  _display(battle.result.to_upper(),468,340,62,Style.TEXT)
  _text("O resultado desta luta é apenas o início.",468,397,14,Style.MUTED)

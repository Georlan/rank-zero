extends Control
signal selected
const Style = preload("res://scripts/ui_style.gd")
var card: Dictionary
var affordable := true
var hovered := false
func configure(data: Dictionary, can_play: bool) -> void:
 card = data; affordable = can_play
 mouse_filter = Control.MOUSE_FILTER_STOP
 mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 focus_mode = Control.FOCUS_ALL
 mouse_entered.connect(func(): hovered = true; queue_redraw())
 mouse_exited.connect(func(): hovered = false; queue_redraw())
 focus_entered.connect(queue_redraw)
 focus_exited.connect(queue_redraw)
func _gui_input(event: InputEvent) -> void:
 if affordable and ((event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or (event.is_action_pressed("ui_accept") and has_focus())):
  selected.emit(); accept_event()
func _glyph(kind: String, accent: Color) -> void:
 var c = Vector2(25, 75)
 if kind in ["damage", "throw"]:
  draw_line(c + Vector2(-7, 8), c + Vector2(8, -8), accent, 3)
  draw_line(c + Vector2(0, -8), c + Vector2(8, -8), accent, 3)
  draw_line(c + Vector2(8, -8), c + Vector2(8, 0), accent, 3)
 elif kind in ["guard", "counter"]:
  draw_polyline(PackedVector2Array([c+Vector2(-8,-7),c+Vector2(8,-7),c+Vector2(8,2),c+Vector2(0,9),c+Vector2(-8,2),c+Vector2(-8,-7)]), accent, 2)
  if kind == "counter": draw_line(c+Vector2(-3,1), c+Vector2(4,-4),accent,2)
 else:
  draw_line(c+Vector2(-8,0),c+Vector2(8,0),accent,2)
  draw_line(c+Vector2(0,-8),c+Vector2(0,8),accent,2)
  draw_circle(c, 3, accent)
func _draw() -> void:
 if card.is_empty(): return
 var colors = {"damage": Style.CORAL, "throw": Style.CORAL, "guard": Style.CYAN, "counter": Style.CYAN, "opening": Style.PURPLE}
 var accent: Color = colors.get(card.effect, Style.TEXT)
 if not affordable: accent = Color("718492")
 var base = Color("112638") if affordable else Color("111c29")
 if hovered and affordable: base = base.lightened(0.15)
 draw_rect(Rect2(3,5,size.x-3,size.y-5), Color(0,0,0,0.38))
 var polygon = PackedVector2Array([Vector2(0,0), Vector2(size.x-12,0), Vector2(size.x,12), Vector2(size.x,size.y), Vector2(0,size.y)])
 draw_colored_polygon(polygon, base)
 draw_polyline(PackedVector2Array([Vector2(0,size.y),Vector2(0,0),Vector2(size.x-12,0),Vector2(size.x,12),Vector2(size.x,size.y),Vector2(0,size.y)]), accent if hovered or has_focus() else Color("597f91"), 1.5)
 draw_rect(Rect2(0,0,5,39), accent)
 draw_rect(Rect2(7,8,size.x-51,27), Color("1b3b4f"))
 draw_string(Style.DISPLAY, Vector2(14,28), card.name, HORIZONTAL_ALIGNMENT_LEFT, size.x-62, 16 if card.name.length() < 16 else 13, Style.TEXT)
 draw_circle(Vector2(size.x-23,22), 15, Color("092131"))
 draw_arc(Vector2(size.x-23,22), 15, 0, TAU, 32, accent, 2)
 draw_string(Style.DISPLAY, Vector2(size.x-29,28), str(card.cost), HORIZONTAL_ALIGNMENT_LEFT, 16, 17, Style.TEXT)
 draw_string(Style.BODY, Vector2(14,53), card.type, HORIZONTAL_ALIGNMENT_LEFT, size.x-28, 10, accent)
 draw_rect(Rect2(11,61,size.x-22,29), Color("0c1c2a"))
 _glyph(card.effect,accent)
 draw_string(Style.BODY, Vector2(43,80), "EFEITO" if card.effect == "opening" else "REAÇÃO" if card.effect == "counter" else "DEFESA" if card.effect == "guard" else "ATAQUE", HORIZONTAL_ALIGNMENT_LEFT, size.x-55, 10, Style.MUTED)
 draw_multiline_string(Style.BODY, Vector2(12,109), card.description, HORIZONTAL_ALIGNMENT_LEFT, size.x-24, 12, 4, Style.TEXT if affordable else Style.MUTED)
 if not affordable: draw_string(Style.DISPLAY, Vector2(12,size.y-8), "SEM ENERGIA", HORIZONTAL_ALIGNMENT_LEFT, size.x-24, 10, Style.MUTED)

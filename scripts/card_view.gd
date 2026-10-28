extends Control
signal selected
var card: Dictionary
var affordable := true
var hovered := false
const FONT_SIZE = 15
func configure(data: Dictionary, can_play: bool) -> void:
 card = data
 affordable = can_play
 mouse_filter = Control.MOUSE_FILTER_STOP
 mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 mouse_entered.connect(func(): hovered = true; queue_redraw())
 mouse_exited.connect(func(): hovered = false; queue_redraw())
func _gui_input(event: InputEvent) -> void:
 if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and affordable:
  selected.emit()
func _draw() -> void:
 if card.is_empty(): return
 var colors = {"damage": Color("e38276"), "throw": Color("e38276"), "guard": Color("70d4db"), "counter": Color("70d4db"), "opening": Color("bda8f0")}
 var accent: Color = colors.get(card.effect, Color.WHITE)
 var bg = Color("151e2c") if affordable else Color("111722")
 if hovered and affordable: bg = bg.lightened(0.14)
 draw_rect(Rect2(Vector2.ZERO, size), bg)
 draw_rect(Rect2(Vector2.ZERO, size), accent if affordable else Color("45505c"), false, 2)
 draw_rect(Rect2(0,0,size.x,5), accent)
 draw_string(ThemeDB.fallback_font, Vector2(12,27), card.name, HORIZONTAL_ALIGNMENT_LEFT, size.x-46, 13 if card.name.length() > 15 else FONT_SIZE, Color("f3f4f3"))
 draw_circle(Vector2(size.x-21,22), 13, accent.darkened(0.55))
 draw_string(ThemeDB.fallback_font, Vector2(size.x-26,28), str(card.cost), HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color.WHITE)
 draw_string(ThemeDB.fallback_font, Vector2(12,52), card.type, HORIZONTAL_ALIGNMENT_LEFT, size.x-24, 11, accent)
 draw_line(Vector2(12,63), Vector2(size.x-12,63), Color("39495a"), 1)
 draw_multiline_string(ThemeDB.fallback_font, Vector2(12,90), card.description, HORIZONTAL_ALIGNMENT_LEFT, size.x-24, 14, 4, Color("c8d3d9"))
 draw_string(ThemeDB.fallback_font, Vector2(12,size.y-13), "TÉCNICA   /   %s" % ("01" if affordable else "SEM ENERGIA"), HORIZONTAL_ALIGNMENT_LEFT, size.x-24, 10, accent)

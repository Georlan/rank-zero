extends Control
signal selected
const Style = preload("res://scripts/ui_style.gd")
const SHEET = preload("res://assets/pixel/protagonist_sheet.png")
const TECHNIQUES = preload("res://assets/pixel/card_techniques_sheet.png")
# The frame is an illustration, not a second implementation of the card rules.
const ART_FRAME = {"damage": Vector2i(0,1), "guard": Vector2i(0,0), "opening": Vector2i(1,0), "throw": Vector2i(0,1), "counter": Vector2i(1,1)}
# Keep ART available to existing tests and consumers.
const ART = ART_FRAME
var card: Dictionary
var affordable := true
var hovered := false
var chosen := false
var rise := 0.0
func configure(data: Dictionary, can_play: bool) -> void:
 card = data; affordable = can_play; queue_redraw()
func _ready() -> void:
 texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
 mouse_filter = Control.MOUSE_FILTER_STOP
 mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 focus_mode = Control.FOCUS_ALL
 mouse_entered.connect(func(): hovered = true; queue_redraw())
 mouse_exited.connect(func(): hovered = false; queue_redraw())
 focus_entered.connect(queue_redraw); focus_exited.connect(queue_redraw)
func _process(delta: float) -> void:
 var target = 7.0 if affordable and (hovered or has_focus()) else 0.0
 var next = move_toward(rise, target, delta * 50.0)
 if not is_equal_approx(rise, next): rise = next; queue_redraw()
func _gui_input(event: InputEvent) -> void:
 if affordable and ((event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or (event.is_action_pressed("ui_accept") and has_focus())):
  selected.emit(); accept_event()
func _draw() -> void:
 if card.is_empty(): return
 draw_set_transform(Vector2(0,-rise))
 var paper = Color("e7d8b9") if affordable else Color("a39b8b")
 var ink = Color("263345")
 var points = PackedVector2Array([Vector2(4,3),Vector2(size.x-6,2),Vector2(size.x-2,8),Vector2(size.x-4,size.y-4),Vector2(8,size.y-2),Vector2(3,size.y-8)])
 draw_colored_polygon(PackedVector2Array([Vector2(8,9),Vector2(size.x,size.y*0+9),Vector2(size.x,size.y),Vector2(8,size.y)]), Color(0,0,0,0.35))
 draw_colored_polygon(points, paper)
 if hovered or has_focus() or chosen: draw_polyline(PackedVector2Array([points[0],points[1],points[2],points[3],points[4],points[5],points[0]]),Color("d18455"),3)
 draw_string(Style.DISPLAY,Vector2(13,27),card.name,HORIZONTAL_ALIGNMENT_LEFT,size.x-49,16 if card.name.length()<16 else 13,ink)
 draw_circle(Vector2(size.x-22,21),13,Color("38445a"))
 draw_string(Style.DISPLAY,Vector2(size.x-28,27),str(card.cost),HORIZONTAL_ALIGNMENT_LEFT,14,16,Color("f7ead0"))
 var f: Vector2i = ART_FRAME[card.effect]
 var artwork = SHEET if card.effect == "damage" else TECHNIQUES
 draw_texture_rect_region(artwork,Rect2(48,34,90,80),Rect2(f.x*665,f.y*591,665,591),Color.WHITE if affordable else Color(0.6,0.6,0.6))
 draw_line(Vector2(12,116),Vector2(size.x-12,116),Color("9b8b76"),1)
 draw_string(Style.DISPLAY,Vector2(12,130),card.type,HORIZONTAL_ALIGNMENT_LEFT,size.x-24,11,Color("70513f"))
 draw_multiline_string(Style.BODY,Vector2(12,149),card.description,HORIZONTAL_ALIGNMENT_LEFT,size.x-24,12,4,ink)
 if not affordable: draw_string(Style.DISPLAY,Vector2(12,size.y-8),"SEM ENERGIA",HORIZONTAL_ALIGNMENT_LEFT,size.x-24,10,ink)
 draw_set_transform(Vector2.ZERO)

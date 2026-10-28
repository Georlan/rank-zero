extends Control
signal selected
const Style = preload("res://scripts/ui_style.gd")
const ART = {
 "damage": preload("res://assets/cards/jab.png"),
 "guard": preload("res://assets/cards/guard.png"),
 "opening": preload("res://assets/cards/feint.png"),
 "throw": preload("res://assets/cards/throw.png"),
 "counter": preload("res://assets/cards/counter.png")
}
var card: Dictionary
var affordable := true
var hovered := false
var rise := 0.0
func configure(data: Dictionary, can_play: bool) -> void:
 card = data; affordable = can_play
 queue_redraw()
func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_STOP
 mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 focus_mode = Control.FOCUS_ALL
 mouse_entered.connect(func(): hovered = true; queue_redraw())
 mouse_exited.connect(func(): hovered = false; queue_redraw())
 focus_entered.connect(queue_redraw)
 focus_exited.connect(queue_redraw)
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
 var accent: Color = Color("82cfe4") if card.effect in ["guard", "counter"] else Color("efb298") if card.effect in ["damage", "throw"] else Color("bbafe3")
 var edge: Color = accent if affordable and (hovered or has_focus()) else Color("607383") if affordable else Color("47535e")
 draw_rect(Rect2(4,5,size.x-4,size.y-4),Color(0,0,0,0.45))
 draw_rect(Rect2(Vector2.ZERO,size),Color("101923") if affordable else Color("151a20"))
 draw_rect(Rect2(Vector2.ZERO,size),edge,false,2)
 draw_rect(Rect2(5,5,size.x-10,29),Color("23303c"))
 draw_string(Style.DISPLAY,Vector2(12,26),card.name,HORIZONTAL_ALIGNMENT_LEFT,size.x-51,16 if card.name.length()<16 else 13,Style.TEXT)
 draw_circle(Vector2(size.x-22,20),14,Color("112334"))
 draw_arc(Vector2(size.x-22,20),14,0,TAU,28,accent if affordable else Color("70818a"),2)
 draw_string(Style.DISPLAY,Vector2(size.x-28,26),str(card.cost),HORIZONTAL_ALIGNMENT_LEFT,14,16,Style.TEXT)
 var texture: Texture2D = ART[card.effect]
 draw_texture_rect_region(texture,Rect2(6,39,size.x-12,70),Rect2(0,160,1536,650),Color.WHITE if affordable else Color(0.5,0.5,0.5,1))
 draw_rect(Rect2(6,111,size.x-12,18),Color("1b2a36"))
 draw_string(Style.DISPLAY,Vector2(12,124),card.type,HORIZONTAL_ALIGNMENT_LEFT,size.x-24,11,accent)
 draw_multiline_string(Style.BODY,Vector2(12,148),card.description,HORIZONTAL_ALIGNMENT_LEFT,size.x-24,12,4,Style.TEXT if affordable else Style.MUTED)
 if not affordable: draw_string(Style.DISPLAY,Vector2(12,size.y-8),"SEM ENERGIA",HORIZONTAL_ALIGNMENT_LEFT,size.x-24,10,Style.MUTED)
 draw_set_transform(Vector2.ZERO)

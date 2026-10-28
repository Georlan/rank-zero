extends Node2D
signal jab_impact
const HERO_SHEET = preload("res://assets/pixel/protagonist_sheet.png")
const RIVAL_SHEET = preload("res://assets/pixel/rival_sheet.png")
var is_hero := true
var sprite: AnimatedSprite2D
var action_tween: Tween
var home_x := 0.0
func setup(hero: bool) -> void:
 is_hero = hero
func _frame(sheet: Texture2D, column: int, row: int) -> AtlasTexture:
 var texture = AtlasTexture.new()
 texture.atlas = sheet
 texture.region = Rect2(column * 665, row * 591, 665, 591)
 return texture
func _ready() -> void:
 home_x = position.x
 sprite = AnimatedSprite2D.new()
 var frames = SpriteFrames.new()
 var sheet = HERO_SHEET if is_hero else RIVAL_SHEET
 var guard = _frame(sheet, 0, 0)
 var windup = _frame(sheet, 1, 0)
 var punch = _frame(sheet, 0, 1)
 var special = _frame(sheet, 1, 1)
 frames.add_animation("guard"); frames.set_animation_loop("guard", true); frames.add_frame("guard", guard)
 if is_hero:
  frames.add_animation("jab"); frames.set_animation_loop("jab", false); frames.set_animation_speed("jab", 12.0)
  frames.add_frame("jab", guard, 0.8); frames.add_frame("jab", windup, 1.0)
  frames.add_frame("jab", punch, 1.8); frames.add_frame("jab", windup, 0.8); frames.add_frame("jab", guard, 1.0)
  frames.add_animation("defend"); frames.set_animation_loop("defend", false); frames.set_animation_speed("defend", 9.0)
  frames.add_frame("defend", special, 2.0); frames.add_frame("defend", guard, 1.0)
  frames.add_animation("feint"); frames.set_animation_loop("feint", false); frames.set_animation_speed("feint", 12.0)
  frames.add_frame("feint", windup, 1.3); frames.add_frame("feint", guard, 1.0)
 else:
  frames.add_animation("hit"); frames.set_animation_loop("hit", false); frames.set_animation_speed("hit", 9.0)
  frames.add_frame("hit", special, 1.5); frames.add_frame("hit", guard, 1.0)
 sprite.sprite_frames = frames
 sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
 sprite.flip_h = not is_hero
 sprite.scale = Vector2(0.36, 0.36)
 sprite.position = Vector2(0, -106)
 sprite.animation_finished.connect(_on_animation_finished)
 sprite.frame_changed.connect(_on_frame_changed)
 add_child(sprite)
 sprite.play("guard")
func _on_animation_finished() -> void:
 sprite.play("guard")
func _on_frame_changed() -> void:
 if is_hero and sprite.animation == "jab" and sprite.frame == 2: jab_impact.emit()
func _draw() -> void:
 draw_set_transform(Vector2(0, -2), 0, Vector2(1, 0.18))
 draw_circle(Vector2.ZERO, 70, Color(0, 0, 0, 0.38))
 draw_set_transform(Vector2.ZERO)
func reset_actor() -> void:
 if is_instance_valid(action_tween): action_tween.kill()
 position.x = home_x; sprite.position.x = 0; sprite.play("guard")
func action(kind: String) -> void:
 if is_instance_valid(action_tween): action_tween.kill()
 if is_hero and kind == "jab":
  sprite.stop(); sprite.play("guard")
  action_tween = create_tween()
  action_tween.tween_property(self, "position:x", 805.0, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
  action_tween.tween_callback(func(): sprite.play("jab"))
  action_tween.tween_interval(0.36)
  action_tween.tween_property(self, "position:x", home_x, 0.24).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
 elif is_hero and kind in ["guard", "opening", "counter"]:
  position.x = home_x; sprite.stop(); sprite.play("feint" if kind == "opening" else "defend")
 elif not is_hero and kind == "hit":
  sprite.stop(); sprite.play("hit"); sprite.position.x = 0
  action_tween = create_tween(); action_tween.tween_property(sprite, "position:x", 14.0, 0.08); action_tween.tween_property(sprite, "position:x", 0.0, 0.20)
 else:
  position.x = home_x; sprite.position.x = 0; sprite.play("guard")
  action_tween = create_tween()
  var direction = 8.0 if is_hero else -8.0
  action_tween.tween_property(sprite, "position:x", direction, 0.10); action_tween.tween_property(sprite, "position:x", 0.0, 0.18)

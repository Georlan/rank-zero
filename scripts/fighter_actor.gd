extends Node2D
signal jab_impact
const GUARD = preload("res://assets/art/fighter_protagonist.png")
const ANTICIPATION = preload("res://assets/art/fighter_anticipation.png")
const HIGH_GUARD = preload("res://assets/art/fighter_high_guard.png")
const JAB = preload("res://assets/art/fighter_jab.png")
const ENEMY = preload("res://assets/art/fighter_caio.png")
const ENEMY_HIT = preload("res://assets/art/fighter_caio_hit.png")
var is_hero := true
var sprite: AnimatedSprite2D
var action_tween: Tween
var home_x := 0.0
func setup(hero: bool) -> void:
 is_hero = hero
func _ready() -> void:
 home_x = position.x
 sprite = AnimatedSprite2D.new()
 var frames = SpriteFrames.new()
 frames.add_animation("guard")
 frames.set_animation_loop("guard", true)
 frames.add_frame("guard", GUARD if is_hero else ENEMY)
 if is_hero:
  frames.add_animation("jab")
  frames.set_animation_loop("jab", false)
  frames.set_animation_speed("jab", 12.0)
  frames.add_frame("jab", GUARD, 0.8)
  frames.add_frame("jab", ANTICIPATION, 1.0)
  frames.add_frame("jab", JAB, 1.8)
  frames.add_frame("jab", ANTICIPATION, 0.8)
  frames.add_frame("jab", GUARD, 1.0)
  frames.add_animation("defend")
  frames.set_animation_loop("defend", false)
  frames.set_animation_speed("defend", 9.0)
  frames.add_frame("defend", HIGH_GUARD, 2.0)
  frames.add_frame("defend", GUARD, 1.0)
  frames.add_animation("feint")
  frames.set_animation_loop("feint", false)
  frames.set_animation_speed("feint", 12.0)
  frames.add_frame("feint", ANTICIPATION, 1.3)
  frames.add_frame("feint", GUARD, 1.0)
 else:
  frames.add_animation("hit")
  frames.set_animation_loop("hit", false)
  frames.set_animation_speed("hit", 9.0)
  frames.add_frame("hit", ENEMY_HIT, 1.5)
  frames.add_frame("hit", ENEMY, 1.0)
 sprite.sprite_frames = frames
 sprite.scale = Vector2(0.19, 0.19)
 sprite.position = Vector2(0, -132)
 sprite.animation_finished.connect(_on_animation_finished)
 sprite.frame_changed.connect(_on_frame_changed)
 add_child(sprite)
 sprite.play("guard")
func _on_animation_finished() -> void:
 sprite.play("guard")
func _on_frame_changed() -> void:
 if is_hero and sprite.animation == "jab" and sprite.frame == 2:
  jab_impact.emit()
func _draw() -> void:
 draw_set_transform(Vector2(0, -2), 0, Vector2(1, 0.18))
 draw_circle(Vector2.ZERO, 90, Color(0, 0, 0, 0.36))
 draw_circle(Vector2.ZERO, 55, Color(0, 0, 0, 0.25))
 draw_set_transform(Vector2.ZERO)
func reset_actor() -> void:
 if is_instance_valid(action_tween): action_tween.kill()
 position.x = home_x
 sprite.position.x = 0
 sprite.play("guard")
func action(kind: String) -> void:
 if is_instance_valid(action_tween): action_tween.kill()
 if is_hero and kind == "jab":
  sprite.stop()
  sprite.play("guard")
  action_tween = create_tween()
  action_tween.tween_property(self, "position:x", 805.0, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
  action_tween.tween_callback(func(): sprite.play("jab"))
  action_tween.tween_interval(0.36)
  action_tween.tween_property(self, "position:x", home_x, 0.24).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
 elif is_hero and kind in ["guard", "opening", "counter"]:
  position.x = home_x
  sprite.stop()
  sprite.play("feint" if kind == "opening" else "defend")
 elif not is_hero and kind == "hit":
  sprite.stop(); sprite.play("hit")
  sprite.position.x = 0
  action_tween = create_tween()
  action_tween.tween_property(sprite, "position:x", 14.0, 0.08)
  action_tween.tween_property(sprite, "position:x", 0.0, 0.20)
 else:
  # Placeholder for actions that do not yet have their own illustrated poses.
  position.x = home_x
  sprite.position.x = 0
  sprite.play("guard")
  action_tween = create_tween()
  var direction = 8.0 if is_hero else -8.0
  action_tween.tween_property(sprite, "position:x", direction, 0.10)
  action_tween.tween_property(sprite, "position:x", 0.0, 0.18)

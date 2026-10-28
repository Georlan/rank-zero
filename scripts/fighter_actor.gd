extends Node2D
# Presentation only: positions are anchored on the floor, never on sprite centre.
const GUARD = preload("res://assets/art/fighter_protagonist.png")
const JAB = preload("res://assets/art/fighter_jab.png")
const ENEMY = preload("res://assets/art/fighter_caio.png")
var is_hero := true
var sprite: AnimatedSprite2D
var action_tween: Tween
func setup(hero: bool) -> void:
 is_hero = hero
func _ready() -> void:
 sprite = AnimatedSprite2D.new()
 var frames = SpriteFrames.new()
 frames.add_animation("guard")
 frames.set_animation_loop("guard", true)
 frames.add_frame("guard", GUARD if is_hero else ENEMY)
 if is_hero:
  frames.add_animation("jab")
  frames.set_animation_loop("jab", false)
  frames.set_animation_speed("jab", 9.0)
  frames.add_frame("jab", GUARD, 0.6)
  frames.add_frame("jab", JAB, 1.3)
  frames.add_frame("jab", GUARD, 1.0)
 sprite.sprite_frames = frames
 sprite.scale = Vector2(0.19, 0.19)
 sprite.position = Vector2(0, -132)
 sprite.animation_finished.connect(_on_animation_finished)
 add_child(sprite)
 sprite.play("guard")
func _on_animation_finished() -> void:
 sprite.play("guard")
func _draw() -> void:
 # Contact shadow remains fixed to ground as the upper body moves.
 draw_set_transform(Vector2(0, -2), 0, Vector2(1, 0.18))
 draw_circle(Vector2.ZERO, 90, Color(0, 0, 0, 0.36))
 draw_circle(Vector2.ZERO, 55, Color(0, 0, 0, 0.25))
 draw_set_transform(Vector2.ZERO)
func action(kind: String) -> void:
 if is_hero and kind == "jab":
  sprite.stop()
  sprite.play("jab")
 else:
  # Until distinct art exists, use a short recoil/step, not a claimed punch pose.
  if is_instance_valid(action_tween): action_tween.kill()
  sprite.position.x = 0
  action_tween = create_tween()
  var direction = 8.0 if is_hero else -8.0
  action_tween.tween_property(sprite, "position:x", direction, 0.10)
  action_tween.tween_property(sprite, "position:x", 0.0, 0.18)

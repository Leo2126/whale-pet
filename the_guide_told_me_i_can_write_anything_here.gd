extends Node2D

var speed=300
var direction=Vector2(-1,0)
var screen_size = Vector2()
var window_size=Vector2(300,300)
var idle_timer = 0.0
var is_idling = false
var is_dragging = false
var drag_offset = Vector2()
var showdiag = true
var window_position= Vector2(DisplayServer.window_get_position())
@onready var animated_sprite = $AnimatedSprite2D
@onready var area = $Area2D
func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	animated_sprite.play("jump_up_and_down")
	area.input_event.connect(_on_area_input)

func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			var mouse_pos = Vector2(DisplayServer.mouse_get_position())
			var window_pos = Vector2(DisplayServer.window_get_position())
			drag_offset = mouse_pos - window_pos
		else:
			is_dragging = false

func _physics_process(delta: float) -> void:
	if is_dragging:
		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		window_position = new_win_pos
		return 
	if is_idling:
		idle_timer -= delta
		if idle_timer <0:
			is_idling = false
			speed=300
			animated_sprite.play("jump_up_and_down")
		return
	window_position += direction * speed * delta
	print(window_position)
	window_position.x = clamp(window_position.x, 0, screen_size.x - window_size.x)
	window_position.y=clamp(window_position.y,0,screen_size.y-window_size.y)	
	DisplayServer.window_set_position(Vector2i(window_position))
	if window_position.x <= 0 or window_position.x >= screen_size.x-window_size.x:
		direction.x *= -1
		maybe_idle()
		animated_sprite.flip_h = !animated_sprite.flip_h
	if window_position.y <= 0 or window_position.y >= screen_size.y-window_size.y:
		direction.y *= -1
		maybe_idle()

func diag_callback(index):
	if index == 1:
		showdiag = false
		

func maybe_idle():
	if randf()<0.7:
		is_idling = true
		idle_timer = randf_range(5.0,10.0)
		var r=randi()%3
		if r==0:
			animated_sprite.play("bubbles")
			speed = 0
		elif r==1:
			animated_sprite.play("default")
			if showdiag== true:
				var rand2 = randi()%4
				var string = "The default string(you're not supposed to see this...)"
				if rand2 == 0:
					string = "Gimme 2000! tokens right now!"
				elif rand2 == 1:
					string = "Hmm, now I'm Claude. Wait no, I'm Deepseek......"
				elif rand2 ==2 :
					string = "Token😠Come here😭Token😠Come here😭"
				elif rand2==3:
					string = "Docker = whale, Deepseek Harness = whale, Deepseek = whale......"
				DisplayServer.dialog_show("From the desktop pet",string,["Okay...?", "I'm busy!"],diag_callback)
			speed=0
		elif r==2:
			animated_sprite.play("bubbles")
			speed=0

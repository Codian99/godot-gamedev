extends KinematicBody2D

var bullet = preload("res://Scenes/Bullet.tscn")
export (int) var run_speed = 200
export (int) var jump_speed = -450
export (int) var gravity = 1200 
var doublejumpcount = 0

var shoot

export var animations=[]
var isRight=true

func _ready():
	GameManager.player=self

var velocity = Vector2()
var jump_count: int = 0
const max_jumps: int = 2

func get_input():
	
	velocity.x = 0
	

	
	var idle = Input.is_action_just_pressed("idle")
	var jump = Input.is_action_just_pressed("jump")
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed('left')
	
	shoot = Input.is_action_just_pressed("fire")
	
			
	if (is_on_floor() || doublejumpcount ==1 )and jump:
		velocity.y=jump_speed
		doublejumpcount+=1
		
	if right:
		velocity.x += run_speed
		isRight=false
		if is_on_floor():
			play_player_ani(1,isRight)

	if left:
		velocity.x -= run_speed
		isRight=false
		if is_on_floor():
			play_player_ani(1,isRight)

	if !is_on_floor():
		if !isPlaying(animations[4]):
			play_player_ani(2,isRight)
			
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity=move_and_slide(velocity,Vector2(0,-1))
		
	if velocity.is_equal_approx(Vector2.ZERO):
		doublejumpcount=0
		if isPlaying(animations[4]):
			play_player_ani(0, isRight)
	
	if shoot:
		play_player_ani(4,isRight)
		if isRight:
			fire($ShootPosRight.global_position,$ShootPosRight.global_rotation)
		else:
			fire($ShootPosLeft.global_position,$ShootPosLeft.global_rotation)
	

	
func play_player_ani(_aniIndex:int,_isRight:bool):
	$CollisionShape2D/PlayerSprites.animation=animations[_aniIndex]
	$CollisionShape2D/PlayerSprites.flip_h=!_isRight

func isPlaying(aniName:String)->bool :
	if aniName == $CollisionShape2D/PlayerSprites.animation and $CollisionShape2D/PlayerSprites.frame>4:
		return true
	return false

func fire(bulletPos,bulletRot):
	var new_bullet=bullet.instance()
	add_child(new_bullet)
	new_bullet.global_position=bulletPos
	new_bullet.global_rotation=bulletRot

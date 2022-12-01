extends KinematicBody2D

export (int) var run_speed = 100
export (int) var gravity = 1200 

export var moveableDistance=20
var startposition

export var animations=[]
var isRight=true

func _ready():
	startposition=position

var velocity = Vector2()
var jump_count: int = 0
const max_jumps: int = 2

func MoveOnPath():
	
	velocity.x = 0
	
	
	if isRight:
		velocity.x= run_speed
		if is_on_floor():
			play_zombie_ani(1,isRight)
	else:
		velocity.x=-run_speed
		if is_on_floor():
			play_zombie_ani(1,isRight)
	position_state_check()

func _physics_process(delta):
	MoveOnPath()
	velocity.y += gravity * delta
	velocity=move_and_slide(velocity,Vector2(0,-1))


func play_zombie_ani(_aniIndex:int,_isRight:bool):
	$CollisionShape2D/AnimatedSprite.animation=animations[_aniIndex]
	$CollisionShape2D/AnimatedSprite.flip_h=!_isRight
	
func position_state_check():
	if moveableDistance>0:
		if position.x<startposition.x:
			isRight=true
		elif position.x>(startposition.x+moveableDistance):
			isRight=false
	else:
		if position.x>startposition.x:
			isRight=false
		elif position.x<(startposition.x+moveableDistance):
			isRight=true
		pass

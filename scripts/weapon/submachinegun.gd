extends Weapons
class_name SubmachineGun

@export var projectile:PackedScene
@export var bullet_spawn:Node3D
@export var bullet_spread:Vector3
@export var rpm:int = 1420

@onready var cycle_time:float = 60.0/rpm
@onready var rof_timer:Timer = $Timers/RateOfFireTimer

var anim_tree

@onready var gunshot_source:AudioStreamPlayer = $AudioSources/GunShotAudioStreamPlayer
@onready var sfx_source:AudioStreamPlayer = $AudioSources/SFXAudioStreamPlayer

var trace_bullet_max_distance:float = 3.0	# if entity is within this distance of the player, it will instead damage the entity with raycast and not projectile

var gunshot_sound:AudioStreamWAV = preload("res://sound/weapons/silenced-gunshot-1.wav")
var reload_sound:AudioStreamWAV = preload("res://sound/weapons/uzi-submachine-gun_reload.wav")

var can_fire_weapon:bool = true		#default state true

var delta_time:float = 0.0		# globally accessible delta time variable

# Called when the node enters the scene tree for the first time.
func _ready():
	rof_timer.set_wait_time(cycle_time)
	
	anim_tree = $AnimationTree.get("parameters/playback")
	
	anim_tree.travel("smg_idle")
	
	print(rof_timer.get_wait_time())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("mouse_left"):
		primary_attack()
	pass

func _physics_process(delta):
	delta_time = delta

func primary_attack():
	if can_fire_weapon:
		fire_bullet()
		
		
		anim_tree.travel("smg_fire")
		
		play_shoot()
		
		rof_timer.start()
		can_fire_weapon = false
	
	if rof_timer.is_stopped():
		can_fire_weapon = true
	
	pass

# zoom in for smg until new ability can be taught of for it
func secondary_attack():
	pass

func fire_bullet():
	var instance = projectile.instantiate()
	instance.position = bullet_spawn.global_position
		#print("bullet pos: ", instance.global_position, "\t spawn pos", bullet_spawn.global_position)
	instance.rotation = bullet_spawn.global_rotation	# add bullet spread when func is added for random vars
	
	#	parenting the base scene and too lazy to set up correctly intil other funcs are added
	get_parent().get_parent().get_parent().get_parent().add_child(instance)
	
	pass

func can_fire() -> bool:
	#	check if can fire weapon at pointing at entity
	
	return can_fire_weapon 

func play_shoot():
	gunshot_source.stream = gunshot_sound
	gunshot_source.play()
	pass

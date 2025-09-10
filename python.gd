extends AnimatedSprite
var direccion #1 iz+r,2 iz+ab, 3 der+ar, 4 der+ab
var velocidad
var Movimiento
var estado
var window_size 
var screen_size 
var pos=Vector2()
var npos = Vector2()
var dpos = Vector2()
var dirpar  # 1 para caer, 2 para subir
signal play
signal chocar

func _ready():
	estado = 1 #1 en reposo, 2 dvd, 3 randomwalk, 4 rebotar, 5 
	get_tree().get_root().set_transparent_background(true)
	_set_playing(true)
	animation= "tranqui"
	screen_size = OS.get_screen_size()
	window_size = OS.get_window_size()
	npos = screen_size*0.5 - window_size*0.5
	OS.set_window_position(npos)
	OS.set_window_minimized(false)
	randomize()


func _process(delta):
	if  OS.is_window_focused()==true:
		if Input.is_action_just_released("letrad"):
			estado =2
			direccion=1
			animation = "clickabajo"
		if Input.is_action_just_released("letraw"):
			estado =3
			animation = "clickabajo"
		if Input.is_action_just_pressed("letrar"):
			estado = 4
			dirpar = 1
			velocidad = 0
			animation = "clickabajo"
	if Input.is_action_just_released("clickder") or Input.is_action_just_released("clickiz"):
		estado =1
		animation = "tranqui"
	if estado ==2:
		velocidad = 296
		Movimiento = Vector2()
		if direccion ==4:
			Movimiento.x +=1
			Movimiento.y +=1
		if direccion == 1:
			Movimiento.x -=1
			Movimiento.y -=1
		if direccion == 2:
			Movimiento.x -=1
			Movimiento.y +=1
		if direccion == 3:
			Movimiento.x +=1
			Movimiento.y -=1
		if direccion==1 && npos.x<=-35:  #rebotes
			direccion = 3
			emit_signal("chocar")
		if direccion ==1 && npos.y<=0:
			direccion = 2
			emit_signal("chocar")
		if direccion ==2 && npos.x <=-35:
			direccion=4
			emit_signal("chocar")
		if direccion == 4 && npos.y>= screen_size.y-356:
			direccion = 3
			emit_signal("chocar")
		if direccion == 3 && npos.y<=0:
			direccion = 4
			emit_signal("chocar")
		if direccion == 3 && npos.x>=screen_size.x-166:
			direccion = 1
			emit_signal("chocar")
		if direccion == 2 && npos.y>= screen_size.y-356:
			direccion = 1
			emit_signal("chocar")
		if direccion == 4 && npos.x >= screen_size.x-166:
			direccion =2
			emit_signal("chocar")
		if Movimiento.length() >0:
			Movimiento= Movimiento.normalized() * velocidad
		npos +=Movimiento*delta
		OS.set_window_position(npos)
	if estado == 3:
		velocidad = 215
		Movimiento = Vector2()
		Movimiento.x +=round(randi()%3-1)
		Movimiento.y +=round(randi()%3-1)
		if Movimiento.length() >0:
			Movimiento= Movimiento.normalized() * velocidad
		npos +=Movimiento*delta
		OS.set_window_position(npos)
		npos.x = clamp(npos.x, -35, screen_size.x-166)
		npos.y = clamp(npos.y, 0, screen_size.y-356)
	if estado ==4:
		if velocidad <=0 && npos.y <=screen_size.y-356:
			dirpar = 1
		if npos.y >=screen_size.y-356:
			dirpar =2
			emit_signal("chocar")
		Movimiento = Vector2()
		if dirpar ==1:
			Movimiento.y +=1
			velocidad+=5
		if dirpar == 2:
			Movimiento.y -=1
			velocidad -=5
		Movimiento= Movimiento.normalized() * velocidad
		npos +=Movimiento*delta
		OS.set_window_position(npos)



func _input(event):
	if Input.is_action_just_released("salir"):
		get_tree().quit()
	if estado == 1:
		dpos = dpos*0
		if Input.is_action_just_released("clickder"):
			OS.set_window_minimized(true)
		if Input.is_action_just_pressed("clickiz"):
			emit_signal("play")
			if event.position.y <= 74:
				animation = "clickarriba"
			if event.position.y>=312:
				animation = "clickabajo"
			if (event.position.y<312 && event.position.y>74):
				animation = "clickenmedio" 
				pos = event.position
		if Input.is_action_pressed("clickiz") && (animation == "clickenmedio"):
			dpos = event.position-pos
		npos = npos+dpos
		OS.set_window_position(npos)
		if Input.is_action_just_released("clickiz"):
			animation = "tranqui"

extends Node

func click():
	$Click.play()

func swap():
	$Swap.play()

func pop():
	var random = randi() % 3
	if random == 0:
		$Pop.play()
	elif random == 1:
		$Pop2.play()
	elif random == 2:
		$Pop3.play()

func congrats():
	$Congrats.play()

func yay():
	$Yay.play()

func menu_open():
	$MenuOpen.play()
	
func failure():
	$Failure.play()

func error():
	$Error.play()

func win():
	$Win.play()

func lose():
	$Lose.play()

func notify():
	$Notification.play()

func hint():
	$Hint.play()

func timer():
	$Timer.play()

func gun_shot():
	$GunShot.play()

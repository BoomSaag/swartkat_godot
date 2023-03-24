extends Label

var playerScore : int = 0
var hiScore : int = 0
var savePath = "user://score.save"

func saveScore():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(hiScore)

func loadScore():
	if FileAccess.file_exists(savePath):
		print("File Found")
		var file = FileAccess.open(savePath,FileAccess.READ)
		hiScore = file.get_var()
	else:
		print("File not Found")
		hiScore = 0

func _ready():
	loadScore()
	$HiScoreLabel/HiScore.text = str(hiScore)

func _process(delta):
	playerScore = int($TotalScore.text)
	if playerScore > hiScore:
		hiScore = playerScore
		$HiScoreLabel/HiScore.text = str(hiScore)

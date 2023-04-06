extends Label

var playerScore : int = 0
var currentRecord : Dictionary = {"name":Globals.playerName,"hiscore":0}
var savePath = Globals.savePath

func saveScore(i):
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(Globals.playerRecord)
	print(Globals.playerRecord[i])

func _ready():
	currentRecord.name = Globals.playerName
	$HiScoreLabel/HiScore.text = str(Globals.hiScore)

func _process(delta):
	playerScore = int($TotalScore.text)
	if playerScore > Globals.hiScore:
		Globals.playerRecord[Globals.playerIndex].hiscore = playerScore
		Globals.hiScore = playerScore
		print(Globals.playerRecord[Globals.playerIndex].hiscore)
		$HiScoreLabel/HiScore.text = str(Globals.playerRecord[Globals.playerIndex].hiscore)

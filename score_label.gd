extends Label

var playerScore : int = Globals.currentScore
var currentRecord : Dictionary = {"name":Globals.playerName,"hiscore":0}
var savePath = Globals.savePath

func saveScore(i):
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(Globals.playerRecord)

func _ready():
	currentRecord.name = Globals.playerName
	$HiScoreLabel/HiScore.text = str(Globals.hiScore)
	$TotalScore.text = var_to_str(playerScore)

func _process(delta):
	playerScore = int($TotalScore.text)
	if playerScore > Globals.hiScore:
		Globals.playerRecord[Globals.playerIndex].hiscore = playerScore
		Globals.hiScore = playerScore
		$HiScoreLabel/HiScore.text = str(Globals.playerRecord[Globals.playerIndex].hiscore)

extends MenuButton

var userRecord : Dictionary = {}
var playPath = Globals.lastPlayer_path
var popup : Popup

func _ready():
	popup = get_popup()
	popup.id_pressed.connect(self._on_item_pressed)

# Load player names from record
func _on_main_load_names():
	userRecord = Globals.playerRecord
	for user in Globals.playerRecord:
		popup.add_item(Globals.playerRecord[user].name)


func _on_item_pressed(id):
	Globals.playerName = popup.get_item_text(id)
	Globals.hiScore = Globals.playerRecord[id].hiscore
	Globals.playerIndex = id
	
	# Save player index to file
	var file = FileAccess.open(playPath, FileAccess.WRITE)
	file.store_var(id)
	get_parent().get_parent().get_parent().get_parent().updateName()

func _on_main_user_added(name, idx):
	userRecord = Globals.playerRecord
	popup.add_item(name)





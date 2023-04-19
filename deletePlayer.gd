extends MenuButton

var popup : Popup
signal userDeleted

func _ready():
	popup = get_popup()
	popup.id_pressed.connect(self._on_item_pressed)

# Load player names from record
func _on_main_load_names():
	print(Globals.playerRecord)
	popup.clear()
	for user in Globals.playerRecord:
		popup.add_item(Globals.playerRecord[user].name)


func _on_item_pressed(id):
	Globals.playerRecord.erase(id)
	_on_main_load_names()
	emit_signal("userDeleted")
	print(Globals.playerRecord)
#	Globals.playerName = popup.get_item_text(id)
#	Globals.hiScore = Globals.playerRecord[id].hiscore
#	Globals.playerIndex = id
#	Globals.settings.lastPlayer = id
#	get_parent().get_parent().get_parent().get_parent().updateName()


func _on_main_user_added(playerName, idx):
	var index : int = Globals.playerRecord.size()
	if index > 0:
		Globals.playerIndex = index-1
	print(Globals.playerRecord)
	popup.add_item(name)

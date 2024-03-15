extends AudioStreamPlayer
const AudioResourcePath = "res://Resource/Audio/"
func _ready():
	EventCenter.AddListener(EventCenter.COM_PlaySound,Callable(self,"play_via_name"))

func _exit_tree():
	EventCenter.RemoveListener(EventCenter.COM_PlaySound,Callable(self,"play_via_name"))

func play_via_name(arg_audio_name:String):
	stream = load("{audio_resource_path}{audio_name}.mp3".format({"audio_resource_path":AudioResourcePath,"audio_name":arg_audio_name}))
	self.play()

extends Node
var Shift:bool
var Direction:Vector2 = Vector2.ZERO
var KeyEvent:Array = [EventCenter.KEY_ML,EventCenter.KEY_MR,EventCenter.KEY_MM,EventCenter.KEY_MU,
EventCenter.KEY_MD,EventCenter.KEY_MN,EventCenter.KEY_MP,EventCenter.KEY_A,EventCenter.KEY_B,
EventCenter.KEY_C,EventCenter.KEY_D,EventCenter.KEY_E,EventCenter.KEY_F,EventCenter.KEY_G,
EventCenter.KEY_H,EventCenter.KEY_I,EventCenter.KEY_J,EventCenter.KEY_K,EventCenter.KEY_L,
EventCenter.KEY_M,EventCenter.KEY_N,EventCenter.KEY_O,EventCenter.KEY_P,EventCenter.KEY_Q,
EventCenter.KEY_R,EventCenter.KEY_S,EventCenter.KEY_T,EventCenter.KEY_U,EventCenter.KEY_V,
EventCenter.KEY_W,EventCenter.KEY_X,EventCenter.KEY_Y,EventCenter.KEY_Z,EventCenter.KEY_1,
EventCenter.KEY_2,EventCenter.KEY_3,EventCenter.KEY_4,EventCenter.KEY_5,EventCenter.KEY_6,
EventCenter.KEY_7,EventCenter.KEY_8,EventCenter.KEY_9,EventCenter.KEY_0,EventCenter.KEY_Space,
EventCenter.KEY_Enter,EventCenter.KEY_Backspace,EventCenter.KEY_Esc,EventCenter.KEY_Delete,
EventCenter.KEY_Shift,EventCenter.KEY_Ctrl,EventCenter.KEY_Alt,EventCenter.KEY_CapsLk]
#                             ML MR MM MU MD MN MP A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  1  2  3  4  5  6  7  8  9  0  SP EN BS ES DE
var KeyValue        :Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]

var KeyConfig_IPanel:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Tool  :Array = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Take  :Array = [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Power :Array = [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Dash  :Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,]
var KeyConfig_Left  :Array = [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Right :Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Up    :Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Down  :Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug1:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug2:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug3:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug4:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug5:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug6:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug7:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug8:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug9:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,]
var KeyConfig_Debug0:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,]

func _ready():
	AddListener()
	pass

func _input(event):
	######   按下   ######
	if event.is_action_pressed("MOUSE_LEFT"):
		EventCenter.BroadCast1(EventCenter.KEY_ML,true)
	if event.is_action_pressed("MOUSE_RIGHT"):
		EventCenter.BroadCast1(EventCenter.KEY_MR,true)
	if event.is_action_pressed("MOUSE_MIDDLE"):
		EventCenter.BroadCast1(EventCenter.KEY_MM,true)
	if event.is_action_pressed("MOUSE_UP"):
		EventCenter.BroadCast1(EventCenter.KEY_MU,true)
	if event.is_action_pressed("MOUSE_DOWN"):
		EventCenter.BroadCast1(EventCenter.KEY_MD,true)
	if event.is_action_pressed("MOUSE_NEXT"):
		EventCenter.BroadCast1(EventCenter.KEY_MN,true)
	if event.is_action_pressed("MOUSE_PREV"):
		EventCenter.BroadCast1(EventCenter.KEY_MP,true)
	
	if event.is_action_pressed("A"):
		EventCenter.BroadCast1(EventCenter.KEY_A,true)
	if event.is_action_pressed("B"):
		EventCenter.BroadCast1(EventCenter.KEY_B,true)
	if event.is_action_pressed("C"):
		EventCenter.BroadCast1(EventCenter.KEY_C,true)
	if event.is_action_pressed("D"):
		EventCenter.BroadCast1(EventCenter.KEY_D,true)
	if event.is_action_pressed("E"):
		EventCenter.BroadCast1(EventCenter.KEY_E,true)
	if event.is_action_pressed("F"):
		EventCenter.BroadCast1(EventCenter.KEY_F,true)
	if event.is_action_pressed("G"):
		EventCenter.BroadCast1(EventCenter.KEY_G,true)
	if event.is_action_pressed("H"):
		EventCenter.BroadCast1(EventCenter.KEY_H,true)
	if event.is_action_pressed("I"):
		EventCenter.BroadCast1(EventCenter.KEY_I,true)
	if event.is_action_pressed("J"):
		EventCenter.BroadCast1(EventCenter.KEY_J,true)
	if event.is_action_pressed("K"):
		EventCenter.BroadCast1(EventCenter.KEY_K,true)
	if event.is_action_pressed("L"):
		EventCenter.BroadCast1(EventCenter.KEY_L,true)
	if event.is_action_pressed("M"):
		EventCenter.BroadCast1(EventCenter.KEY_M,true)
	if event.is_action_pressed("N"):
		EventCenter.BroadCast1(EventCenter.KEY_N,true)
	if event.is_action_pressed("O"):
		EventCenter.BroadCast1(EventCenter.KEY_O,true)
	if event.is_action_pressed("P"):
		EventCenter.BroadCast1(EventCenter.KEY_P,true)
	if event.is_action_pressed("Q"):
		EventCenter.BroadCast1(EventCenter.KEY_Q,true)
	if event.is_action_pressed("R"):
		EventCenter.BroadCast1(EventCenter.KEY_R,true)
	if event.is_action_pressed("S"):
		EventCenter.BroadCast1(EventCenter.KEY_S,true)
	if event.is_action_pressed("T"):
		EventCenter.BroadCast1(EventCenter.KEY_T,true)
	if event.is_action_pressed("U"):
		EventCenter.BroadCast1(EventCenter.KEY_U,true)
	if event.is_action_pressed("V"):
		EventCenter.BroadCast1(EventCenter.KEY_V,true)
	if event.is_action_pressed("W"):
		EventCenter.BroadCast1(EventCenter.KEY_W,true)
	if event.is_action_pressed("X"):
		EventCenter.BroadCast1(EventCenter.KEY_X,true)
	if event.is_action_pressed("Y"):
		EventCenter.BroadCast1(EventCenter.KEY_Y,true)
	if event.is_action_pressed("Z"):
		EventCenter.BroadCast1(EventCenter.KEY_Z,true)
	if event.is_action_pressed("1"):
		EventCenter.BroadCast1(EventCenter.KEY_1,true)
	if event.is_action_pressed("2"):
		EventCenter.BroadCast1(EventCenter.KEY_2,true)
	if event.is_action_pressed("3"):
		EventCenter.BroadCast1(EventCenter.KEY_3,true)
	if event.is_action_pressed("4"):
		EventCenter.BroadCast1(EventCenter.KEY_4,true)
	if event.is_action_pressed("5"):
		EventCenter.BroadCast1(EventCenter.KEY_5,true)
	if event.is_action_pressed("6"):
		EventCenter.BroadCast1(EventCenter.KEY_6,true)
	if event.is_action_pressed("7"):
		EventCenter.BroadCast1(EventCenter.KEY_7,true)
	if event.is_action_pressed("8"):
		EventCenter.BroadCast1(EventCenter.KEY_8,true)
	if event.is_action_pressed("9"):
		EventCenter.BroadCast1(EventCenter.KEY_9,true)
	if event.is_action_pressed("0"):
		EventCenter.BroadCast1(EventCenter.KEY_0,true)
	if event.is_action_pressed("Space"):
		EventCenter.BroadCast1(EventCenter.KEY_Space,true)
	if event.is_action_pressed("Enter"):
		EventCenter.BroadCast1(EventCenter.KEY_Enter,true)
	if event.is_action_pressed("Backspace"):
		EventCenter.BroadCast1(EventCenter.KEY_Backspace,true)
	if event.is_action_pressed("Esc"):
		EventCenter.BroadCast1(EventCenter.KEY_Esc,true)
	if event.is_action_pressed("Delete"):
		EventCenter.BroadCast1(EventCenter.KEY_Delete,true)
	if event.is_action_pressed("Shift"):
		EventCenter.BroadCast1(EventCenter.KEY_Shift,true)
	
	######   释放   ######
	if event.is_action_released("MOUSE_LEFT"):
		EventCenter.BroadCast1(EventCenter.KEY_ML,false)
	if event.is_action_released("MOUSE_RIGHT"):
		EventCenter.BroadCast1(EventCenter.KEY_MR,false)
	if event.is_action_released("MOUSE_MIDDLE"):
		EventCenter.BroadCast1(EventCenter.KEY_MM,false)
	if event.is_action_released("MOUSE_UP"):
		EventCenter.BroadCast1(EventCenter.KEY_MU,false)
	if event.is_action_released("MOUSE_DOWN"):
		EventCenter.BroadCast1(EventCenter.KEY_MD,false)
	if event.is_action_released("MOUSE_NEXT"):
		EventCenter.BroadCast1(EventCenter.KEY_MN,false)
	if event.is_action_released("MOUSE_PREV"):
		EventCenter.BroadCast1(EventCenter.KEY_MP,false)
	
	if event.is_action_released("A"):
		EventCenter.BroadCast1(EventCenter.KEY_A,false)
	if event.is_action_released("B"):
		EventCenter.BroadCast1(EventCenter.KEY_B,false)
	if event.is_action_released("C"):
		EventCenter.BroadCast1(EventCenter.KEY_C,false)
	if event.is_action_released("D"):
		EventCenter.BroadCast1(EventCenter.KEY_D,false)
	if event.is_action_released("E"):
		EventCenter.BroadCast1(EventCenter.KEY_E,false)
	if event.is_action_released("F"):
		EventCenter.BroadCast1(EventCenter.KEY_F,false)
	if event.is_action_released("G"):
		EventCenter.BroadCast1(EventCenter.KEY_G,false)
	if event.is_action_released("H"):
		EventCenter.BroadCast1(EventCenter.KEY_H,false)
	if event.is_action_released("I"):
		EventCenter.BroadCast1(EventCenter.KEY_I,false)
	if event.is_action_released("J"):
		EventCenter.BroadCast1(EventCenter.KEY_J,false)
	if event.is_action_released("K"):
		EventCenter.BroadCast1(EventCenter.KEY_K,false)
	if event.is_action_released("L"):
		EventCenter.BroadCast1(EventCenter.KEY_L,false)
	if event.is_action_released("M"):
		EventCenter.BroadCast1(EventCenter.KEY_M,false)
	if event.is_action_released("N"):
		EventCenter.BroadCast1(EventCenter.KEY_N,false)
	if event.is_action_released("O"):
		EventCenter.BroadCast1(EventCenter.KEY_O,false)
	if event.is_action_released("P"):
		EventCenter.BroadCast1(EventCenter.KEY_P,false)
	if event.is_action_released("Q"):
		EventCenter.BroadCast1(EventCenter.KEY_Q,false)
	if event.is_action_released("R"):
		EventCenter.BroadCast1(EventCenter.KEY_R,false)
	if event.is_action_released("S"):
		EventCenter.BroadCast1(EventCenter.KEY_S,false)
	if event.is_action_released("T"):
		EventCenter.BroadCast1(EventCenter.KEY_T,false)
	if event.is_action_released("U"):
		EventCenter.BroadCast1(EventCenter.KEY_U,false)
	if event.is_action_released("V"):
		EventCenter.BroadCast1(EventCenter.KEY_V,false)
	if event.is_action_released("W"):
		EventCenter.BroadCast1(EventCenter.KEY_W,false)
	if event.is_action_released("X"):
		EventCenter.BroadCast1(EventCenter.KEY_X,false)
	if event.is_action_released("Y"):
		EventCenter.BroadCast1(EventCenter.KEY_Y,false)
	if event.is_action_released("Z"):
		EventCenter.BroadCast1(EventCenter.KEY_Z,false)
	if event.is_action_released("1"):
		EventCenter.BroadCast1(EventCenter.KEY_1,false)
	if event.is_action_released("2"):
		EventCenter.BroadCast1(EventCenter.KEY_2,false)
	if event.is_action_released("3"):
		EventCenter.BroadCast1(EventCenter.KEY_3,false)
	if event.is_action_released("4"):
		EventCenter.BroadCast1(EventCenter.KEY_4,false)
	if event.is_action_released("5"):
		EventCenter.BroadCast1(EventCenter.KEY_5,false)
	if event.is_action_released("6"):
		EventCenter.BroadCast1(EventCenter.KEY_6,false)
	if event.is_action_released("7"):
		EventCenter.BroadCast1(EventCenter.KEY_7,false)
	if event.is_action_released("8"):
		EventCenter.BroadCast1(EventCenter.KEY_8,false)
	if event.is_action_released("9"):
		EventCenter.BroadCast1(EventCenter.KEY_9,false)
	if event.is_action_released("0"):
		EventCenter.BroadCast1(EventCenter.KEY_0,false)
	if event.is_action_released("Space"):
		EventCenter.BroadCast1(EventCenter.KEY_Space,false)
	if event.is_action_released("Enter"):
		EventCenter.BroadCast1(EventCenter.KEY_Enter,false)
	if event.is_action_released("Backspace"):
		EventCenter.BroadCast1(EventCenter.KEY_Backspace,false)
	if event.is_action_released("Esc"):
		EventCenter.BroadCast1(EventCenter.KEY_Esc,false)
	if event.is_action_released("Delete"):
		EventCenter.BroadCast1(EventCenter.KEY_Delete,false)
	if event.is_action_released("Shift"):
		EventCenter.BroadCast1(EventCenter.KEY_Shift,false)
	
func AddListener():
	#基础
	EventCenter.AddListener(EventCenter.KEY_ML,Callable(self,"OnLeft"))
	EventCenter.AddListener(EventCenter.KEY_MR,Callable(self,"OnRight"))
	EventCenter.AddListener(EventCenter.KEY_MU,Callable(self,"OnUp"))
	EventCenter.AddListener(EventCenter.KEY_MD,Callable(self,"OnDown"))
	EventCenter.AddListener(EventCenter.KEY_MN,Callable(self,"OnNext"))
	EventCenter.AddListener(EventCenter.KEY_MP,Callable(self,"OnPrev"))
	EventCenter.AddListener(EventCenter.KEY_Shift,Callable(self,"OnShift"))
	#自定义
	for key_index in KeyValue.size():
		if KeyConfig_IPanel[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"IPanel"))
		if KeyConfig_Take[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Take"))
		if KeyConfig_Tool[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Tool"))
		if KeyConfig_Power[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Power"))
		if KeyConfig_Dash[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Dash"))
		if KeyConfig_Left[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Left"))
		if KeyConfig_Right[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Right"))
		if KeyConfig_Up[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Up"))
		if KeyConfig_Down[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Down"))
		if KeyConfig_Debug1[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug1"))
		if KeyConfig_Debug2[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug2"))
		if KeyConfig_Debug3[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug3"))
		if KeyConfig_Debug4[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug4"))
		if KeyConfig_Debug5[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug5"))
		if KeyConfig_Debug6[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug6"))
		if KeyConfig_Debug7[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug7"))
		if KeyConfig_Debug8[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug8"))
		if KeyConfig_Debug9[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug9"))
		if KeyConfig_Debug0[key_index]:
			EventCenter.AddListener(KeyEvent[key_index],Callable(self,"Debug0"))

func OnLeft(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_ACCEPT)
func OnRight(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_REJECT)
func OnUp(on):
	if on:
		if !Shift:
			EventCenter.BroadCast0(EventCenter.ACT_PAGEUP)
		else:
			EventCenter.BroadCast0(EventCenter.ACT_Plus)
func OnDown(on):
	if on:
		if !Shift:
			EventCenter.BroadCast0(EventCenter.ACT_PAGEDOWN)
		else:
			EventCenter.BroadCast0(EventCenter.ACT_Minus)
func OnNext(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_NEXTPAGE)
func OnPrev(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_PREVPAGE)
func OnShift(on):
	if on:
		Shift = true
	else:
		Shift = false

func IPanel(on):
	if on:
		EventCenter.BroadCast0(EventCenter.GUI_SwitchInventory)
	pass
func Take(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_TAKE)
func Tool(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_TOOL)
func Power(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_POWER)
func Dash(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_DASH)
func Left(on):
	if on:
		Direction += Vector2.LEFT
	else:
		Direction -= Vector2.LEFT
	EventCenter.BroadCast1(EventCenter.ACT_MOVE,Direction)
func Right(on):
	if on:
		Direction += Vector2.RIGHT
	else:
		Direction -= Vector2.RIGHT
	EventCenter.BroadCast1(EventCenter.ACT_MOVE,Direction)
func Up(on):
	if on:
		Direction += Vector2.UP
	else:
		Direction -= Vector2.UP
	EventCenter.BroadCast1(EventCenter.ACT_MOVE,Direction)
func Down(on):
	if on:
		Direction += Vector2.DOWN
	else:
		Direction -= Vector2.DOWN
	EventCenter.BroadCast1(EventCenter.ACT_MOVE,Direction)
	
func Debug1(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_1)
#		print("Debug1")
func Debug2(on):
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_2)
#		print("Debug2")
func Debug3(on):
#	print("Debug3")
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_3)
func Debug4(on):
#	print("Debug4")
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_4)
func Debug5(on):
#	print("Debug5")
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_5)
func Debug6(on):
#	print("Debug6")
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_6)
func Debug7(on):
#	print("Debug7")
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_7)
func Debug8(on):
#	print("Debug8")
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_8)
func Debug9(on):
#	print("Debug9")
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_9)
func Debug0(on):
#	print("Debug0")
	if on:
		EventCenter.BroadCast0(EventCenter.ACT_0)
	#DEBUG

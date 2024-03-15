extends Node
#时间的层级结构如下：
#|年{节气[日（四分之一日<时>）]}|
#每一时间段的结束与另一时间段的开始紧密相连
#如果两个及两个以上的时间段在同一时刻进行分割，则遵循以下规则：
#	1.嵌套结束，嵌套开始
#	2.结束与开始两两对称
#	3.不可越过层级
#	解释：例如，一小时结束时刚好跨越一天，那么因为从天到小时的嵌套关系是日（四分之一日<时>），
#则按照规则1，结束时应嵌套地结束，先结束一日中的最后一小时，再结束前半夜，然后结束这一天。
#而按照规则2，开始将与结束对称，即先开始下一天，再开始下一天的后半夜，最后开始下一天的第一时。
#按照规则3，不能越过层级进行分割，意味着如果两个不同级别的时刻若在同一时间点进行分割，
#则级别介于于他们之间的所有时间段必然也在这一时刻进行分割。如一小时刚好是一年的最后一小时，
#则分割时，年、节气、日、四分之一日、小时都必须按照规则1、2在同一时间点进行分割，不得遗漏。
#	如下示意：
#	...结束第十二时>结束前半夜)结束一年最后一日]结束大寒节气}结束一年|年计数器+1|开始新的一
#年{开始新的立春节气[开始新年第一天(开始第一天的后半夜<开始第一时...
#	月份不属于太阳历，其有独特的划分方式，稍后作详细讨论
const hour_length = 6
const oclock_name = ["潮时","露时","鸟时","镜时","车时","鼓时","寂时","虫时","花时","灯时","舟时","钟时"]
const vague_oclock_name = ["黎明","早晨","正午","傍晚","夜幕","子夜"]
const quarter_day_name = ["下半夜","上半日","下半日","上半夜"]
const term_name = ["立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至","小寒","大寒"]
const vague_term_name = ["新春","春半","残春","初夏","盛夏","暮夏","新秋","秋半","深秋","初冬","寒冬","末冬"]

var begin_year

var frame
var hour#半日中的小时数
var quarter_day
var day
var term
var year

var sun_rise_time
var sun_set_time
var sun_rise:bool
var sun_set:bool

func _init():
	begin_year = 1062
	
	year = 0
	term = 0
	day = 0
	quarter_day = 0
	hour = 0
	frame = 0
	
func _ready():
	EventCenter.AddListener(EventCenter.ACT_0,Callable(self,"debug"))
	time_begin()
	
func _exit_tree():
	EventCenter.RemoveListener(EventCenter.ACT_0,Callable(self,"debug"))
	
func time_begin():
	set_sun_rise_set_time()
	debug_log_day_length_value()
	sun_rise = false
	sun_set = false
	update_sun_state()	

##更新方法
func _process(delta):
	frame+=delta
	if frame>=hour_length:
		frame-=hour_length
		update_hour()
	update_sun_state()
	
func update_hour():
	hour_finish()
	hour = (hour+1)%3
	if hour==0:
		update_quarter_day()
	hour_begin()
	
func hour_finish():
	pass
	
func hour_begin():
	pass

func update_quarter_day():
	quarter_day_finish()
	quarter_day = (quarter_day+1)%4
	if quarter_day==0:
		update_day()
	quarter_day_begin()

func quarter_day_finish():
	pass

func quarter_day_begin():
	pass

func update_day():
	day_finish()
	day=(day+1)%3
	EventCenter.BroadCast0(EventCenter.TIME_Day)
	if day==0:
		update_term()
	day_begin()

func day_finish():
	prints(get_term_name(),get_date_in_term(),"日结束了")

func day_begin():
	set_sun_rise_set_time()
	debug_log_day_length_value()
	sun_rise = false
	sun_set = false
	hour-=12
	prints(get_term_name(),get_date_in_term(),"日开始了")

func update_term():
	term_finish()
	term = (term+1)%24
	if term==0:
		update_year()
	term_begin()
	pass

func term_finish():
	prints(get_term_name(),"结束了")
	pass
	
func term_begin():
	prints(get_term_name(),"开始了")
	pass

func update_year():
	year_finish()
	year+=1
	EventCenter.BroadCast0(EventCenter.TIME_Year)
	year_begin()

func year_finish():
	prints(get_literal_year(),"年结束了")
	pass
	
func year_begin():
	prints(get_literal_year(),"年开始了")
	pass


##功能方法
func set_sun_rise_set_time():
	sun_rise_time = 3.0-sin(((get_day_in_year()+63)%72)*2*PI/72.0)
	sun_set_time  = 9.0+sin(((get_day_in_year()+63)%72)*2*PI/72.0)

func update_sun_state():
	if get_day_time()>=sun_rise_time && !sun_rise:
		EventCenter.BroadCast0(EventCenter.TIME_SunRise)
		sun_rise = true
		
	if get_day_time()>=sun_set_time && !sun_set:
		EventCenter.BroadCast0(EventCenter.TIME_SunSet)
		sun_set = true


##获取方法
func get_day_time():
	return get_oclock()+frame/hour_length

func get_literal_oclock():
	return get_oclock()+1

func get_oclock():
	return quarter_day*3+hour

func get_oclock_name():
	return oclock_name[get_oclock()]

func get_vague_oclock_name():
	return vague_oclock_name[(get_oclock()+11)/2%6]
	
func get_quarter_day_name():
	return quarter_day_name[quarter_day]

func get_date_in_term():
	return day+1

func get_day_in_year():
	return term*3+day
	
func get_term_name():
	return term_name[term]

func get_vague_term_name():
	return vague_term_name[term/2]

func get_literal_year():
	return begin_year+year

##debug function
func debug():
	prints(get_day_time(),"  ",sun_rise_time,"  ",sun_rise,"  ",sun_set_time,"  ",sun_set)
func debug_log_date_with_term():
	prints(get_term_name(),get_date_in_term(),"日")	
func debug_log_year():
	prints("新年快乐! 喜迎",get_literal_year(),"年！")
func debug_log_current_date_and_time():
	prints("现在是",get_literal_year(),"年",get_term_name(),get_date_in_term(),"日,第",get_literal_oclock(),"时",get_oclock_name())	
func debug_log_vague_date_and_time():
	prints("约莫是",get_vague_term_name(),"时节,",get_quarter_day_name(),",",get_vague_oclock_name(),"时分")
func debug_log_quarter_day_update():
	prints("现在是",get_oclock_name(),"进入",get_quarter_day_name())
func debug_log_day_length_value():
	prints(get_term_name(),get_date_in_term(),"日，日出时间为","%.2f" % sun_rise_time,"点，日落时间为","%.2f" % sun_set_time,"点")
	pass

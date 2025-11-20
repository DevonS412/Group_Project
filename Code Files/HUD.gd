extends CanvasLayer

@onready var hearts_container: Node = $HeartsContainer
@onready var rupees_label: Label = $RupeesLabel
@onready var message_label: Label = $MessageLabel

# assumes HeartsContainer has child TextureRects named "Heart1", "Heart2", "Heart3"
func update_health(current: int, max_health: int) -> void:
	for i in range(hearts_container.get_child_count()):
		var heart = hearts_container.get_child(i)
		if i < current:
			heart.visible = true
		else:
			heart.visible = false

func update_rupees(amount: int) -> void:
	rupees_label.text = "Rupees: %d" % amount

func show_message(text: String, time: float = 2.0) -> void:
	message_label.text = text
	message_label.show()
	_start_message_timer(time)

func _start_message_timer(time: float) -> void:
	var t := Timer.new()
	t.one_shot = true
	t.wait_time = time
	add_child(t)
	t.timeout.connect(_on_message_timeout)
	t.start()

func _on_message_timeout() -> void:
	message_label.hide()

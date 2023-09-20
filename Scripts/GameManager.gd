extends Node

@onready var Game = get_node('/root/Game/')

var deck = Array()

var cardBack = preload("res://Assets/cross_back.png")

var card1
var card2

var flipTimer = Timer.new()
var matchTimer = Timer.new()
var secondsTimer = Timer.new()

var score = 0
var seconds = 0
var moves = 0

var scoreLabel
var timerLabel
var movesLabel

var resetButton

var introScreen = preload('res://Scenes/intro_screen.tscn')

var goal = 10

func _ready():
	fillDeck()
	dealDeck()
	setupTimers()
	setupHUD()
	var splash = introScreen.instantiate()
	Game.add_child(splash)

func resetGame():
	for n in range(deck.size()):
		deck[n].queue_free()
	deck.clear()
	score = 0
	seconds = 0
	moves = 0
	movesLabel.text = str(moves)
	scoreLabel.text = str(score)
	timerLabel.text = str(seconds)

	fillDeck()
	dealDeck()


func setupHUD():
	scoreLabel = Game.get_node('HUD/Panel/Sections/SectionScore/Label2')
	timerLabel = Game.get_node('HUD/Panel/Sections/SectionTimer/Label2')
	movesLabel = Game.get_node('HUD/Panel/Sections/SectionMoves/Label2')
	scoreLabel.text = str(score)
	timerLabel.text = str(seconds)
	movesLabel.text = str(moves)
	resetButton = Game.get_node('HUD/Panel/Sections/SectionButton/Reset')
	resetButton.pressed.connect(self.resetGame)

func setupTimers():
	flipTimer.timeout.connect(self.turnOverCards)
	flipTimer.set_one_shot(true)
	add_child(flipTimer)

	matchTimer.timeout.connect(self.matchCardsAndScore)
	matchTimer.set_one_shot(true)
	add_child(matchTimer)

	secondsTimer.timeout.connect(self.countSeconds)
	add_child(secondsTimer)
	secondsTimer.start()

func countSeconds():
	seconds += 1
	timerLabel.text = str(seconds)

func fillDeck():
	var j = 1
	var i = 1
	while j < 3:
		i = 1
		while i < 11:
			deck.append(Card.new(j,i))
			i += 1
		j += 1

func dealDeck():
	deck.shuffle()
	var i = 0
	while i < deck.size():
		Game.get_node('Grid').add_child(deck[i])
		i += 1

func chooseCard(x):
	if card1 == null:
		card1 = x
		card1.flip()
		card1.set_disabled(true)
	elif card2 == null:
		card2 = x
		card2.flip()
		card2.set_disabled(true)
		moves += 1
		movesLabel.text = str(moves)
		checkCard()

func checkCard():
	if card1.value == card2.value:
		matchTimer.start(1)
	else:
		flipTimer.start(1)

func turnOverCards():
	card1.flip()
	card2.flip()
	card1.set_disabled(false)
	card2.set_disabled(false)
	card1 = null
	card2 = null

func matchCardsAndScore():
	score += 1
	scoreLabel.text = str(score)
	card1.set_modulate(Color(0.6,0.6,0.6,0.5))
	card2.set_modulate(Color(0.6,0.6,0.6,0.5))
	card1 = null
	card2 = null
	if score == goal:
		var winScreen = introScreen.instantiate()
		Game.add_child(winScreen)
		winScreen.win()

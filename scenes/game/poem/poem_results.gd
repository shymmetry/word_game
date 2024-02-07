extends Control

func _ready():
	Signals.connect("RoundOver", _init_poem_results)

func reset() -> void:
	$Body/Poem.reset()
	$Body/Margin/WordScoring.reset()
	$Body/Continue/Button.hide()

func _init_poem_results() -> void:
	var response = _get_poem()
	if response != OK:
		$Body/Poem.set_error("Server responded with: %s" % response)

func _get_poem() -> int:
	var matched_words = []
	for word_score in Globals.matched_words: matched_words.append(word_score.word.to_lower())
	var word_string = ", ".join(matched_words)
	
	var openai_api_key = Env.get_var("OPENAI_API_KEY")
	if !openai_api_key: return FAILED
	
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer %s" % openai_api_key,
	]
	var data = JSON.stringify(
		{
			"model": "gpt-3.5-turbo",
			"messages": [
				{
					"role": "system",
					"content": Globals.character.gpt_system
				},
				{
					"role": "user",
					"content": Globals.character.gpt_prompt % word_string
				}
			]
		}
	)
	return $HTTPRequest.request("https://api.openai.com/v1/chat/completions", headers, HTTPClient.METHOD_POST, data)

func _on_http_request_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json == null:
		$Body/Poem.set_error(body)
	elif json.has("error"):
		$Body/Poem.set_error(json.error)
	else:
		var poem = json.choices[0].message.content
		$Body/Poem.set_poem(poem)

func _on_button_pressed():
	Signals.emit_signal("ShowShop")

extends Control

func _ready():
	Signals.connect("RoundOver", _init_poem_results)

func reset() -> void:
	$Body/Poem.reset()
	$Body/Margin/WordScoring.reset()

func _init_poem_results() -> void:
	var success = _get_poem()
	if !success:
		$Body/Poem.set_error()

func _get_poem() -> bool:
	var matched_words = []
	for word_score in Globals.matched_words: matched_words.append(word_score.word)
	var word_string = ", ".join(matched_words)
	
	var openai_api_key = Env.get_var("OPENAI_API_KEY")
	if !openai_api_key: return false
	
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
					"content": "You are a poetic assistant"
				},
				{
					"role": "user",
					"content": "Write a 4 line poem under 40 words that contains all of the words: %s" % word_string
				}
			]
		}
	)
	var error = $HTTPRequest.request("https://api.openai.com/v1/chat/completions", headers, HTTPClient.METHOD_POST, data)
	if error == OK:
		return true
	else:
		return false

func _on_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json.has("error"):
		print(json.error)
		$Body/Poem.set_error()
	else:
		var poem = json.choices[0].message.content
		$Body/Poem.set_poem(poem)

func _on_button_pressed():
	Signals.emit_signal("ShowShop")

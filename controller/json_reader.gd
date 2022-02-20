extends Resource

func read_json(path):
	var file =  File.new()
	assert(file.file_exists(path),"File path does not exist")
	file.open(path,File.READ)
	var file_data = file.get_as_text()
	var json_data = JSON.parse(file_data).result
	return json_data

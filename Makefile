watch_elm:
	cd app && (find src/*.elm | entr elm make src/Main.elm --output js/main.js)

watch_flask:
	python3 backend/app.py 

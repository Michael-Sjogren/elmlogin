watch_elm:
	find ./app/src/**/*.elm | entr make elm_build

elm_build:
	cd app && tailwind -i css/input.css -o css/output.css
	cd app && elm make src/Main.elm --output js/main.js --debug

watch_css:
	cd app && tailwind -i css/input.css -o css/output.css --watch

watch_flask:
	python3 backend/app.py 

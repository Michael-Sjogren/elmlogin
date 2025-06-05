build:css
	elm make src/Main.elm --output static/main.min.js --debug # --optimize
	elm-format --validate src/
	elm-format src/*.elm --yes
	#bun run uglifyjs  static/main.js --mangle --compress  > static/main.min.js

css:
	tailwind -i static/input.css -o static/style.css --minify

watch:
	find src/**/*.elm | entr make build
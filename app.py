from flask import Flask,Response, session,request, jsonify,send_from_directory
from http import HTTPStatus
from werkzeug.security import check_password_hash, generate_password_hash
from dataclasses import dataclass
from os import urandom

@dataclass(frozen=True,slots=True)
class ErrorResponse:
    errors: list[str]

@dataclass(frozen=True, slots=True)
class LoginSuccessResponse:
    username: str
    access: int = -1

def create_app():
    app = Flask(__name__, static_folder='./static')
    app.secret_key = urandom(128)
    PW = generate_password_hash('admin')
    USR = 'admin'
    specific_public_routes = {
        '/favicon.ico',
        '/login',
        '',
        '/'
    }
    @app.before_request
    def check_login():
        if request.path.startswith('/static/') or request.path in specific_public_routes:
            return
        if session.get('user'):
            return
        
        return Response(status=HTTPStatus.UNAUTHORIZED)

    @app.post('/login')
    def login():
        errors = []
        try:
            username = request.json['username']
            password = request.json['password']

        except KeyError:
            errors.append('username or password not defined')
        
        if username == USR and check_password_hash(PW,password):
            session['user'] = username
            return jsonify(LoginSuccessResponse(username, 0xf ))
        else:
            errors.append('Username or password is incorrect.')
        
        return jsonify(ErrorResponse(errors=errors)), HTTPStatus.UNAUTHORIZED
    
    @app.route('/', defaults={'path': ''})
    @app.route('/<path:path>')
    def catch_all(path):
        print("path ", path)
        # If the path starts with 'static/', do not catch it
        if path.startswith(f'{app.static_url_path}/') :
            return send_from_directory(app.static_folder, str(path).removesuffix(f'{app.static_url_path}/'))
        return app.send_static_file("index.html")
    
    @app.get('/home')
    def home():
        if not 'user' in session:
            return Response(status=HTTPStatus.UNAUTHORIZED)
        else:
            return jsonify({
                'users': ['Michael', 'Hasan', 'Ali', 'Claire']
            })
    
    return app


if __name__ == "__main__":
    app = create_app()
    app.run(debug=True)
from flask import Flask, send_from_directory,request, session, Response, jsonify
from werkzeug.security import check_password_hash, generate_password_hash
from http import HTTPStatus
ADMIN_USER = 'admin'
ADMIN_PW_HASH = generate_password_hash('admin')
import os


def create_app():
    app = Flask(__name__,static_folder='../app',static_url_path='/app')
    app.secret_key = os.urandom(64)


    @app.route('/', defaults={'path': ''})
    @app.route('/<path:path>')
    def catch_all(path):
        print("path ", path)
        # If the path starts with 'static/', do not catch it
        if path.startswith(f'{app.static_url_path}/') :
            return send_from_directory(app.static_folder, str(path).removesuffix(f'{app.static_url_path}/'))
        return app.send_static_file("index.html")

    @app.before_request
    def check_login():
        if request.path.startswith('/app/') or request.path.startswith('/'):
            return 
        if not session.get('username'):
            return Response(status=HTTPStatus.UNAUTHORIZED)
        return
    
    @app.post('/auth/login')
    def login():
        json = request.get_json()
        username = json['username']
        password = json['password']
        
        if username == ADMIN_USER and check_password_hash(ADMIN_PW_HASH,password):
            session['username'] = username
            return jsonify({'success':True, 'response': 'Login success'}), HTTPStatus.OK
        else:
            return jsonify({'statusCode':HTTPStatus.UNAUTHORIZED.value, 'errorMessage': 'Invalid credentails'}) , HTTPStatus.UNAUTHORIZED
        

    def logout():
        if session.get('username'):
            session.pop('username')
            return Response(status=HTTPStatus.OK)

        return Response(status=HTTPStatus.UNAUTHORIZED)



    @app.get('/status')
    def status():
        return {'status': f'Crack: {os.urandom(4).hex()}'}

    return app


if __name__ == "__main__":
    create_app().run(debug=True, use_reloader=True)

from flask_cors import CORS


if __name__ == "__main__":
    app = Flask(__name__)
    app.secret_key = "averysecretkey" # secret key for encoding and decoding session data
    #app.permanent_session_lifetime = datetime.timedelta(hours=12)
    CORS(app, supports_credentials=True)


    app.run() # for development
    #app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080))) # for production

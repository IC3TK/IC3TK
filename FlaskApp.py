#!/usr/bin/env python3
# utf8

# export FLASK_APP=FlaskApp.py
# python -m flask run --host=0.0.0.0 --port=8080

from flask import Flask

app= Flask(__name__)

@app.route('/')
def hello_world():
	return "Hello, World!"

if __name__ == "__main__":
	app.run()


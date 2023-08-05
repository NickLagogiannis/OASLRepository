from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'http://virtuoso_box:8890/sparql'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# db = SQLAlchemy(app)

jar_translator = "flask_app/static/miscellaneous/translatorWithText.jar"
jar_executor = "flask_app/static/miscellaneous/sparql_executor.jar"

from . import views, models

#views.check_files_init()
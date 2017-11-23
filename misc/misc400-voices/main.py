from flask import Flask, render_template, request
from models import Request
from recognize import check_texts

app = Flask(__name__)
FLAG = '1337_you_rea11y-hear-this_voices_7331'


@app.route("/", methods=['GET', 'POST'])
def index():
    if request.method == 'GET':
        Request.delete_old()
        if Request.check_antispam():
            return "too many requests! please, wait some minutes and don't brute"

        return render_template('index.j2', request=Request.create_new())
    elif request.method == 'POST':
        text = request.form['text']
        filename = request.form['filename']
        form_request = Request.select().where(Request.filename == filename).get()

        if form_request.check_expired():
            return 'too slow'

        if check_texts(form_request.text, text):
            return 'nice! take your flag: ' + FLAG
        else:
            return 'you are fast, but text is incorrect :( try again'


if __name__ == "__main__":
    app.run()

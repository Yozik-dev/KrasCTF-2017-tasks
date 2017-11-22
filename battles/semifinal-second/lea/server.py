from flask import Flask, request
import hashlib

app = Flask(__name__)
key = open('key.txt', 'rb').read()


@app.route('/', methods=['GET'])
def index():
    flagword = request.args.get('flagword', '')
    digest = request.args.get('digest', '')

    if not flagword or not digest:
        return 'please, provide flagword and digest.'

    if hashlib.sha256(key + flagword).hexdigest() != digest:
        return 'bad signature'

    if 'give me a flag' in flagword:
        return key


if __name__ == "__main__":
    app.run(debug=False)

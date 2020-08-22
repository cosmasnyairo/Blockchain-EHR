from flask import Flask
from flask_cors import CORS
from wallet import Wallet

app = Flask(__name__)
wallet = Wallet()
# enables opening up app to other nodes
CORS(app)


@app.route('/', methods=['GET'])
def get_ui():
    return 'It Works!'


if __name__ == '__main__':
    app.run(port=3000)

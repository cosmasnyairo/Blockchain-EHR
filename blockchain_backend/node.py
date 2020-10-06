from flask import Flask, jsonify, request
from flask_cors import CORS

from wallet import Wallet
from blockchain import Blockchain

import secrets


app = Flask(__name__)

# enables opening up app to other nodes
CORS(app)


@app.route('/create_keys', methods=['POST'])
def create_keys():
    wallet.create_keys()
    if wallet.save_keys():
        global blockchain
        blockchain = Blockchain(wallet.public_key, port)
        response = {
            'public_key': wallet.public_key,
            'private_key': wallet.private_key,
        }
        return jsonify(response), 200
    else:
        response = {'message': 'Saving keys failed!', }
        return jsonify(response), 500


@app.route('/load_keys', methods=['GET'])
def load_keys():
    if wallet.load_keys():
        global blockchain
        blockchain = Blockchain(wallet.public_key, port)
        response = {
            'public_key': wallet.public_key,
            'private_key': wallet.private_key,
        }
        return jsonify(response), 200
    else:
        response = {'message': 'Loading keys failed!', }
        return jsonify(response), 500


@app.route('/', methods=['GET'])
def get_ui():
    return 'It Works!'


@app.route('/broadcast_transaction', methods=['POST'])
def broadcast_transaction():
    values = request.get_json()
    if not values:
        response = {'message': 'No data found!'}
        return jsonify(response), 400

    required_fields = ['sender', 'receiver', 'details', 'signature']
    if not all(key in values for key in required_fields):
        response = {'message': 'Required data missing!'}
        return jsonify(response), 400
    success = blockchain.add_transaction(
        values['receiver'], values['sender'],
        values['signature'],  values['details'], is_receiving=True)
    if success:
        response = {
            'message': 'Succesfully added transaction!',
            'transaction': {
                'sender': values['sender'],
                'receiver': values['receiver'],
                'signature': values['signature'],
                'details': values['details'],
            }
        }
        return jsonify(response), 200
    else:
        response = {'message': 'Creating transaction failed!'}
        return jsonify(response), 500


@app.route('/broadcast_block', methods=['POST'])
def broadcast_block():
    values = request.get_json()
    if not values:
        response = {'message': 'No data found!'}
        return jsonify(response), 400
    if 'block' not in values:
        response = {'message': 'Required data missing!'}
        return jsonify(response), 400
    block = values['block']
    if block['index'] == blockchain.get_chain()[-1].index+1:
        if blockchain.add_block(block):
            response = {'message': 'Block added!'}
            return jsonify(response), 200
        else:
            response = {'message': 'Block seems invalid!'}
            return jsonify(response), 500

    elif block['index'] > blockchain.get_chain()[-1].index:
        pass
    else:
        response = {'message': 'Blockchain is shorter, block not added!'}
        return jsonify(response), 409


@app.route('/add_transaction', methods=['POST'])
def add_transaction():
    if wallet.private_key == None:
        response = {'message': 'No wallet set up!'}
        return jsonify(response), 400
    values = request.get_json()
    if not values:
        response = {'message': 'No data found!'}
        return jsonify(response), 400
    required_fields = ['receiver', 'details']
    if not all(f in values for f in required_fields):
        response = {'message': 'Required data missing!'}
        return jsonify(response), 400
    receiver = values['receiver']
    details = values['details']
    signature = wallet.sign_transaction(wallet.public_key, receiver, details)
    success = blockchain.add_transaction(
        receiver, wallet.public_key, signature, details)
    if success:
        response = {
            'message': 'Succesfully added transaction!',
            'transaction': {
                'sender': wallet.public_key,
                'receiver': receiver,
                'signature': signature,
                'details': details,
            }
        }
        return jsonify(response), 200
    else:
        response = {'message': 'Creating transaction failed!'}
        return jsonify(response), 500


@app.route('/mine', methods=['POST'])
def mine():
    block = blockchain.mine_block()

    if block == 0:
        response = {'message': 'No transactions to add!'}
        return jsonify(response), 500
    elif block != None:
        dt = block.__dict__.copy()
        dt['transactions'] = [tx.__dict__ for tx in dt['transactions']]
        response = {
            'message': 'Block added succesfully!',
            'block': dt
        }
        return jsonify(response), 200
    else:
        response = {
            'message': 'Adding block failed!',
            'is_wallet_setup': wallet.public_key != None
        }
        return jsonify(response), 500


@app.route('/get_opentransactions', methods=['GET'])
def get_opentransactions():
    transactions = blockchain.get_open_transactions()
    dict_tx = [tx.__dict__ for tx in transactions]
    return jsonify(dict_tx), 200


@app.route('/chain', methods=['GET'])
def get_chain():
    chain_snapshot = blockchain.get_chain()
    dict_chain = [block.__dict__.copy() for block in chain_snapshot]
    for dt in dict_chain:
        dt['transactions'] = [tx.__dict__ for tx in dt['transactions']]

    return jsonify(dict_chain), 200


@app.route('/add_node', methods=['POST'])
def add_node():
    values = request.get_json()
    if not values:
        response = {'message': 'No data found!'}
        return jsonify(response), 400
    if 'node' not in values:
        response = {'message': 'No nodes found!'}
        return jsonify(response), 400

    node = values['node']
    blockchain.add_peer_node(node)

    response = {
        'message': 'Node added successfully!',
        'nodes': blockchain.get_peer_nodes()
    }
    return jsonify(response), 200


@app.route('/remove_node/<node_url>', methods=['DELETE'])
def remove_node(node_url):

    if node_url == '' or node_url == None:
        response = {'message': 'No node found!'}
        return jsonify(response), 400

    blockchain.remove_peer_node(node_url)
    response = {
        'message': 'Node removed successfully!',
        'nodes': blockchain.get_peer_nodes()
    }
    return jsonify(response), 200


@app.route('/get_nodes', methods=['GET'])
def get_nodes():
    nodes = blockchain.get_peer_nodes()
    response = {'nodes': nodes}
    return jsonify(response), 200


if __name__ == '__main__':
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('-p', '--port', type=int, default=5000)
    args = parser.parse_args()
    port = args.port
    wallet = Wallet(port)
    blockchain = Blockchain(wallet.public_key, port)
    # use local ip address
    app.run(host=secrets.ip_address, port=port)

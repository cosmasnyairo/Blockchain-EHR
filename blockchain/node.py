import os
import json
from time import time
import socket
from contextlib import closing
from flask import Flask, jsonify, request
from flask_cors import CORS

from blockchain import Blockchain
from transaction import Transaction
from wallet import Wallet

app = Flask(__name__)
unauthenticated = Flask(__name__)

# enables opening up app to other nodes
CORS(app)
CORS(unauthenticated)


@app.route('/create_keys', methods=['POST'])
def create_keys():
    wallet.create_keys()
    if wallet.save_keys():
        global blockchain
        blockchain = Blockchain(wallet.public_key, port, host)
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
        blockchain = Blockchain(wallet.public_key, port, host)
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

    required_fields = ['sender', 'receiver',
                       'details', 'signature', 'timestamp']
    if not all(key in values for key in required_fields):
        response = {'message': 'Required data missing!'}
        return jsonify(response), 400
    success = blockchain.add_transaction(
        values['receiver'], values['sender'],
        values['signature'],  values['details'], values['timestamp'], is_receiving=True)
    if success:
        response = {
            'message': 'Succesfully added transaction!',
            'transaction': {
                'sender': values['sender'],
                'receiver': values['receiver'],
                'signature': values['signature'],
                'details': values['details'],
                'timestamp': values['timestamp']
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
            return jsonify(response), 409

    elif block['index'] > blockchain.get_chain()[-1].index:
        blockchain.resolve_conflicts = True
        response = {'message': 'Blockchain differes from local chain!'}
        return jsonify(response), 200
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
    required_fields = ['receiver', 'details', 'timestamp']
    if not all(f in values for f in required_fields):
        response = {'message': 'Required data missing!'}
        return jsonify(response), 400
    receiver = values['receiver']
    details = values['details']
    timestamp = values['timestamp']
    signature = wallet.sign_transaction(wallet.public_key, receiver, details)

    success = blockchain.add_transaction(
        receiver, wallet.public_key, signature, details, timestamp)
    if success:
        response = {
            'message': 'Succesfully added transaction!',
            'transaction': {
                'sender': wallet.public_key,
                'receiver': receiver,
                'signature': signature,
                'details': details,
                'timestamp': timestamp,
            }
        }
        return jsonify(response), 200
    else:
        response = {'message': 'Creating transaction failed!'}
        return jsonify(response), 500


@app.route('/mine', methods=['POST'])
def mine():
    if blockchain.resolve_conflicts:
        response = {'message': 'Resolve conflicts first,block not added!'}
        return jsonify(response), 409

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


@app.route('/resolve_conflicts', methods=['POST'])
def resolve_conflicts():
    replaced = blockchain.resolve()
    if replaced:
        response = {'message': 'Chain was replaced!'}
        return jsonify(response), 400
    else:
        response = {'message': 'Local chain kept!'}
    return jsonify(response), 200


@app.route('/get_opentransactions', methods=['GET'])
def get_opentransactions():
    transactions = blockchain.get_open_transactions()
    dict_tx = [tx.__dict__ for tx in transactions]
    return jsonify(dict_tx), 200


def f(tx, receiver):
    transaction = tx.__dict__.copy()
    finaltransaction = {}
    if(transaction['receiver'] == receiver):
        finaltransaction = transaction
    return finaltransaction

def d(tx, sender):
    transaction = tx.__dict__.copy()
    finaltransaction = {}
    if(transaction['sender'] == sender):
        finaltransaction = transaction
    return finaltransaction

@app.route('/patientchain', methods=['POST'])
def get_patient_chain():
    values = request.get_json()
    if not values:
        response = {'message': 'No data found!'}
        return jsonify(response), 400
    required_fields = ['receiver']
    if not all(f in values for f in required_fields):
        response = {'message': 'Required data missing!'}
        return jsonify(response), 400
    receiver = values['receiver']

    chain_snapshot = blockchain.get_chain()
    dict_chain = [block.__dict__.copy() for block in chain_snapshot]

    for dt in dict_chain:
        dt['transactions'] = [f(tx, receiver) for tx in dt['transactions']]
        # work on this duplicate
        [dt['transactions'].remove(tx)
         for tx in dt['transactions'] if tx == {}]
        [dt['transactions'].remove(tx)
         for tx in dt['transactions'] if tx == {}]

    new_chain = [item for item in dict_chain if item['transactions'] != []]

    return jsonify(new_chain), 200


@app.route('/doctorchain', methods=['POST'])
def get_doctor_chain():
    values = request.get_json()
    if not values:
        response = {'message': 'No data found!'}
        return jsonify(response), 400
    required_fields = ['sender']
    if not all(f in values for f in required_fields):
        response = {'message': 'Required data missing!'}
        return jsonify(response), 400
    sender = values['sender']

    chain_snapshot = blockchain.get_chain()
    dict_chain = [block.__dict__.copy() for block in chain_snapshot]

    for dt in dict_chain:
        dt['transactions'] = [d(tx, sender) for tx in dt['transactions']]
        # work on this duplicate
        [dt['transactions'].remove(tx)
         for tx in dt['transactions'] if tx == {}]
        [dt['transactions'].remove(tx)
         for tx in dt['transactions'] if tx == {}]

    new_chain = [item for item in dict_chain if item['transactions'] != []]
    return jsonify(new_chain), 200



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
    }
    return jsonify(response), 200


@app.route('/get_nodes', methods=['GET'])
def get_nodes():

    nodes = blockchain.get_peer_nodes()
    response = {'nodes': nodes}
    return jsonify(response), 200


@unauthenticated.route('/check_status', methods=['POST'])
def check_status():
    values = request.get_json()
    if not values:
        response = {'message': 'No data found!'}
        return jsonify(response), 400
    useremail, username = values['useremail'], values['username']
    path = 'data/peers.json'

    if os.path.exists(path):
        with open(path) as json_file:
            loaded = json.load(json_file)
            assigned = loaded['assigned']
            unassigned = loaded['unassigned']
            assigneddetail = [
                i for i in assigned if useremail == i['useremail']]

            unassigneddetail = [
                i for i in unassigned if useremail == i['useremail']]

            if len(assigneddetail) > 0:
                response = {'message': assigneddetail[0]['assigned_port']}
                return jsonify(response), 200
            elif len(unassigneddetail) > 0:
                response = {'message': 'Your request is in the queue'}
                return jsonify(response), 401
            elif (username, useremail) not in unassigned and assigned:
                data = {
                    "assigned_port": find_free_port(), "date_requested": time(),
                    "username": username, "useremail": useremail,
                }
                response = {'message': 'Your request is in the queue'}
                unassigned.append(data)
                with open(path, mode='w') as f:
                    json.dump(loaded, f, indent=4)
                    response = {'message': 'Your request has been received'}
                    return jsonify(response), 401

    else:
        response = {'message': 'An error occurred. Please try again'}
        return jsonify(response), 200


def find_free_port():
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
        s.bind(('', 0))
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.getsockname()[1]
        return s.getsockname()[1]


@unauthenticated.route('/assign', methods=['POST'])
def register_port():
    # logic for assigning port to user and running it
    values = request.get_json()
    if not values:
        response = {'message': 'No data found!'}
        return jsonify(response), 400
    username, useremail = values['username'], values['useremail']

    assigned_port = find_free_port()

    data = {
        "assigned_port": assigned_port, "date_requested": time(),
        "username": username, "useremail": useremail,
    }

    path = 'data/peers.json'
    if os.path.exists(path):
        with open(path) as json_file:
            loaded = json.load(json_file)
            assigned = loaded['assigned']
            unassigned = loaded['unassigned']
            if assigned_port in ([i['assigned_port'] for i in assigned] or [i['assigned_port'] for i in unassigned] or range(0, 2)):
                response = {'message': 'An error occurred'}
                return jsonify(response), 401
            else:
                unassigned.append(data)
                with open(path, mode='w') as f:
                    json.dump(loaded, f, indent=4)
                    response = {'message': 'Your request has been received'}
                    return jsonify(response), 200
    else:
        with open(path, mode='w') as f:
            json.dump({"unassigned": [data], "assigned": []}, f, indent=4)
        response = {'message': 'Your request has been received'}
        return jsonify(response), 200


if __name__ == '__main__':
    from argparse import ArgumentParser

    parser = ArgumentParser()
    parser.add_argument('-p', '--port', type=int, default=5000)
    parser.add_argument('--host', type=str)
    args = parser.parse_args()
    global host
    port, host = args.port, args.host
    if port == 2:
        unauthenticated.run(host=host, port=port)
    else:
        wallet = Wallet(port)
        blockchain = Blockchain(wallet.public_key, port, host)
        app.run(host=host, port=port)

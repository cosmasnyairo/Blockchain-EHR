# To do: 1. Reward miners
import json
import requests

# these two can be used to reduce the memory size of the blockchain and files storing it
# import pickle
# import sqlite3

# import block class
from block import Block
from transaction import Transaction
from utility.verification import Verification
from utility.hash_util import hash_block
from wallet import Wallet

import secrets


class Blockchain:

    def __init__(self, public_key, node_id, hostname):
        # Genesis block
        genesis_block = Block(0, '', [], 100, 0)
        # Empty blockchain
        self.__chain = [genesis_block]
        self.__open_transactions = []
        self.public_key = public_key
        self.__peer_nodes = set()
        self.node_id = node_id
        self.resolve_conflicts = False
        self.hostname = hostname
        self.load_data()

    def get_chain(self):

        return self.__chain[:]

    def get_open_transactions(self):
        return self.__open_transactions[:]

    def load_data(self):
        # load data from the txt file
        try:
            with open('data/blockchain-{}.json'.format(self.node_id), mode='r') as f:
                file_content = json.load(f)
                # file_content = loaddata(self.node_id)
                # we escape the \n using range
                blockchain = file_content["blockchain"]
                open_transactions = file_content["opentransactions"]
                peer_nodes = file_content["peer_nodes"]

                # ordered dicts aid in using odering to calculate the guess in valid proof
                updated_blockchain = []

                for block in blockchain:
                    converted_transaction = [Transaction(
                        tx['sender'],
                        tx['receiver'],
                        tx['signature'],
                        tx['details'],
                        tx['timestamp']
                    ) for tx in block['transactions']]

                    updated_block = Block(
                        block['index'],
                        block['previous_hash'],
                        converted_transaction,
                        block['proof'],
                        block['timestamp'],
                    )
                    updated_blockchain.append(updated_block)
                self.__chain = updated_blockchain

                updated_transactions = []
                for tx in open_transactions:
                    updated_transaction = Transaction(
                        tx['sender'],
                        tx['receiver'],
                        tx['signature'],
                        tx['details'],
                        tx['timestamp']
                    )
                    updated_transactions.append(updated_transaction)
                self.__open_transactions = updated_transactions

                self.__peer_nodes = set(peer_nodes)

        except (IOError, IndexError):
            pass

    def save_data(self):
        try:
            with open('data/blockchain-{}.json'.format(self.node_id), mode='w') as f:
                data = {}
                data["blockchain"] = []
                data["opentransactions"] = []
                data["peer_nodes"] = []
                saveable_chain = [block.__dict__ for block in [
                    # convert transactions to transaction object that can be json dumped
                    Block(
                        bl.index,
                        bl.previous_hash,
                        [tx.__dict__ for tx in bl.transactions],
                        bl.proof,
                        bl.timestamp
                    )for bl in self.__chain]]
                saveable_tx = [tx.__dict__ for tx in self.__open_transactions]
                data["blockchain"] = saveable_chain
                data["opentransactions"] = saveable_tx
                data["peer_nodes"] = list(self.__peer_nodes)
                json.dump(data, f, indent=4)

                # savedata(self.node_id, saveable_chain,
                #          saveable_tx, list(self.__peer_nodes))
        except IOError:
            print('Saving Failed'+IOError.message)

    def proof_of_work(self):
        #  proof of work algorithm
        last_block = self.__chain[-1]
        last_hash = hash_block(last_block)
        proof = 0
        while not Verification.valid_proof(self.__open_transactions, last_hash, proof):
            proof += 1
        return proof

    def last_blockchain_value(self):
        """ Returns the last value of the current blockchain. """
        if len(self.__chain) < 1:
            return None
        return self.__chain[-1]

    def add_transaction(self, receiver, sender, signature, details, timestamp, is_receiving=False):
        """ Append a new value as well as the last blockchain value to the blockchain.

            Arguments:
                sender:     Sender of the details.
                receiver:  Recepient of the details.
                signature:  Signature of the transaction
                details:    Details to be sent with the transaction.
        """
        if self.public_key == None:
            return False
        transaction = Transaction(
            sender, receiver, signature, details, timestamp)
        if not Wallet.verify_transaction(transaction):
            return False
        self.__open_transactions.append(transaction)
        self.save_data()
        if not is_receiving:
            for node in self.__peer_nodes:
                url = 'http://{}:{}/broadcast_transaction'.format(
                    self.hostname, node)
                print(url)
                try:
                    response = requests.post(url, json={
                        'sender':   sender,
                        'receiver':  receiver,
                        'signature':  signature,
                        'details':    details,
                        'timestamp': timestamp})
                    if response.status_code == 400 or response.status_code == 500:
                        print('Transaction declined, needs resolving')
                        return False
                except requests.exceptions.ConnectionError:
                    # continue to next node
                    continue
        return True

    def add_block(self, block):
        transactions = [Transaction(
            tx['sender'], tx['receiver'], tx['signature'], tx['details'], tx['timestamp']) for tx in block['transactions']]
        proof_isvalid = Verification.valid_proof(
            transactions, block['previous_hash'], block['proof'])
        hashes_match = hash_block(self.__chain[-1]) != block['previous_hash']
        if not proof_isvalid or not hashes_match:
            return False
        converted_block = Block(
            block['index'],
            block['previous_hash'],
            transactions,
            block['proof'],
            block['timestamp']
        )
        self.__chain.append(converted_block)
        stored_transactions = self.__open_transactions[:]
        for incomingtx in block['transactions']:
            for opentx in stored_transactions:
                print(opentx == incomingtx)
                if opentx.sender == incomingtx['sender'] and opentx.receiver == incomingtx['receiver'] and opentx.details == incomingtx['details'] and opentx.signature == incomingtx['signature']:
                    try:
                        self.__open_transactions.remove(opentx)
                    except ValueError:
                        print('Item was already removed')

        self.save_data()
        return True

    def mine_block(self):
        if self.public_key == None:
            print('a')
            return None
        if len(self.__open_transactions) <= 0:
            print('b')
            return 0
        last_block = self.__chain[-1]
        hashed_block = hash_block(last_block)
        proof = self.proof_of_work()

        block = Block(
            len(self.__chain),
            hashed_block,
            self.__open_transactions,
            proof
        )
        for tx in block.transactions:
            if not Wallet.verify_transaction(tx):
                return None
        print(block)
        self.__chain.append(block)
        self.__open_transactions = []
        self.save_data()
        for node in self.__peer_nodes:
            url = 'http://{}:{}/broadcast_block'.format(
                self.hostname, node)
            print(url)
            converted_block = block.__dict__.copy()
            converted_block['transactions'] = [
                tx.__dict__ for tx in converted_block['transactions']]
            try:
                response = requests.post(url, json={
                    'block':   converted_block, })
                if response.status_code == 400 or response.status_code == 500:
                    print('Block declined, needs resolving')
                if response.status_code == 409:
                    self.resolve_conflicts = True
            except requests.exceptions.ConnectionError:
                # continue to next node
                continue
        return block

    def resolve(self):
        # we use the longest chain to achieve consensus
        winner_chain = self.get_chain()
        replace = False
        for node in self.__peer_nodes:
            url = 'http://{}:{}/chain'.format(
                self.hostname, node)
            try:
                response = requests.get(url)
                node_chain = response.json()
                node_chain = [Block(
                    block['index'],
                    block['previous_hash'],
                    [Transaction(
                     tx['sender'],
                     tx['receiver'],
                     tx['signature'],
                     tx['details'],
                     tx['timestamp'],
                     ) for tx in block['transactions']],
                    block['proof'],
                    block['timestamp'],
                ) for block in node_chain]
                node_chain_length = len(node_chain)
                local_chain_length = len(winner_chain)
                if node_chain_length > local_chain_length and Verification.verify_chain(node_chain):
                    winner_chain = node_chain
                    replace = True
            except requests.exceptions.ConnectionError:
                # continue to next node
                continue

        self.resolve_conflicts = False
        self.__chain = winner_chain
        if replace:
            self.__open_transactions = []
        self.save_data()
        return replace

    def add_peer_node(self, node):
        """Adds a new node to peer set \n
        Arguments: \n
            node: node url to be added
        """
        self.__peer_nodes.add(node)
        self.save_data()

    def remove_peer_node(self, node):
        """Removes a new node to peer set \n
        Arguments: \n
            node: node url to be removed
        """
        self.__peer_nodes.discard(node)
        self.save_data()

    def get_peer_nodes(self):
        """
        Returns all peer nodes
        """
        return list(self.__peer_nodes)[:]

    def __repr__(self):
        return str(self.__dict__)

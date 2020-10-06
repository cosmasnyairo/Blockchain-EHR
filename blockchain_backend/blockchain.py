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

    def __init__(self, public_key, node_id):
        # Genesis block
        genesis_block = Block(0, '', [], 100, 0)
        # Empty blockchain
        self.__chain = [genesis_block]
        self.__open_transactions = []
        self.public_key = public_key
        self.__peer_nodes = set()
        self.node_id = node_id
        self.load_data()

        # We will Store patient details in the blockchain
        # work on transaction validity

        # conn = sqlite3.connect('blockchain.db')
        # cursor = conn.cursor()

        # def createtable():
        #     cursor.execute(
        #         "CREATE TABLE IF NOT EXISTS blockchainstore(item Text,quantity Text)")
        #     conn.commit()

    def get_chain(self):
        return self.__chain[:]

    def get_open_transactions(self):
        return self.__open_transactions[:]

    def load_data(self):
        # load data from the txt file
        try:
            with open('data/blockchain-{}.json'.format(self.node_id), mode='r') as f:
                file_content = json.load(f)
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
                # f.write(json.dumps(saveable_chain))
                saveable_tx = [tx.__dict__ for tx in self.__open_transactions]
                # f.write(json.dumps(saveable_tx))

                data["blockchain"] = saveable_chain
                data["opentransactions"] = saveable_tx
                data["peer_nodes"] = list(self.__peer_nodes)
                json.dump(data, f)
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

    def add_transaction(self, receiver, sender, signature, details, is_receiving=False):
        """ Append a new value as well as the last blockchain value to the blockchain.

            Arguments:
                sender:     Sender of the details.
                receiver:  Recepient of the details.
                signature:  Signature of the transaction
                details:    Details to be sent with the transaction.
        """
        if self.public_key == None:
            return False
        transaction = Transaction(sender, receiver, signature, details)
        if not Wallet.verify_transaction(transaction):
            return False
        self.__open_transactions.append(transaction)
        self.save_data()
        if not is_receiving:
            for node in self.__peer_nodes:
                url = 'http://{}:{}/broadcast_transaction'.format(
                    secrets.ip_address, node)
                try:
                    response = requests.post(url, json={
                        'sender':   sender,
                        'receiver':  receiver,
                        'signature':  signature,
                        'details':    details})
                    if response.status_code == 400 or response.status_code == 500:
                        print('Transaction declined, needs resolving')
                        return False
                except requests.exceptions.ConnectionError:
                    # continue to next node
                    continue
        return True

    def mine_block(self):
        if self.public_key == None:
            return None
        if len(self.__open_transactions) <= 0:
            return 0
        last_block = self.__chain[-1]
        hashed_block = hash_block(last_block)
        proof = self.proof_of_work()

        # mined_details = {
        #     'visit_date': time,
        #     'mining_points': Gold_points,
        # }

        # mined_transaction = Transaction('MINING', self.public_key, ,'', mined_details)
        # copied_tx = self.__open_transactions[:]
        # copied_tx.append(mined_transaction)

        # #alternatively append open transactions instead of copied_tx

        block = Block(
            len(self.__chain),
            hashed_block,
            self.__open_transactions,
            proof
        )
        for tx in block.transactions:
            if not Wallet.verify_transaction(tx):
                return None

        self.__chain.append(block)
        self.__open_transactions = []
        self.save_data()
        return block

    def __repr__(self):
        return str(self.__dict__)

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

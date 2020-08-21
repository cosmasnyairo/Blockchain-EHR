# To do: 1. Reward miners

import hashlib
import json

# these two can be used to reduce the memory size of the blockchain and files storing it
# import pickle
# import sqlite3

from hash_util import hash_string_sha256, hash_block

# import block class
from classes.block import Block
from classes.transaction import Transaction

blockchain = []
open_transactions = []
owner = 'Cosmas'
# We will Store patient details in the blockchain

# work on transaction validity


# conn = sqlite3.connect('blockchain.db')
# cursor = conn.cursor()

# def createtable():
#     cursor.execute(
#         "CREATE TABLE IF NOT EXISTS blockchainstore(item Text,quantity Text)")
#     conn.commit()

def load_data():
    global blockchain
    global open_transactions
    # load data from the txt file
    try:
        with open('data/blockchain.txt', mode='r') as f:
            file_content = f.readlines()

            # we escape the \n using range
            blockchain = json.loads(file_content[0][:-1])
            open_transactions = json.loads(file_content[1])

            # ordered dicts bring an error on blockchain and open transactions so we fix it here
            # ordered dicts aid in using odering to calculate the guess in valid proof
            updated_blockchain = []

            for block in blockchain:
                converted_transaction = [Transaction(
                    tx['sender'],
                    tx['receiver'],
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
            blockchain = updated_blockchain

            updated_transactions = []
            for tx in open_transactions:
                updated_transaction = Transaction(
                    tx['sender'],
                    tx['receiver'],
                    tx['details'],
                )
                updated_transactions.append(updated_transaction)
            open_transactions = updated_transactions
    except (IOError, IndexError):
        genesis_block = Block(0, '', [], 100, 0)
        blockchain = [genesis_block]
        open_transactions = []


load_data()


def save_data():
    # createtable()
    # cursor.execute("INSERT INTO blockchainstore VALUES(?,?)", (str(blockchain), str(open_transactions)))
    # conn.commit()
    try:
        with open('data/blockchain.txt', mode='w') as f:
            saveable_chain = [block.__dict__ for block in [
                #convert transactions to transaction object that can be json dumped
                Block(
                    bl.index,
                    bl.previous_hash,
                    [tx.__dict__ for tx in bl.transactions],
                    bl.proof,
                    bl.timestamp
                )for bl in blockchain]]
            f.write(json.dumps(saveable_chain))
            f.write('\n')
            saveable_tx = [tx.__dict__ for tx in open_transactions]
            f.write(json.dumps(saveable_tx))
    except IOError:
        print('Saving Failed')


def valid_proof(transactions, last_hash, proof_number):
    """ Calculate validity of proof number \n
        We can change the '00' value to make the proof calculation complex
    """
    # guess has all hash inputs
    guess = (str([tx.to_ordered_dict() for tx in transactions]) +
             str(last_hash) + str(proof_number)).encode()
    guess_hash = hash_string_sha256(guess)
    return guess_hash[0:2] == '00'


def proof_of_work():
    #  proof of work algorithm
    last_block = blockchain[-1]
    last_hash = hash_block(last_block)
    proof = 0
    while not valid_proof(open_transactions, last_hash, proof):
        proof += 1
    return proof


def last_blockchain_value():
    """ Returns the last value of the current blockchain. """
    if len(blockchain) < 1:
        return None
    return blockchain[-1]


def add_transaction(receiver, sender=owner, details=1.0):
    """ Append a new value as well as the last blockchain value to the blockchain.

        Arguments:
            sender:     Sender of the details.
            recipient:  Recepient of the details.
            details:    Details to be sent with the transaction.
    """
    transaction = Transaction(sender, receiver, details)
    open_transactions.append(transaction)
    save_data()


def mine_block():
    last_block = blockchain[-1]
    hashed_block = hash_block(last_block)
    proof = proof_of_work()
    # reward miners
    # allow users to add their details
    # we will append them here if need be
    # replace open transactions with a list of our details we want to add
    
    block = Block(len(blockchain), hashed_block, open_transactions, proof)
    blockchain.append(block)
    save_data()
    return True


def get_transaction():

    tx_recipient = input('Enter recipeint of transaction: ')

    # visit_time = float(input('Time of visit:'))
    medical_notes = input('Enter Medical notes: ')
    diagnosis = input('Enter Diagnosis: ')
    # split converts to a list
    prescription = [input('Enter Prescription(s): ')]
    lab_results = input('Enter lab result(s): ')

    tx_transaction_details = {
        # 'doctor_name':
        'medical_notes': medical_notes,
        'diagnosis': diagnosis,
        'prescription': prescription,
        'lab_results': lab_results
    }
    return tx_recipient, tx_transaction_details


def get_choice():
    """Gets choice from the user."""
    user_input = input('Your choice: ')
    return user_input


def print_blockchain():
    """ Output blocks of the blockchain. """

    for i, block in enumerate(blockchain):
        print('Block index', i)
        print(block)
    else:
        print('-' * 20)


def verify_chain():
    """ Verify the current blockchain and return True if it's valid."""
    for (index, block) in enumerate(blockchain):
        if index == 0:
            continue
        if block.previous_hash != hash_block(blockchain[index-1]):
            return False
        if not valid_proof(block.transactions, block.previous_hash, block.proof):
            print('Proof of work invalid')
            return False
    return True


user_inputted = True

while user_inputted:
    print('Please choose')
    print('1: Add new transaction')
    print('2: Mine a new block')
    print('3: Output blocks')
    print('e: Exit')

    user_choice = get_choice()

    if user_choice == '1':
        tx_data = get_transaction()
        recipient, transaction_details = tx_data
        add_transaction(recipient, details=transaction_details)
        print(open_transactions)

    elif user_choice == '2':
        if mine_block():
            open_transactions = []
            save_data()

    elif user_choice == '3':
        print_blockchain()

    elif user_choice == 'e':
        # exits from the blockchain
        print('Exited from the blockchain')
        print('Blockchain is : ', blockchain)
        user_inputted = False

    else:
        print('Input was invalid, please pick a value from the list!')

    if not verify_chain():
        print_blockchain()
        print('Blockchain is invalid!')
        break

else:
    print('User left!')
    print('-' * 20)

print('Bye!')

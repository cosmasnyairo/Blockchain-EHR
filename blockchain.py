# reward miners
import hashlib
from collections import OrderedDict

from hash_util import hash_string_sha256, hash_block

genesis_block = {
    'previous_hash': '',
    'index': 0,
    'transactions': [],
    'proof': 100
}
blockchain = [genesis_block]

open_transactions = []
owner = 'Cosmas'
participants = {'Cosmas'}
# We will Store patient details in the blockchain

# work on transaction validity


def valid_proof(transactions, last_hash, proof_number):
    """ Calculate validity of proof number \n
        We can change the '00' value to make the proof calculation complex
    """
    guess = (str(transactions)+str(last_hash) + str(proof_number)).encode()
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
    transaction = OrderedDict([
        ('sender', sender),
        ('receiver', receiver),
        ('details', details)
    ])
    open_transactions.append(transaction)
    participants.add(sender)
    participants.add(recipient)


def mine_block():
    last_block = blockchain[-1]
    hashed_block = hash_block(last_block)
    proof = proof_of_work()
    block = {
        'previous_hash': hashed_block,
        'index': len(blockchain),
        'transactions': open_transactions,
        'proof': proof
    }
    blockchain.append(block)
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
        if block['previous_hash'] != hash_block(blockchain[index-1]):
            return False
        if not valid_proof(block['transactions'], block['previous_hash'], block['proof']):
            print('Proof of work invalid')
            return False
    return True


user_inputted = True

while user_inputted:
    print('Please choose')
    print('1: Add new transaction')
    print('2: Mine a new block')
    print('3: Output participants')
    print('4: Output blocks')
    print('m: Manipulate blockchain')
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

    elif user_choice == '3':
        print(participants)

    elif user_choice == '4':
        print_blockchain()

    elif user_choice == 'm':
        if len(blockchain) >= 1:
            blockchain[0] = {
                'previous_hash': '',
                'index': 0,
                'transactions': [{
                    'sender': 'Cosmas',
                    'receiver': 'Cos',
                    'details': {
                        'medical_notes': 'fjda',
                        'diagnosis': 'ju, fdj',
                        'prescription': ['dk.g, gr, dsuf'],
                        'lab_results': 'nhyfd'
                    }
                }],
            }

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

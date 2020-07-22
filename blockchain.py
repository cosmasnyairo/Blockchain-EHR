genesis_block = {
    'previous_hash': '',
    'index': 0,
    'transactions': [],
}
blockchain = [genesis_block]

open_transactions = []
owner = 'Cosmas'
# We will Store patient details in the blockchain


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
    transaction = {'sender': sender, 'receiver': receiver, 'details': details}
    open_transactions.append(transaction)


def mine_block():
    last_block = blockchain[-1]
    hashed_block = ''
    for key in last_block:
        value = last_block[key]
        hashed_block = hashed_block+str(value)
    print(hashed_block)
    block = {
        'previous_hash': hashed_block,
        'index': len(blockchain),
        'transactions': open_transactions,
    }
    blockchain.append(block)


def get_transaction():

    tx_recipient = input('Enter recipeint of transaction: ')

    #visit_time = float(input('Time of visit:'))
    medical_notes = input('Enter Medical notes: ')
    diagnosis = input('Enter Diagnosis: ')
    # split converts to a list
    prescription = [input('Enter Prescription(s): ')]
    lab_results = input('Enter lab result(s): ')

    tx_transaction_details = {
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
    is_valid = True
    for block_index in range(len(blockchain)):
        if block_index == 0:
            # first block of blockchain
            continue
        elif blockchain[block_index][0] == blockchain[block_index - 1]:
            is_valid = True
        else:
            is_valid = False
            break
    return is_valid


user_inputted = True

while user_inputted:
    print('Please choose')
    print('1: Add new transaction')
    print('2: Mine a new block')
    print('3: Output blocks')
    print('m: Manipulate blockchain')
    print('e: Exit')

    user_choice = get_choice()

    if user_choice == '1':
        tx_data = get_transaction()
        recipient, transaction_details = tx_data
        add_transaction(recipient, details=transaction_details)
        print(open_transactions)

    elif user_choice == '2':
        mine_block()

    elif user_choice == '3':
        print_blockchain()

    elif user_choice == 'm':
        if len(blockchain) >= 1:
            blockchain[0] = [2]

    elif user_choice == 'e':
        # exits from the blockchain
        print('Exited from the blockchain')
        print('Blockchain is : ', blockchain)
        user_inputted = False

    else:
        print('Input was invalid, please pick a value from the list!')

    # if not verify_chain():
    #     print_blockchain()
    #     print('Blockchain is invalid!')
    #     break

else:
    print('Bye!')
    print('-' * 20)

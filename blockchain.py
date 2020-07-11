blockchain = []
# We will Store patient details in the blockchain

def last_blockchain_value():
    """ Returns the last value of the current blockchain. """
    if len(blockchain) < 1:
        return None
    return blockchain[-1]


def add_transaction(transaction_amount, last_transaction=[1]):
    """ Append a new value as well as the last blockchain value to the blockchain.

        Arguments:

            :'transaction_amount': The amount to be added to the chain. 

            :'last_transaction': The last blockchain transaction.
    """
    if last_transaction == None:
        last_transaction = [1]
    blockchain.append([last_transaction, transaction_amount])


def get_transaction():
    user_input = float(input('Your transaction amount:'))
    return user_input


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
    """ Verify the current blockchain and return True if it's valid, False otherwise."""
    is_valid = True
    for block_index in range(len(blockchain)):
        # We skip the first if if we're checking the first block
        if block_index == 0:
            continue
        elif blockchain[block_index][0] == blockchain[block_index - 1]:
            is_valid = True
        else:
            is_valid = False
    return is_valid


user_inputted = True

while user_inputted:
    print('Please choose')
    print('1: Add new transaction')
    print('2: Output blocks')
    print('m: Manipulate blockchain')
    print('e: Exit')

    user_choice = get_choice()

    if user_choice == '1':
        tx_amount = get_transaction()
        add_transaction(tx_amount, last_blockchain_value())
        print(tx_amount, 'added to blockchain')

    elif user_choice == '2':
        print_blockchain()

    elif user_choice == 'm':
        if len(blockchain) >= 1:
            blockchain[0] = [2]

    elif user_choice == 'e':
        print('Blockchain is : ', blockchain)
        user_inputted = False

    else:
        print('Input was invalid, please pick a value from the list!')

    if not verify_chain():
        print_blockchain()
        print('Blockchain is invalid!')
        break

else:
    print('Bye!')

from uuid import uuid4

from blockchain import Blockchain
from utility.verification import Verification
from wallet import Wallet


class Node:

    def __init__(self):
        #self.wallet = str(uuid4())
        self.wallet = Wallet()
        self.blockchain = Blockchain(self.wallet.public_key)

    def get_transaction(self):
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

    def get_choice(self):
        """Gets choice from the user."""
        user_input = input('Your choice: ')
        return user_input

    def print_blockchain(self):
        """ Output blocks of the blockchain. """

        for block in self.blockchain.get_chain():
            print('Outputting the blockchain')
            print(block)
        else:
            print('-' * 20)

    def listen_for_input(self):
        user_inputted = True

        while user_inputted:
            print('Please choose')
            print('1: Add new transaction')
            print('2: Mine a new block')
            print('3: Output blocks')
            print('4: Create wallet')
            print('5: Load wallet')
            print('e: Exit')

            user_choice = self.get_choice()

            if user_choice == '1':
                tx_data = self.get_transaction()
                recipient, transaction_details = tx_data
                self.blockchain.add_transaction(
                    recipient,
                    self.wallet.public_key,
                    details=transaction_details
                )
                print(self.blockchain.get_open_transactions())

            elif user_choice == '2':
                self.blockchain.mine_block()

            elif user_choice == '3':
                self.print_blockchain()

            elif user_choice == '4':
                self.wallet.create_keys()
            elif user_choice == '5':
                pass
            elif user_choice == 'e':
                # exits from the blockchain
                print('Exited from the blockchain')
                print('Blockchain is : ', self.blockchain)
                user_inputted = False

            else:
                print('Input was invalid, please pick a value from the list!')

            if not Verification.verify_chain(self.blockchain.get_chain()):
                self.print_blockchain()
                print('Blockchain is invalid!')
                break

        else:
            print('User left!')
            print('-' * 20)

        print('Bye!')


node = Node()
node.listen_for_input()

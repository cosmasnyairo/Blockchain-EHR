from time import time


class Block:
    def __init__(self, index, user_port,previous_hash,transactions, proof, time=time()):
        self.index = index
        self.user_port= user_port
        self.previous_hash = previous_hash
        self.transactions = transactions
        self.proof = proof
        self.timestamp = time

    def __repr__(self):
        return str(self.__dict__)
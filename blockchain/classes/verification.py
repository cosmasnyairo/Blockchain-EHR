import os

from hash_util import hash_string_sha256, hash_block

class Verification:
    def valid_proof(self,transactions, last_hash, proof_number):
        """ Calculate validity of proof number \n
            We can change the '00' value to make the proof calculation complex
        """
        # guess has all hash inputs
        guess = (str([tx.to_ordered_dict() for tx in transactions]) +
                str(last_hash) + str(proof_number)).encode()
        guess_hash = hash_string_sha256(guess)
        return guess_hash[0:2] == '00'

    def verify_chain(self,blockchain):
        """ Verify the current blockchain and return True if it's valid."""
        for (index, block) in enumerate(blockchain):
            if index == 0:
                continue
            if block.previous_hash != hash_block(blockchain[index-1]):
                return False
            if not self.valid_proof(block.transactions, block.previous_hash, block.proof):
                print('Proof of work invalid')
                return False
        return True
    
    
   
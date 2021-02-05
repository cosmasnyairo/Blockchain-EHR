import json

from Crypto.PublicKey import RSA

from Crypto.Signature import PKCS1_v1_5
from Crypto.Hash import SHA256
import Crypto.Random

import binascii

# from data import savekeys, loadkeys


class Wallet:
    def __init__(self, node_id):
        self.private_key = None
        self.public_key = None
        self.node_id = node_id

    def create_keys(self):
        private_key, public_key = self.generate_keys()
        self.private_key = private_key
        self.public_key = public_key

    def save_keys(self):
        if self.private_key != None and self.public_key != None:
            try:
                with open('data/wallet-{}.json'.format(self.node_id), mode='w') as f:
                    data = {}
                    data["public_key"] = self.public_key
                    data["private_key"] = self.private_key
                    json.dump(data, f, indent=4)
                # savekeys(self.node_id, self.public_key, self.private_key)
                return True
            except (IOError, IndexError):
                print('Saving wallet failed')
                return False

    def load_keys(self):
        try:
            # keys = loadkeys(self.node_id)
            with open('data/wallet-{}.json'.format(self.node_id), mode='r') as f:
                keys = json.load(f)
                public_key = keys["public_key"]
                private_key = keys["private_key"]
                self.public_key = public_key
                self.private_key = private_key
            return True
        except (IOError, IndexError):
            print('Loading wallet failed')
            return False

    def generate_keys(self):
        private_key = RSA.generate(1024, Crypto.Random.new().read)
        public_key = private_key.publickey()
        return (
            binascii.hexlify(private_key.exportKey(
                format='DER')).decode('ascii'),
            binascii.hexlify(public_key.exportKey(
                format='DER')).decode('ascii')
        )

    def sign_transaction(self, sender, recipient, details):
        signer = PKCS1_v1_5.new(RSA.importKey(
            binascii.unhexlify(self.private_key)))
        h = SHA256.new((str(sender)+str(recipient) +
                        str(details)).encode('utf8 '))
        signature = signer.sign(h)
        print(signature)
        print(binascii.hexlify(signature).decode('ascii'))
        return binascii.hexlify(signature).decode('ascii')

    @staticmethod
    def verify_transaction(transaction):
        public_key = RSA.importKey(binascii.unhexlify(transaction.sender))
        verifier = PKCS1_v1_5.new(public_key)
        h = SHA256.new((str(transaction.sender)+str(transaction.receiver) +
                        str(transaction.details)).encode('utf8 '))
        return verifier.verify(h, binascii.unhexlify(transaction.signature))

from Crypto.PublicKey import RSA

from Crypto.Signature import PKCS1_v1_5
from Crypto.Hash import SHA256
import Crypto.Random

import binascii


class Wallet:
    def __init__(self):

        self.private_key = None
        self.public_key = None

    def create_keys(self):
        private_key, public_key = self.generate_keys()
        self.private_key = private_key
        self.public_key = public_key

    def save_keys(self):
        if self.private_key != None and self.public_key != None:
            try:
                with open('data/wallet.txt', mode='w') as f:
                    f.write(self.public_key)
                    f.write('\n')
                    f.write(self.private_key)
            except (IOError, IndexError):
                print('Saving wallet failed')

    def load_keys(self):
        try:
            with open('data/wallet.txt', mode='r') as f:
                keys = f.readlines()
                public_key = keys[0][:-1]
                private_key = keys[1]
                self.public_key = public_key
                self.private_key = private_key
        except (IOError, IndexError):
            print('Loading wallet failed')

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

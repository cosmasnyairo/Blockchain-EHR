import hashlib
import json


def hash_string_sha256(string):
    return hashlib.sha256(string).hexdigest()


def hash_block(block):
    # We hash blocks in our blockchain
    return hash_string_sha256(json.dumps(block, sort_keys=True).encode())

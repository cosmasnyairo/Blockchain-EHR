from collections import OrderedDict


class Transaction():
    def __init__(self, sender, recepient, signature, details,timestamp):
        self.sender = sender
        self.receiver = recepient
        self.details = details
        self.timestamp=timestamp
        self.signature = signature

    # create ordered dict to help in generating guess in valid proof
    def to_ordered_dict(self):
        return OrderedDict([
            ('sender', self.sender),
            ('receiver', self.receiver),
            ('details', self.details)
        ])

    def __repr__(self):
        return str(self.__dict__)


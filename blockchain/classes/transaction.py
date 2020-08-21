from collections import OrderedDict


class Transaction():
    def __init__(self, sender, recepient, details):
        self.sender = sender
        self.receiver = recepient
        self.details = details

    #create ordered dict to help in generating guess in valid proof
    def to_ordered_dict(self):
        return OrderedDict([
            ('sender', self.sender),
            ('receiver', self.receiver),
            ('details', self.details)
        ])

# import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import firestore

# cred = credentials.Certificate("serviceaccount.json")
# firebase_admin.initialize_app(cred)

# db = firestore.client()


# def savedata(usernode, blockchain, opentransactions, peer_nodes):
#     doc_ref = db.collection(u'blockchain').document(
#         u'blockchain-{}'.format(usernode))
#     doc_ref.set({
#         "blockchain": blockchain,
#         "opentransactions": opentransactions,
#         "peer_nodes": peer_nodes
#     })


# def loaddata(usernode):
#     docs = db.collection(u'blockchain').document(
#         u'blockchain-{}'.format(usernode)).get()
#     return docs.to_dict()


# def savekeys(usernode,public_key,private_key):
#     key_ref = db.collection(u'wallet').document(
#         u'wallet-{}'.format(usernode))
#     key_ref.set({
#         "public_key": public_key,
#         "private_key": private_key,
#     })

# def loadkeys(usernode):
#     docs = db.collection(u'wallet').document(
#         u'wallet-{}'.format(usernode)).get()
#     return docs.to_dict()
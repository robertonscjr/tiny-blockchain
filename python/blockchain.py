from time import time


class Blockchain:
    def __init__(self, genesis_block):
        self.blockchain = [genesis_block]
        self.previous_block = self.blockchain[0]
    
    def add_block(self, block):
        self.blockchain.append(block)
        self.previous_block = block

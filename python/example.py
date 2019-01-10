from blockchain import Blockchain
from block import Block
import block_generator as generator

# How many blocks will be added
NUMBER_OF_BLOCKS = 20

# The Genesis Block! Where it all begins
genesis_block = generator.genesis()

# Create the blockchain
blockchain = Blockchain(genesis_block)

# Add blocks to the blockchain
for i in range(0, NUMBER_OF_BLOCKS):
    block = generator.next(blockchain.previous_block)
    blockchain.add_block(block)

    print "Block #%s: %s" % (block.index, block.hash)

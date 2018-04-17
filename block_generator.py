from time import time
from block import Block

 
def next(block):
    this_index = block.index + 1
    this_timestamp = time() 
    this_data = "Block ID: " + str(this_index)
    this_hash = block.hash

    return Block(this_index, this_timestamp, this_data, this_hash)

def genesis():
    return Block(0, time, "Genesis Block", "0") 

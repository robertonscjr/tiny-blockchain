# A Tiny Blockchain

As the name of the repo says, a tiny blockchain. This project is aimed to be a help for those wanting to learn the basics of this technology.

Implementations of a simple blockchain in different languages. In these implementations, there will be an application of a blockchain in a real problem: the transfer of money between two people (a transaction happening in our blockchain). More sophisticated concepts such as consensus algorithm and interoperability between nodes can be implemented in future.

## Features

The system should be able to allow some basic operations that anyone can do in a blockchain which implements a coin (or token).

```
MyTinyBlockchain
1. Send money
2. Show balance
3. Mining a block
4. View pending transactions
5. Exit
```

### Description of features

1. Select who is the sender (Alice or Bob) and asks the value to be sent;
2. Displays balance of Alice and Bob;
3. Mine a block, inserting on the new block the pending transactions;
4. Displays pending transactions;
5. Goodbye.

### Important Concepts

* **Block:** Minimum element of a blockchain.
* **Genesis block:** first mined block.
* **Block Parameters:** Index, Timestamp, Data, Previous Hash and Block Hash
* **Transaction processing within a block:** Traversing the data of a block and calculating the balances of Alice and Bob based on the transactions recorded.
* **Mining a block:** Creating a new block with pending transactions added to the list of registered transactions.
* **Pending transactions:** Money submissions that have not yet been stored in a mining block must be stored in a queue that contains the transactions to be stored in the next mining of a block.

### ./utils

**Reference link:** https://medium.com/crypto-currently/lets-build-the-tiniest-blockchain-e70965a248b

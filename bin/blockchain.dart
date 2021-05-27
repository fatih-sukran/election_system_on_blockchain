import 'block.dart';
import 'transaction.dart';

class Blockchain {
  List<Block> chain = <Block>[];
  List<Transaction> pendingTransactions = <Transaction>[];
  int difficulty = 1;
  int reward = 10;

  Blockchain() {
    _addGenesisBlock();
  }

  Blockchain.fromJson(Map<String, dynamic> json)
      : chain = [for (var i in json['chain']) Block.fromJson(i)],
        pendingTransactions = [for (var i in json['pendingTransactions']) Transaction.fromJson(i)];

  void _addGenesisBlock() {
    createTransaction(Transaction('sistem', 'fatih', 100));
    var genesisBlock = Block(pendingTransactions);
    genesisBlock.index = 0;
    genesisBlock.previousHash = '';
    genesisBlock.timeStamp = DateTime.now();
    genesisBlock.mineBlock(difficulty);
    chain.add(genesisBlock);
    pendingTransactions = <Transaction>[];
  }

  Block getLatestBlock() {
    return chain.last;
  }

  bool addBlock(Block block) {
    var latestBlock = getLatestBlock();
    block.index = latestBlock.index + 1;
    block.previousHash = latestBlock.hash;
    block.timeStamp = DateTime.now();
    block.mineBlock(difficulty);
    chain.add(block);
    return true;
  }

  void createTransaction(Transaction transaction) {
    pendingTransactions.add(transaction);
  }

  void processPendingTransaction(String miner) {
    createTransaction(Transaction('sistem', miner, reward));
    var block = Block(pendingTransactions);
    addBlock(block);
    pendingTransactions = <Transaction>[];
  }

  bool isValid() {
    for (var i = 1; i < chain.length; i++) {
      var currentBlock = chain[i];
      var previousBlock = chain[i - 1];
      if (currentBlock.hash != currentBlock.calculateHash()) {
        return false;
      }
      if (currentBlock.previousHash != previousBlock.hash) {
        return false;
      }
    }
    return true;
  }

  String transactionsToJson() {
    var sb = StringBuffer();
    sb.write('{\n');
    for (var i = 0; i < chain.length; i++) {
      for (var j = 0; j < chain[i].transactions.length; j++) {
        var transaction = chain[i].transactions[j];
        sb.write('\tBlock $i : {\n');
        sb.write('\t\tfromAddress: ${transaction.fromAddress},\n');
        sb.write('\t\ttoAddress: ${transaction.toAddress},\n');
        sb.write('\t\tamount: ${transaction.amount},\n');
        sb.write('\t},\n');
      }
    }
    sb.write('}\n');
    return sb.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'difficulty': difficulty,
      'reward': reward,
      'pendingTransactions': [for (var i in pendingTransactions) i.toJson()],
      'chain': [for (var i in chain) i.toJson()],
    };
  }

  int getBalance(String address) {
    var balance = 0;
    for (var i = 0; i < chain.length; i++) {
      for (var j = 0; j < chain[i].transactions.length; j++) {
        var transaction = chain[i].transactions[j];
        if (transaction.fromAddress == address) {
          balance -= transaction.amount;
        }
        if (transaction.toAddress == address) {
          balance += transaction.amount;
        }
      }
    }
    return balance;
  }

  @override
  String toString() {
    var sb = StringBuffer();
    for (var block in chain) {
      sb.write('{\n');
      sb.write('\tindex: ${block.index},\n');
      sb.write('\ttimeStamp: ${block.timeStamp},\n');
      sb.write('\thash: ${block.hash},\n');
      sb.write('\tpreviousHash: ${block.previousHash} \n');
      sb.write('\tnonce: ${block.nonce},\n');
      sb.write('},\n');
    }
    return sb.toString();
  }
}

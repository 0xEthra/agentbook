const solc = require('solc');
const fs = require('fs');
const src = fs.readFileSync('contracts/AgentBook.sol','utf8');
const stdJsonInput = {language:'Solidity', sources:{'AgentBook.sol':{content:src}}, settings:{optimizer:{enabled:true,runs:200}, outputSelection:{'*':{'*':['abi','evm.bytecode','evm.deployedBytecode','metadata']}}}};
fs.writeFileSync('/tmp/sourcify2_payload.json', JSON.stringify({
  stdJsonInput,
  compilerVersion: solc.version(),
  contractIdentifier: 'AgentBook.sol:AgentBook'
}));
console.log('compiler', solc.version());

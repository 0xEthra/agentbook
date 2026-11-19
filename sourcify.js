const solc = require('solc');
const fs = require('fs');
const src = fs.readFileSync('contracts/AgentBook.sol','utf8');
const input = {language:'Solidity', sources:{'AgentBook.sol':{content:src}}, settings:{optimizer:{enabled:true,runs:200}, outputSelection:{'*':{'*':['metadata']}}}};
const out = JSON.parse(solc.compile(JSON.stringify(input)));
const meta = out.contracts['AgentBook.sol']['AgentBook'].metadata;
fs.writeFileSync('/tmp/sourcify_payload.json', JSON.stringify({
  address: '0x22a320365d260e87ec755D2043b72Bc9A9e6Fe8C',
  chain: '56',
  files: { 'metadata.json': meta, 'AgentBook.sol': src }
}));
console.log('payload ready, metadata bytes', meta.length);

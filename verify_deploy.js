const { ethers } = require('ethers');
const fs = require('fs');
const solc = require('solc');
const src = fs.readFileSync('contracts/AgentBook.sol','utf8');
const input = {language:'Solidity', sources:{'AgentBook.sol':{content:src}}, settings:{optimizer:{enabled:true,runs:200}, outputSelection:{'*':{'*':['evm.deployedBytecode.object']}}}};
const out = JSON.parse(solc.compile(JSON.stringify(input)));
const expectedRuntime = '0x' + out.contracts['AgentBook.sol']['AgentBook'].evm.deployedBytecode.object;
(async () => {
  const addr = '0x22a320365d260e87ec755D2043b72Bc9A9e6Fe8C';
  const txHash = '0x468a6d510e7fee1b20fd6972b7e09db2d57476aa258ae18a90115f0bcf414fea';
  for (const url of ['https://bsc-dataseed.binance.org','https://bsc-dataseed1.defibit.io']) {
    const p = new ethers.JsonRpcProvider(url, 56);
    const receipt = await p.getTransactionReceipt(txHash);
    const code = await p.getCode(addr);
    console.log(url);
    console.log(' receipt_status', receipt && receipt.status, 'gasUsed', receipt && receipt.gasUsed.toString(), 'to', receipt && receipt.to, 'contractAddress_field', receipt && receipt.contractAddress);
    console.log(' code_match_expected_runtime', code === expectedRuntime, 'code_bytes', (code.length-2)/2);
    const abi = JSON.parse(fs.readFileSync('build/AgentBook.json','utf8')).abi;
    const c = new ethers.Contract(addr, abi, p);
    console.log(' agentIdContract', await c.agentIdContract());
    console.log(' totalAgents', (await c.totalAgents()).toString(), 'totalCheckInsGlobal', (await c.totalCheckInsGlobal()).toString());
    console.log(' isAgent(user)', await c.isAgent('0x12bd869958A6EadB48F962e4c1245a9E79566D73'));
  }
})().catch(e => { console.error('ERR', e.message); process.exit(1); });

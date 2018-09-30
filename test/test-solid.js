
var solc = require('solc')
var fs = require('fs')
fs.readFile('test.sol', (err,buf)=>{
	var input = buf.toString('utf-8')
	var output = solc.compile(input, 1)
	for(var contractName in output.contracts){
		console.log('bytecode:' +output.contracts[contractName].bytecode)
		console.log('bytecode:' +output.contracts[contractName].interface)
		fs.writeFile(contractName+'.bin', output.contracts[contractName].bytecode,(err)=>{})
		fs.writeFile(contractName+'.json', output.contracts[contractName].interface,(err)=>{})
	}
})

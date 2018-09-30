'use strict';

var solc = require('solc');
var fs = require('fs');


function main(){
	var option = process.argv[2];
	if (option =='compile'){
		fs.readFile('ballet.sol', (err,buf)=>{
			var input = buf.toString('utf-8');
			var output = solc.compile(input, 1);
			for(var contractName in output.contracts){
				console.log('Compiled contract: ' + contractName);
				fs.writeFile('bin/'+contractName+'.bin', output.contracts[contractName].bytecode,(err)=>{});
				fs.writeFile('bin/'+contractName+'.json', output.contracts[contractName].interface,(err)=>{});
			}
		})
	}
	if (option == 'deploy'){
		console.log('Deploy now!');
	}
}

main();

async function runModule(moduleName) {
    const memory = new WebAssembly.Memory({initial: 1});
    const array = new Int32Array(memory.buffer);
    const imports = {
        js: {
            memory,
            println: (value) => {
                demoLog('> ' + value);
            },
        }
    };
    const module = await WebAssembly.instantiateStreaming(
        fetch(moduleName), imports);
    const instance = module.instance;

    async function runFile(file) {
        const response = await fetch(file);
        const input = await response.text();

        const numbers = input.trim().split('\n').map(line => {
            if (line !== '') {
                return parseInt(line);
            } else {
                return -1;
            }
        });

        array[0] = numbers.length;
        for (let i = 0; i < numbers.length; i++) {
            array[i+1] = numbers[i];
        }
        
        demoLog('Input:  ' + file);
        instance.exports.main();
    }
    
    demoLog('Module: ' + moduleName);
    await runFile('example.txt');
    await runFile('input.txt');
    demoLog(' ');
}

async function main() {
    await runModule('part1.wasm');
    await runModule('part2.wasm');
}

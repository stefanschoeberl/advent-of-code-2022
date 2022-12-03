async function runModule(moduleName) {
    const memory = new WebAssembly.Memory({initial: 1});
    const array = new Int16Array(memory.buffer);
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

        const lines = input.trim().split('\n')
            .filter(line => line !== '')
            .map(line => [line.charCodeAt(0), line.charCodeAt(2)]);

        array[0] = lines.length;
        for (let i = 0; i < lines.length; i++) {
            array[i*2+1] = lines[i][0];
            array[i*2+2] = lines[i][1];
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

async function runModule(moduleName) {
    const memory = new WebAssembly.Memory({initial: 1});
    const array8 = new Uint8Array(memory.buffer);
    const array16 = new Uint16Array(memory.buffer);
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

        const numbers = input.trim().split('\n')
            .filter(line => line !== '')
            .flatMap(line => line.split(','))
            .flatMap(sections => sections.split('-'))
            .map(number => parseInt(number))

        // memory layout
        // byte 0 - byte 1: number of pairs (16 bit)
        // byte 2 - ...: 4x 8-bit ints per pair
        array16[0] = numbers.length / 4;
        let pos = 2;
        numbers.forEach(number => {
            array8[pos++] = number;
        });
        
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

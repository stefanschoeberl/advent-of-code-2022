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

        const lines = input.trim().split('\n')
            .filter(line => line !== '');

        // memory layout
        // byte 0 - byte 1: length (16 bit)
        // byte 2 - byte 149: counters[] (8 bit / entry)
        // byte 150 - ...: characters (8 bit / char), 0-terminated
        array16[0] = lines.length;
        let pos = 150;
        lines.forEach(line => {
            for (let i = 0; i < line.length; i++) {
                array8[pos] = line.charCodeAt(i);
                pos++;
            }
            array8[pos] = 0;
            pos++;
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

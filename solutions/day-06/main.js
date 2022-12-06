async function runModule(moduleName) {
    const memory = new WebAssembly.Memory({initial: 1});
    const array8 = new Uint8Array(memory.buffer);
    const array16 = new Uint16Array(memory.buffer);

    let outputBuffer = '';

    const imports = {
        js: {
            memory,
            flush: () => {
                demoLog('> ' + outputBuffer);
                outputBuffer = ''
            },
            println: (value) => {
                demoLog('> ' + value);
            },
            printch: (value) => {
                if (value >= 33 && value <= 126) {
                    outputBuffer += String.fromCharCode(value);
                } else {
                    outputBuffer +='ch(' + value + ')';
                }
            },
        }
    };
    const module = await WebAssembly.instantiateStreaming(
        fetch(moduleName), imports);
    const instance = module.instance;

    async function runFile(file) {
        const response = await fetch(file);
        const input = await response.text();

        // memory layout
        // byte 0 - byte 1: length
        // byte 100 - ...: input
        array16[0] = input.length;
        for (let i = 0; i < input.length; i++) {
            array8[i + 100] = input.charCodeAt(i);
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

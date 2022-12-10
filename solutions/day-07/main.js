async function runModule(moduleName) {
    const memory = new WebAssembly.Memory({initial: 1});
    const array8 = new Uint8Array(memory.buffer);

    let outputBuffer = '';

    let lines = [];
    let currentLine = 0;

    function bufferChar(ch) {
        if (ch >= 32 && ch <= 126) {
            outputBuffer += String.fromCharCode(ch);
        } else {
            outputBuffer +='ch(' + ch + ')';
        }
    }

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
            prints: (stringAddress) => {
                while (array8[stringAddress] !== 0) {
                    bufferChar(array8[stringAddress]);
                    stringAddress++
                }
            },
            printi: (value) => {
                outputBuffer += value.toString();
            },
            printch: (value) => {
                bufferChar(value);
            },
            readLine: (stringAddress) => {
                const line = lines[currentLine];
                for (let i = 0; i < line.length; i++) {
                    array8[stringAddress + i] = line.charCodeAt(i);
                }
                array8[stringAddress + line.length] = 0;
                currentLine++;
            },
            isEof: () => {
                return currentLine >= lines.length ? 1 : 0;
            }
        }
    };
    const module = await WebAssembly.instantiateStreaming(
        fetch(moduleName), imports);
    const instance = module.instance;

    async function runFile(file) {
        const response = await fetch(file);
        const input = await response.text();

        lines = input.split('\n');
        currentLine = 0;

        demoLog('Input:  ' + file);
        instance.exports.main();
    }
    
    demoLog('Module: ' + moduleName);
    await runFile('example.txt');
    await runFile('input.txt');
    demoLog(' ');
}

async function main() {
    await runModule('main.wasm');
}

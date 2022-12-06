(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))
    (import "js" "printch" (func $printch (param i32)))
    (import "js" "flush" (func $flush))

    (global $inputSize (mut i32) (i32.const 0))
    (global $numTowers (mut i32) (i32.const 0))
    (global $emptyLine (mut i32) (i32.const 0))

    (func $lineLength (param $start i32) (result i32)
        (local $i i32)

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while start + i < inputSize && memory(offset=1002)[start + i] != LF
                local.get $start
                local.get $i
                i32.add
                global.get $inputSize
                i32.lt_u
                local.get $start
                local.get $i
                i32.add
                i32.load8_u offset=1002
                i32.const 10 ;; LF
                i32.ne
                i32.and
                i32.eqz
                br_if 1

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end
        
        local.get $i
    )

    (func $resetTowerStorage
        (local $i i32)

        i32.const 0
        local.set $i

        block
            loop
                ;; while i < 1000
                local.get $i
                i32.const 1000
                i32.lt_u
                i32.eqz
                br_if 1

                ;; memory[i] = 0
                local.get $i
                i32.const 0
                i32.store8

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end
    )

    (func $towerHeight (param $tower i32) (result i32)
        (local $height i32)

        ;; height = 0
        i32.const 0
        local.set $height

        block
            loop
                ;; while memory[tower * 100 + height] != 0
                local.get $tower
                i32.const 100
                i32.mul
                local.get $height
                i32.add
                i32.load8_u
                i32.const 0
                i32.ne
                i32.eqz
                br_if 1

                ;; height = height + 1
                local.get $height
                i32.const 1
                i32.add
                local.set $height
                br 0
            end
        end

        local.get $height
    )

    (func $printTowers
        (local $tower i32)
        (local $level i32)

        ;; tower = 0
        i32.const 0
        local.set $tower

        block
            loop
                ;; while tower < numTowers
                local.get $tower
                global.get $numTowers
                i32.lt_u
                i32.eqz
                br_if 1

                ;; level = 0
                i32.const 0
                local.set $level
                block
                    loop
                        ;; while memory[tower * 100 + level] != 0
                        local.get $tower
                        i32.const 100
                        i32.mul
                        local.get $level
                        i32.add
                        i32.load8_u
                        i32.const 0
                        i32.ne
                        i32.eqz
                        br_if 1

                        local.get $tower
                        i32.const 100
                        i32.mul
                        local.get $level
                        i32.add
                        i32.load8_u
                        call $printch

                        ;; level = level + 1
                        local.get $level
                        i32.const 1
                        i32.add
                        local.set $level
                        br 0
                    end
                end

                call $flush

                ;; tower = tower + 1
                local.get $tower
                i32.const 1
                i32.add
                local.set $tower
                br 0
            end
        end

        i32.const 45
        call $printch
        call $flush
    )

    (func $nextLine (param $currentPosition i32) (result i32)
        block
            loop
                ;; while currentPosition < inputSize && memory(offset=1002)[currentPosition] != LF
                local.get $currentPosition
                global.get $inputSize
                i32.lt_u
                local.get $currentPosition
                i32.load8_u offset=1002
                i32.const 10 ;; LF
                i32.ne
                i32.and
                i32.eqz
                br_if 1

                ;; currentPosition = currentPosition + 1
                local.get $currentPosition
                i32.const 1
                i32.add
                local.set $currentPosition
                br 0
            end
        end

        local.get $currentPosition
        global.get $inputSize
        i32.eq
        if (result i32)
            i32.const -1
        else
            local.get $currentPosition
            i32.const 1
            i32.add
        end
    )

    (func $loadInitialConfiguration
        (local $numLines i32)
        (local $currentLine i32)

        ;; numLines = -1
        i32.const -1
        local.set $numLines

        ;; emptyLine = 0
        i32.const 0
        global.set $emptyLine

        ;; numTowers = (lineLength(0) + 1) / 4
        i32.const 0
        call $lineLength
        i32.const 1
        i32.add
        i32.const 4
        i32.div_u
        global.set $numTowers

        block
            loop
                ;; while lineLength(emptyLine) > 0
                global.get $emptyLine
                call $lineLength
                i32.const 0
                i32.gt_s
                i32.eqz
                br_if 1

                local.get $numLines
                i32.const 1
                i32.add
                local.set $numLines
                
                global.get $emptyLine
                call $nextLine
                global.set $emptyLine

                br 0
            end
        end

        ;; local.get $numLines
        ;; call $println

        ;; global.get $numTowers
        ;; call $println

        ;; global.get $emptyLine
        ;; call $println

        call $resetTowerStorage
        
        ;; currentLine = emptyLine - 2 * numTowers * 4
        global.get $emptyLine
        i32.const 8
        global.get $numTowers
        i32.mul
        i32.sub
        local.set $currentLine
        block
            loop
                ;; while currentLine > 0
                local.get $currentLine
                i32.const 0
                i32.ge_s
                i32.eqz
                br_if 1

                local.get $currentLine
                call $fillTowersFromLine

                ;; currentLine = currentLine - numTowers * 4
                local.get $currentLine
                global.get $numTowers
                i32.const 4
                i32.mul
                i32.sub
                local.set $currentLine
                br 0
            end
        end
    )

    (func $fillTowersFromLine (param $start i32)
        (local $tower i32)
        (local $item i32)

        i32.const 0
        local.set $tower
        block
            loop
                ;; while tower < numTowers
                local.get $tower
                global.get $numTowers
                i32.lt_u
                i32.eqz
                br_if 1

                ;; item = memory(offset=1002)[start + tower * 4 + 1]
                local.get $start
                local.get $tower
                i32.const 4
                i32.mul
                i32.const 1
                i32.add
                i32.add
                i32.load8_u offset=1002
                local.set $item

                ;; if item > 65
                local.get $item
                i32.const 65 ;; 'A'
                i32.gt_u
                if
                    ;; memory[tower * 100 + towerHeigth(tower)] = item
                    local.get $tower
                    i32.const 100
                    i32.mul
                    local.get $tower
                    call $towerHeight
                    i32.add
                    local.get $item
                    i32.store8
                end

                ;; tower = tower + 1
                local.get $tower
                i32.const 1
                i32.add
                local.set $tower
                br 0
            end
        end
    )

    (func $moveSingle (param $from i32) (param $to i32)
        (local $item i32)

        ;; item = memory[from * 100 + towerHeight(from) - 1]
        local.get $from
        i32.const 100
        i32.mul
        local.get $from
        call $towerHeight
        i32.add
        i32.const 1
        i32.sub
        i32.load8_u
        local.set $item

        ;; memory[to * 100 + towerHeight(to)] = item
        local.get $to
        i32.const 100
        i32.mul
        local.get $to
        call $towerHeight
        i32.add
        local.get $item
        i32.store8

        ;; memory[from * 100 + towerHeight(from) - 1] = 0
        local.get $from
        i32.const 100
        i32.mul
        local.get $from
        call $towerHeight
        i32.add
        i32.const 1
        i32.sub
        i32.const 0
        i32.store8
    )

    (func $isDigit (param $addr i32) (result i32)
        ;; return memory(offset=1002)[addr] >= 48 && memory(offset=1002)[addr] <= 57
        local.get $addr
        i32.load8_u offset=1002
        i32.const 48
        i32.ge_u

        local.get $addr
        i32.load8_u offset=1002
        i32.const 57
        i32.le_u

        i32.and
    )

    (func $doMove (param $repetitions i32) (param $from i32) (param $to i32)
        (local $i i32)
        ;; from = from - 1
        local.get $from
        i32.const 1
        i32.sub
        local.set $from

        ;; to = to - 1
        local.get $to
        i32.const 1
        i32.sub
        local.set $to

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while i < repetitions
                local.get $i
                local.get $repetitions
                i32.lt_u
                i32.eqz
                br_if 1

                local.get $from
                local.get $to
                call $moveSingle

                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end
    )

    (func $doMoves (param $currentLine i32)
        (local $currentCharAddr i32)
        (local $repetitions i32)
        (local $from i32)
        (local $to i32)
        block
            loop
                ;; while currentLine != -1
                local.get $currentLine
                i32.const -1
                i32.ne
                i32.eqz
                br_if 1

                ;; currentCharAddr = currentLine + 5
                local.get $currentLine
                i32.const 5
                i32.add
                local.set $currentCharAddr

                ;; repetitions = 0
                i32.const 0
                local.set $repetitions

                block
                    loop
                        ;; while isDigit(currentCharAddr)
                        local.get $currentCharAddr
                        call $isDigit
                        i32.eqz
                        br_if 1

                        ;; repetitions = repetitions * 10 + memory(offset=1002)[currentCharAddr] - 48
                        local.get $repetitions
                        i32.const 10
                        i32.mul
                        local.get $currentCharAddr
                        i32.load8_u offset=1002
                        i32.add
                        i32.const 48
                        i32.sub
                        local.set $repetitions

                        ;; currentCharAddr = currentCharAddr + 1
                        local.get $currentCharAddr
                        i32.const 1
                        i32.add
                        local.set $currentCharAddr
                        br 0
                    end
                end

                ;; from = memory(offset=1002)[currentLine + lineLength(currentLine) - 6] - 48
                local.get $currentLine
                local.get $currentLine
                call $lineLength
                i32.add
                i32.const 6
                i32.sub
                i32.load8_u offset=1002
                i32.const 48
                i32.sub
                local.set $from

                ;; to = memory(offset=1002)[currentLine + lineLength(currentLine) - 1] - 48
                local.get $currentLine
                local.get $currentLine
                call $lineLength
                i32.add
                i32.const 1
                i32.sub
                i32.load8_u offset=1002
                i32.const 48
                i32.sub
                local.set $to

                local.get $repetitions
                local.get $from
                local.get $to
                call $doMove

                local.get $currentLine
                call $nextLine
                local.set $currentLine
                br 0
            end
        end
    )

    (func $printResult
        (local $tower i32)
        (local $item i32)

        i32.const 0
        local.set $tower
        block
            loop
                ;; while tower < numTowers
                local.get $tower
                global.get $numTowers
                i32.lt_u
                i32.eqz
                br_if 1

                ;; item = memory[tower * 100 + towerHeight(tower) - 1]
                local.get $tower
                i32.const 100
                i32.mul
                local.get $tower
                call $towerHeight
                i32.add
                i32.const 1
                i32.sub
                i32.load8_u
                local.set $item

                ;; if item != 0
                local.get $item
                i32.const 0
                i32.ne
                if
                    local.get $item
                    call $printch
                end
                

                local.get $tower
                i32.const 1
                i32.add
                local.set $tower
                br 0
            end
        end
        call $flush
    )

    (func $main
        ;; inputSize = memory(offset=1000)[0]
        i32.const 1000
        i32.load16_u
        global.set $inputSize

        call $loadInitialConfiguration

        ;; call $printTowers

        global.get $emptyLine
        call $nextLine
        call $doMoves

        call $printTowers

        call $printResult
    )

    (export "main" (func $main))
)
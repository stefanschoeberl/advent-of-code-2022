(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))

    (func $stringLength (param $start i32) (result i32)
        (local $i i32)

        ;; i = 0
        i32.const 0
        local.set $i

        ;; i = start
        block
            loop
                ;; while memory[start + i] != 0
                local.get $start
                local.get $i
                i32.add
                i32.load8_u
                i32.const 0
                i32.eq
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

    (func $fillCounter (param $start i32) (param $bit i32)
        (local $length i32)
        (local $i i32)
        (local $currentChar i32)

        ;; length = stringLength(start)
        local.get $start
        call $stringLength
        local.set $length

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while i < length
                local.get $i
                local.get $length
                i32.lt_u
                i32.eqz
                br_if 1

                ;; currentChar = memory[start + i]
                local.get $start
                local.get $i
                i32.add
                i32.load8_u
                local.set $currentChar

                ;; memory[2 + currentChar] = memory[2 + currentChar] | bit
                i32.const 2
                local.get $currentChar
                i32.add

                i32.const 2
                local.get $currentChar
                i32.add
                
                i32.load8_u
                local.get $bit
                i32.or
                
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

    (func $priorityForItem (param $item i32) (result i32)
        ;; if item > 'z' (90)
        local.get $item 
        i32.const 90
        i32.gt_u
        if (result i32)
            ;; item - 96
            local.get $item
            i32.const 96
            i32.sub
        else
            ;; item - 38
            local.get $item
            i32.const 38
            i32.sub
        end
    )

    (func $clearCounters
        (local $i i32)

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while i < 123
                local.get $i
                i32.const 123
                i32.lt_u
                i32.eqz
                br_if 1

                ;; memory[2 + i] = 0
                i32.const 2
                local.get $i
                i32.add
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

    (func $findCommonSymbol (result i32)
        (local $i i32)
        (local $commonSymbol i32)

        ;; commonSymbol = 0
        i32.const 0
        local.set $commonSymbol

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while commonSymbol == 0 && i < 123
                local.get $commonSymbol
                i32.eqz
                local.get $i
                i32.const 123
                i32.lt_u
                i32.and
                i32.eqz
                br_if 1

                ;; if memory[2 + i] == 7
                i32.const 2
                local.get $i
                i32.add
                i32.load8_u
                i32.const 7
                i32.eq
                if
                    ;; commonSymbol = i
                    local.get $i
                    local.set $commonSymbol
                end
                
                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        local.get $commonSymbol
    )

    (func $priorityForGroup (param $start i32) (result i32)
        call $clearCounters

        ;; fillCounter(start, 1)
        local.get $start
        i32.const 1
        call $fillCounter

        ;; start = start + stringLength(start) + 1
        local.get $start
        call $stringLength
        local.get $start
        i32.add
        i32.const 1
        i32.add
        local.set $start
        
        ;; fillCounter(start, 2)
        local.get $start
        i32.const 2
        call $fillCounter

        ;; start = start + stringLength(start) + 1
        local.get $start
        call $stringLength
        local.get $start
        i32.add
        i32.const 1
        i32.add
        local.set $start
        
        ;; fillCounter(start, 4)
        local.get $start
        i32.const 4
        call $fillCounter

        call $findCommonSymbol
        call $priorityForItem
    )

    (func $main
        (local $numGroups i32)
        (local $i i32)
        (local $currentLine i32)
        (local $prioritySum i32)

        ;; numLines = memory(offset=0)[0]
        i32.const 0
        i32.load16_u
        i32.const 3
        i32.div_u
        local.set $numGroups

        ;; i = 0
        i32.const 0
        local.set $i

        ;; currentLine = 150
        i32.const 150
        local.set $currentLine

        ;; prioritySum = 0
        i32.const 0
        local.set $prioritySum

        block
            loop
                ;; while i < numLines
                local.get $i
                local.get $numGroups
                i32.lt_u
                i32.eqz
                br_if 1

                ;; prioritySum = prioritySum + priorityForLine(currentLine)
                local.get $prioritySum
                local.get $currentLine
                call $priorityForGroup
                i32.add
                local.set $prioritySum

                ;; currentLine = currentLine + stringLength(currentLine) + 1
                local.get $currentLine
                call $stringLength
                local.get $currentLine
                i32.add
                i32.const 1
                i32.add
                local.set $currentLine

                ;; currentLine = currentLine + stringLength(currentLine) + 1
                local.get $currentLine
                call $stringLength
                local.get $currentLine
                i32.add
                i32.const 1
                i32.add
                local.set $currentLine

                ;; currentLine = currentLine + stringLength(currentLine) + 1
                local.get $currentLine
                call $stringLength
                local.get $currentLine
                i32.add
                i32.const 1
                i32.add
                local.set $currentLine

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        local.get $prioritySum
        call $println
    )

    (export "main" (func $main))
)
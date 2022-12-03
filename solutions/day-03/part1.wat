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

    (func $findDuplicate (param $start i32) (result i32)
        (local $length i32)
        (local $half i32)
        (local $i i32)
        (local $j i32)
        (local $duplicate i32)

        ;; length = stringLength(start)
        local.get $start
        call $stringLength
        local.set $length

        ;; half = length / 2
        local.get $length
        i32.const 2
        i32.div_u
        local.set $half

        ;; duplicate = 0
        i32.const 0
        local.set $duplicate

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while duplicate == 0 && i < half
                local.get $duplicate
                i32.const 0
                i32.eq
                local.get $i
                local.get $half
                i32.lt_u
                i32.and
                i32.eqz
                br_if 1

                ;; j = half
                local.get $half
                local.set $j
                block
                    loop
                        ;; while duplicate == 0 && j < length
                        local.get $duplicate
                        i32.const 0
                        i32.eq
                        local.get $j
                        local.get $length
                        i32.lt_u
                        i32.and
                        i32.eqz
                        br_if 1

                        ;; if (memory[start + i] == memory[start + j])
                        local.get $start
                        local.get $i
                        i32.add
                        i32.load8_u
                        local.get $start
                        local.get $j
                        i32.add
                        i32.load8_u
                        i32.eq
                        if
                            ;; duplicate = memory[start + i]
                            local.get $start
                            local.get $i
                            i32.add
                            i32.load8_u
                            local.set $duplicate
                        end

                        ;; j = j + 1
                        local.get $j
                        i32.const 1
                        i32.add
                        local.set $j
                        br 0
                    end
                end

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        local.get $duplicate
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

    (func $priorityForLine (param $start i32) (result i32)
        (local $duplicate i32)

        local.get $start
        call $findDuplicate
        call $priorityForItem
    )

    (func $main
        (local $numLines i32)
        (local $i i32)
        (local $currentLine i32)
        (local $prioritySum i32)

        ;; numLines = memory(offset=0)[0]
        i32.const 0
        i32.load16_u
        local.set $numLines

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
                local.get $numLines
                i32.lt_u
                i32.eqz
                br_if 1

                ;; prioritySum = prioritySum + priorityForLine(currentLine)
                local.get $prioritySum
                local.get $currentLine
                call $priorityForLine
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
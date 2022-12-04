(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))

    (func $overlaps (param $start i32) (result i32)
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)
        ;; a-b,c-d

        ;; a = memory[start]
        local.get $start
        i32.load8_u
        local.set $a
        ;; b = memory[start + 1]
        local.get $start
        i32.const 1
        i32.add
        i32.load8_u
        local.set $b
        ;; c = memory[start + 2]
        local.get $start
        i32.const 2
        i32.add
        i32.load8_u
        local.set $c
        ;; d = memory[start + 3]
        local.get $start
        i32.const 3
        i32.add
        i32.load8_u
        local.set $d

        ;;         a within other        b within other        c within other        d within other
        ;; return (a >= c && a <= d) || (b >= c && b <= d) || (c >= a && c <= b) || (d >= a && d <= b)
        local.get $a
        local.get $c
        i32.ge_u
        local.get $a
        local.get $d
        i32.le_u
        i32.and

        local.get $b
        local.get $c
        i32.ge_u
        local.get $b
        local.get $d
        i32.le_u
        i32.and

        local.get $c
        local.get $a
        i32.ge_u
        local.get $c
        local.get $b
        i32.le_u
        i32.and

        local.get $d
        local.get $a
        i32.ge_u
        local.get $d
        local.get $b
        i32.le_u
        i32.and

        i32.or
        i32.or
        i32.or
    )

    (func $main
        (local $numLines i32)
        (local $i i32)
        (local $overlappingPairs i32)

        ;; numLines = memory(offset=0)[0]
        i32.const 0
        i32.load16_u
        local.set $numLines

        ;; i = 0
        i32.const 0
        local.set $i

        ;; overlappingPairs = 0
        i32.const 0
        local.set $overlappingPairs

        block
            loop
                ;; while i < numLines
                local.get $i
                local.get $numLines
                i32.lt_u
                i32.eqz
                br_if 1

                ;; if overlaps(2 + 4 * i)
                i32.const 2
                local.get $i
                i32.const 4
                i32.mul
                i32.add
                call $overlaps
                if
                    ;; overlappingPairs = overlappingPairs + 1
                    local.get $overlappingPairs
                    i32.const 1
                    i32.add
                    local.set $overlappingPairs
                end

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        local.get $overlappingPairs
        call $println
    )

    (export "main" (func $main))
)
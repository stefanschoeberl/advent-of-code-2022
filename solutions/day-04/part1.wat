(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))

    (func $fullyContains (param $start i32) (result i32)
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

        ;; return (a <= c && b >= d) || (a >= c && b <= d)
        local.get $a
        local.get $c
        i32.le_u
        local.get $b
        local.get $d
        i32.ge_u
        i32.and

        local.get $a
        local.get $c
        i32.ge_u
        local.get $b
        local.get $d
        i32.le_u
        i32.and

        i32.or
    )

    (func $main
        (local $numLines i32)
        (local $i i32)
        (local $fullyContainedPairs i32)

        ;; numLines = memory(offset=0)[0]
        i32.const 0
        i32.load16_u
        local.set $numLines

        ;; i = 0
        i32.const 0
        local.set $i

        ;; fullyContainedPairs = 0
        i32.const 0
        local.set $fullyContainedPairs

        block
            loop
                ;; while i < numLines
                local.get $i
                local.get $numLines
                i32.lt_u
                i32.eqz
                br_if 1

                ;; if fullyContains(2 + 4 * i)
                i32.const 2
                local.get $i
                i32.const 4
                i32.mul
                i32.add
                call $fullyContains
                if
                    ;; fullyContainedPairs = fullyContainedPairs + 1
                    local.get $fullyContainedPairs
                    i32.const 1
                    i32.add
                    local.set $fullyContainedPairs
                end

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        local.get $fullyContainedPairs
        call $println
    )

    (export "main" (func $main))
)
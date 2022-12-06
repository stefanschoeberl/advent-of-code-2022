(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))
    (import "js" "printch" (func $printch (param i32)))
    (import "js" "flush" (func $flush))

    (func $isSOP (param $pos i32) (result i32)
        (local $a i32)
        (local $b i32)
        (local $c i32)
        (local $d i32)

        ;; a = memory(offset=100)[i - 3]
        local.get $pos
        i32.const 3
        i32.sub
        i32.load8_u offset=100
        local.set $a

        ;; b = memory(offset=100)[i - 2]
        local.get $pos
        i32.const 2
        i32.sub
        i32.load8_u offset=100
        local.set $b

        ;; c = memory(offset=100)[i - 1]
        local.get $pos
        i32.const 1
        i32.sub
        i32.load8_u offset=100
        local.set $c

        ;; d = memory(offset=100)[i]
        local.get $pos
        i32.load8_u offset=100
        local.set $d

        ;; return a != b && a != c && a != d && b != c && b != d && c != d
        local.get $a
        local.get $b
        i32.ne
        local.get $a
        local.get $c
        i32.ne
        local.get $a
        local.get $d
        i32.ne
        local.get $b
        local.get $c
        i32.ne
        local.get $b
        local.get $d
        i32.ne
        local.get $c
        local.get $d
        i32.ne
        i32.and
        i32.and
        i32.and
        i32.and
        i32.and
    )

    (func $main
        (local $inputSize i32)
        (local $i i32)
        ;; inputSize = memory[0]
        i32.const 0
        i32.load16_u
        local.set $inputSize

        ;; i = 3
        i32.const 3
        local.set $i

        block
            loop
                ;; while i < inputSize && !isSOP(i)
                local.get $i
                local.get $inputSize
                i32.lt_u
                local.get $i
                call $isSOP
                i32.eqz
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
        i32.const 1
        i32.add
        call $println
    )

    (export "main" (func $main))
)
(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))
    (import "js" "printch" (func $printch (param i32)))
    (import "js" "flush" (func $flush))

    (func $isSOM (param $pos i32) (result i32)
        (local $i i32)
        (local $sum i32)

        ;; clear array

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < 26
                local.get $i
                i32.const 26
                i32.lt_u
                i32.eqz
                br_if 1

                ;; memory(offset=2)[i] = 0
                local.get $i
                i32.const 0
                i32.store8 offset=2

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        ;; read characters

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while i < 14
                local.get $i
                i32.const 14
                i32.lt_u
                i32.eqz
                br_if 1

                ;; memory(offset=2)[memory(offset=100)[pos - i] - 97] = 1
                local.get $pos
                local.get $i
                i32.sub
                i32.load8_u offset=100
                i32.const 97
                i32.sub
                i32.const 1
                i32.store8 offset=2

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        ;; check sum

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while i < 26
                local.get $i
                i32.const 26
                i32.lt_u
                i32.eqz
                br_if 1

                ;; sum = sum + memory(offset=2)[i]
                local.get $sum
                local.get $i
                i32.load8_u offset=2
                i32.add
                local.set $sum

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        local.get $sum
        i32.const 14
        i32.eq
    )

    (func $main
        (local $inputSize i32)
        (local $i i32)
        ;; inputSize = memory[0]
        i32.const 0
        i32.load16_u
        local.set $inputSize

        ;; i = 13
        i32.const 13
        local.set $i

        block
            loop
                ;; while i < inputSize && !isSOM(i)
                local.get $i
                local.get $inputSize
                i32.lt_u
                local.get $i
                call $isSOM
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
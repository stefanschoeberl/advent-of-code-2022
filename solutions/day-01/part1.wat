(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))

    (func $main
        (local $numLines i32)
        (local $i i32)
        (local $maxSum i32)
        (local $currentSum i32)
        (local $currentNumber i32)

        ;; numLines = memory[0]
        i32.const 0
        i32.load
        local.set $numLines

        ;; maxSum = 0
        i32.const 0
        local.set $maxSum

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < numLines
                local.get $i
                local.get $numLines
                i32.lt_s
                i32.eqz
                br_if 1

                ;; currentSum = 0
                i32.const 0
                local.set $currentSum

                block
                    loop
                        ;; currentNumber = mem(offset=2)[i * size]
                        local.get $i
                        i32.const 4
                        i32.mul
                        i32.load offset=4
                        local.set $currentNumber

                        ;; while i < numLines && currentNumber != -1
                        local.get $i
                        local.get $numLines
                        i32.lt_s
                        local.get $currentNumber
                        i32.const -1
                        i32.ne
                        i32.and
                        i32.eqz
                        br_if 1

                        ;; currentSum = currentSum + currentNumber
                        local.get $currentSum
                        local.get $currentNumber
                        i32.add
                        local.set $currentSum

                        ;; i = i + 1
                        local.get $i
                        i32.const 1
                        i32.add
                        local.set $i
                        br 0
                    end
                end

                ;; if currentSum > maxSum
                local.get $currentSum
                local.get $maxSum
                i32.gt_s
                if
                    ;; maxSum = currentSum
                    local.get $currentSum
                    local.set $maxSum
                end

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        ;; print maxSum
        local.get $maxSum
        call $println
    )

    (export "main" (func $main))
)
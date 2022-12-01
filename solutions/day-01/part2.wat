(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))

    (func $main
        (local $numLines i32)
        (local $i i32)
        (local $maxSum1 i32)
        (local $maxSum2 i32)
        (local $maxSum3 i32)
        (local $currentSum i32)
        (local $currentNumber i32)

        ;; numLines = memory[0]
        i32.const 0
        i32.load
        local.set $numLines

        ;; maxSum1, maxSum2, maxSum3 = 0
        i32.const 0
        local.set $maxSum1
        i32.const 0
        local.set $maxSum2
        i32.const 0
        local.set $maxSum3

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
                        ;; currentNumber = mem(offset=4)[i * size]
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

                ;; if currentSum >= maxSum1
                local.get $currentSum
                local.get $maxSum1
                i32.ge_s
                if
                    ;; maxSum3 = maxSum2
                    local.get $maxSum2
                    local.set $maxSum3

                    ;; maxSum2 = maxSum1
                    local.get $maxSum1
                    local.set $maxSum2

                    ;; maxSum1 = currentSum
                    local.get $currentSum
                    local.set $maxSum1
                else
                    ;; if currentSum >= maxSum2
                    local.get $currentSum
                    local.get $maxSum2
                    i32.ge_s
                    if
                        ;; maxSum3 = maxSum2
                        local.get $maxSum2
                        local.set $maxSum3

                        ;; maxSum2 = currentSum
                        local.get $currentSum
                        local.set $maxSum2
                    else
                        ;; if currentSum >= maxSum3
                        local.get $currentSum
                        local.get $maxSum3
                        i32.ge_s
                        if
                            ;; maxSum3 = currentSum
                            local.get $currentSum
                            local.set $maxSum3
                        end
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

        ;; print maxSum
        local.get $maxSum1
        local.get $maxSum2
        local.get $maxSum3
        i32.add
        i32.add
        call $println
    )

    (export "main" (func $main))
)
(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))

    (func $scoreForRound (param $opponentShape i32) (param $expectedResult i32) (result i32)
        (local $points i32)
        (local $shapeOffset i32)
        block
            block
                block
                    block
                        ;; switch (expectedResult - 88)
                        ;; 0 => lose
                        ;; 1 => draw
                        ;; 2 => win
                        local.get $expectedResult
                        i32.const 88
                        i32.sub
                        br_table 0 1 2
                    end
                    ;; case 0:
                    i32.const 0
                    local.set $points
                    i32.const -1
                    local.set $shapeOffset
                    br 2
                end
                ;; case 1:
                i32.const 3
                local.set $points
                i32.const 0
                local.set $shapeOffset
                br 1
            end
            ;; case 2:
            i32.const 6
            local.set $points
            i32.const 1
            local.set $shapeOffset
        end
        ;; points + ((opponentShape - 65) + shapeOffset + 3) % 3 + 1
        local.get $points
        local.get $opponentShape
        i32.const 65
        i32.sub
        local.get $shapeOffset
        i32.add
        i32.const 3
        i32.add
        i32.const 3
        i32.rem_s
        i32.const 1
        i32.add
        i32.add
    )

    (func $main
        (local $numLines i32)
        (local $i i32)
        (local $totalScore i32)

        ;; numLines = memory(offset=0)[0]
        i32.const 0
        i32.load16_s
        local.set $numLines

        ;; i = 0
        i32.const 0
        local.set $i

        ;; totalScore = 0
        i32.const 0
        local.set $totalScore

        block
            loop
                ;; while i < numLines
                local.get $i
                local.get $numLines
                i32.lt_s
                i32.eqz
                br_if 1

                ;; scoreForRound(memory(offset=2)[i * 4], memory(offset=2)[i * 4 + 2])
                local.get $i
                i32.const 4
                i32.mul
                i32.load16_s offset=2
                local.get $i
                i32.const 4
                i32.mul
                i32.const 2
                i32.add
                i32.load16_s offset=2
                call $scoreForRound

                ;; totalScore = totalScore + scoreForRound(...)
                local.get $totalScore
                i32.add
                local.set $totalScore

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        local.get $totalScore
        call $println
    )

    (export "main" (func $main))
)
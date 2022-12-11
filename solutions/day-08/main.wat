(module
    (import "js" "memory" (memory 1))
    (import "js" "println" (func $println (param i32)))
    (import "js" "prints" (func $prints (param i32)))
    (import "js" "printi" (func $printi (param i32)))
    (import "js" "printch" (func $printch (param i32)))
    (import "js" "readLine" (func $readLine (param i32)))
    (import "js" "isEof" (func $isEof (result i32)))
    (import "js" "flush" (func $flush))

    (func $parseInt (param $str i32) (param $offset i32) (result i32)
        (local $result i32)
        (local $ch i32)
        ;; result = 0
        i32.const 0
        local.set $result
        
        block
            loop
                ;; ch = str[offset]
                local.get $str
                local.get $offset
                call $stringGet
                local.set $ch

                ;; while ch >= 48 && ch <= 57
                local.get $ch
                i32.const 48
                i32.ge_u
                local.get $ch
                i32.const 57
                i32.le_u
                i32.and
                i32.eqz
                br_if 1

                ;; result = result * 10 + ch - 48
                local.get $result
                i32.const 10
                i32.mul
                local.get $ch
                i32.add
                i32.const 48
                i32.sub
                local.set $result

                ;; offset = offset + 1
                local.get $offset
                i32.const 1
                i32.add
                local.set $offset
                br 0
            end
        end

        ;; return result
        local.get $result
    )

    (global $memoryPos (mut i32) (i32.const 1000))

    (global $maxLine i32 (i32.const 100))

    (func $malloc (param $size i32) (result i32)
        (local $result i32)
        ;; result = memoryPos
        global.get $memoryPos
        local.set $result

        ;; memoryPos = memoryPos + size
        global.get $memoryPos
        local.get $size
        i32.add
        global.set $memoryPos

        ;; return result
        local.get $result
    )

    (func $stringGet (param $array i32) (param $i i32) (result i32)
        local.get $array
        local.get $i
        i32.add
        i32.load8_u
    )

    (func $stringSet (param $array i32) (param $i i32) (param $value i32)
        local.get $array
        local.get $i
        i32.add
        local.get $value
        i32.store8
    )

    (func $strlen (param $str i32) (result i32)
        (local $length i32)

        ;; length = 0
        i32.const 0
        local.set $length

        block
            loop
                ;; while str[length] != 0
                local.get $str
                local.get $length
                call $stringGet
                i32.const 0
                i32.ne
                i32.eqz
                br_if 1

                ;; length = length + 1
                local.get $length
                i32.const 1
                i32.add
                local.set $length
                br 0
            end
        end

        ;; return length
        local.get $length
    )

    (func $strIndexOf (param $str i32) (param $ch i32) (result i32)
        (local $i i32)

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while str[i] != 0 && str[i] != ch
                local.get $str
                local.get $i
                call $stringGet
                i32.const 0
                i32.ne
                local.get $str
                local.get $i
                call $stringGet
                local.get $ch
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

        ;; if str[i] != 0
        local.get $str
        local.get $i
        call $stringGet
        i32.const 0
        i32.ne
        if (result i32)
            ;; return i
            local.get $i
        else
            ;; return -1
            i32.const -1
        end
    )

    (func $strcpy (param $from i32) (param $to i32)
        (local $i i32)

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while from[i] != 0
                local.get $from
                local.get $i
                call $stringGet
                i32.const 0
                i32.ne
                i32.eqz
                br_if 1

                ;; to[i] = from[i]
                local.get $to
                local.get $i

                local.get $from
                local.get $i
                call $stringGet

                call $stringSet
                
                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end
    )

    (func $stringEquals (param $a i32) (param $b i32) (result i32)
        (local $i i32)

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while a[i] != 0 && b[i] != 0 && a[i] == b[i]
                local.get $a
                local.get $i
                call $stringGet
                i32.const 0
                i32.ne
                local.get $a
                local.get $i
                call $stringGet
                i32.const 0
                i32.ne
                i32.and
                local.get $a
                local.get $i
                call $stringGet
                local.get $b
                local.get $i
                call $stringGet
                i32.eq
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

        ;; return a[i] == b[i]
        local.get $a
        local.get $i
        call $stringGet
        local.get $b
        local.get $i
        call $stringGet
        i32.eq
    )

    (func $substring (param $from i32) (param $start i32) (param $length i32) (param $to i32)
        (local $i i32)

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

                ;; to[i] = from[start + i]
                local.get $to
                local.get $i

                local.get $from
                local.get $start
                local.get $i
                i32.add
                call $stringGet

                call $stringSet
                
                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        ;; to[length] = 0
        local.get $to
        local.get $length
        i32.const 0
        call $stringSet
    )

    (func $isTreeVisible (param $grid i32) (param $gridSize i32) (param $row i32) (param $col i32) (result i32)
        (local $i i32)
        (local $ownSize i32)
        (local $visibleRight i32)
        (local $visibleLeft i32)
        (local $visibleTop i32)
        (local $visibleBottom i32)

        ;; ownSize = grid[row * gridSize + col]
        local.get $grid
        local.get $row
        local.get $gridSize
        i32.mul
        local.get $col
        i32.add
        i32.add
        i32.load8_u
        local.set $ownSize

        ;; visibleRight = true
        i32.const 1
        local.set $visibleRight
        ;; visibleLeft = true
        i32.const 1
        local.set $visibleLeft
        ;; visibleTop = true
        i32.const 1
        local.set $visibleTop
        ;; visibleBottom = true
        i32.const 1
        local.set $visibleBottom

        ;; i = col + 1
        local.get $col
        i32.const 1
        i32.add
        local.set $i

        block
            loop
                ;; while i < gridSize
                local.get $i
                local.get $gridSize
                i32.lt_s
                i32.eqz
                br_if 1

                ;; if grid[row * gridSize + i] >= ownSize
                local.get $grid
                local.get $row
                local.get $gridSize
                i32.mul
                local.get $i
                i32.add
                i32.add
                i32.load8_u
                local.get $ownSize
                i32.ge_u
                if
                    ;; visibleRight = false
                    i32.const 0
                    local.set $visibleRight
                end

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        ;; i = row + 1
        local.get $row
        i32.const 1
        i32.add
        local.set $i

        block
            loop
                ;; while i < gridSize
                local.get $i
                local.get $gridSize
                i32.lt_s
                i32.eqz
                br_if 1

                ;; if grid[i * gridSize + col] >= ownSize
                local.get $grid
                local.get $i
                local.get $gridSize
                i32.mul
                local.get $col
                i32.add
                i32.add
                i32.load8_u
                local.get $ownSize
                i32.ge_u
                if
                    ;; visibleBottom = false
                    i32.const 0
                    local.set $visibleBottom
                end

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        ;; ;; i = col - 1
        local.get $col
        i32.const 1
        i32.sub
        local.set $i

        block
            loop
                ;; while i >= 0
                local.get $i
                i32.const 0
                i32.ge_s
                i32.eqz
                br_if 1

                ;; if grid[row * gridSize + i] >= ownSize
                local.get $grid
                local.get $row
                local.get $gridSize
                i32.mul
                local.get $i
                i32.add
                i32.add
                i32.load8_u
                local.get $ownSize
                i32.ge_u
                if
                    ;; visibleLeft = false
                    i32.const 0
                    local.set $visibleLeft
                end

                ;; i = i - 1
                local.get $i
                i32.const 1
                i32.sub
                local.set $i
                br 0
            end
        end

        ;; ;; i = row - 1
        local.get $row
        i32.const 1
        i32.sub
        local.set $i

        block
            loop
                ;; while i >= 0
                local.get $i
                i32.const 0
                i32.ge_s
                i32.eqz
                br_if 1

                ;; if grid[i * gridSize + col] >= ownSize
                local.get $grid
                local.get $i
                local.get $gridSize
                i32.mul
                local.get $col
                i32.add
                i32.add
                i32.load8_u
                local.get $ownSize
                i32.ge_u
                if
                    ;; visibleTop = false
                    i32.const 0
                    local.set $visibleTop
                end

                ;; i = i - 1
                local.get $i
                i32.const 1
                i32.sub
                local.set $i
                br 0
            end
        end

        ;; return visibleLeft || visibleRight || visibleTop || visibleBottom
        local.get $visibleLeft
        local.get $visibleRight
        local.get $visibleTop
        local.get $visibleBottom
        i32.or
        i32.or
        i32.or
    )

    (func $countVisibleTrees (param $grid i32) (param $gridSize i32) (result i32)
        (local $visibleTrees i32)
        (local $row i32)
        (local $col i32)

        ;; visibleTrees = 0
        i32.const 0
        local.set $visibleTrees

        ;; row = 0
        i32.const 0
        local.set $row
        block
            loop
                ;; while row < gridSize
                local.get $row
                local.get $gridSize
                i32.lt_u
                i32.eqz
                br_if 1

                ;; col = 0
                i32.const 0
                local.set $col
                
                block
                    loop
                        ;; while col < gridSize
                        local.get $col
                        local.get $gridSize
                        i32.lt_u
                        i32.eqz
                        br_if 1

                        ;; if isTreeVisible(grid, gridSize, row, col)
                        local.get $grid
                        local.get $gridSize
                        local.get $row
                        local.get $col
                        call $isTreeVisible
                        if
                            ;; visibleTrees = visibleTrees + 1
                            local.get $visibleTrees
                            i32.const 1
                            i32.add
                            local.set $visibleTrees
                        end

                        ;; col = col + 1
                        local.get $col
                        i32.const 1
                        i32.add
                        local.set $col
                        br 0
                    end
                end

                ;; row = row + 1
                local.get $row
                i32.const 1
                i32.add
                local.set $row
                br 0
            end
        end

        local.get $visibleTrees
    )

    (func $scenicScore (param $grid i32) (param $gridSize i32) (param $row i32) (param $col i32) (result i32)
        (local $i i32)
        (local $ownSize i32)
        (local $viewingDistanceLeft i32)
        (local $viewingDistanceRight i32)
        (local $viewingDistanceTop i32)
        (local $viewingDistanceBottom i32)

        ;; ownSize = grid[row * gridSize + col]
        local.get $grid
        local.get $row
        local.get $gridSize
        i32.mul
        local.get $col
        i32.add
        i32.add
        i32.load8_u
        local.set $ownSize

        ;; i = col
        local.get $col
        local.set $i

        block
            loop
                ;; do
                
                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i

                ;; while i < gridSize - 1 && grid[row * gridSize + i] < ownSize
                local.get $i
                local.get $gridSize
                i32.const 1
                i32.sub
                i32.lt_s

                local.get $grid
                local.get $row
                local.get $gridSize
                i32.mul
                local.get $i
                i32.add
                i32.add
                i32.load8_u
                local.get $ownSize
                i32.lt_u

                i32.and
                i32.eqz
                br_if 1

                br 0
            end
        end

        ;; viewingDistanceRight = i - col
        local.get $i
        local.get $col
        i32.sub
        local.set $viewingDistanceRight

        ;; i = col
        local.get $col
        local.set $i

        block
            loop
                ;; do
                
                ;; i = i - 1
                local.get $i
                i32.const 1
                i32.sub
                local.set $i

                ;; while i > 0 && grid[row * gridSize + i] < ownSize
                local.get $i
                i32.const 0
                i32.gt_s

                local.get $grid
                local.get $row
                local.get $gridSize
                i32.mul
                local.get $i
                i32.add
                i32.add
                i32.load8_u
                local.get $ownSize
                i32.lt_u

                i32.and
                i32.eqz
                br_if 1

                br 0
            end
        end

        ;; viewingDistanceLeft = col - i
        local.get $col
        local.get $i
        i32.sub
        local.set $viewingDistanceLeft

        ;; i = row
        local.get $row
        local.set $i

        block
            loop
                ;; do
                
                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i

                ;; while i < gridSize - 1 && grid[i * gridSize + col] < ownSize
                local.get $i
                local.get $gridSize
                i32.const 1
                i32.sub
                i32.lt_s

                local.get $grid
                local.get $i
                local.get $gridSize
                i32.mul
                local.get $col
                i32.add
                i32.add
                i32.load8_u
                local.get $ownSize
                i32.lt_u

                i32.and
                i32.eqz
                br_if 1

                br 0
            end
        end

        ;; viewingDistanceBottom = i - row
        local.get $i
        local.get $row
        i32.sub
        local.set $viewingDistanceBottom

        ;; i = col
        local.get $row
        local.set $i

        block
            loop
                ;; do
                
                ;; i = i - 1
                local.get $i
                i32.const 1
                i32.sub
                local.set $i

                ;; while i > 0 && grid[i * gridSize + col] < ownSize
                local.get $i
                i32.const 0
                i32.gt_s

                local.get $grid
                local.get $i
                local.get $gridSize
                i32.mul
                local.get $col
                i32.add
                i32.add
                i32.load8_u
                local.get $ownSize
                i32.lt_u

                i32.and
                i32.eqz
                br_if 1

                br 0
            end
        end

        ;; viewingDistanceTop = row - i
        local.get $row
        local.get $i
        i32.sub
        local.set $viewingDistanceTop

        ;; return viewingDistanceRight * viewingDistanceLeft * viewingDistanceTop * viewingDistanceBottom
        local.get $viewingDistanceRight
        local.get $viewingDistanceLeft
        local.get $viewingDistanceTop
        local.get $viewingDistanceBottom
        i32.mul
        i32.mul
        i32.mul
    )

    (func $findBestScenicScore (param $grid i32) (param $gridSize i32) (result i32)
        (local $bestScore i32)
        (local $row i32)
        (local $col i32)
        (local $score i32)

        ;; bestScore = 0
        i32.const 0
        local.set $bestScore

        ;; row = 1
        i32.const 1
        local.set $row
        block
            loop
                ;; while row < gridSize - 1
                local.get $row
                local.get $gridSize
                i32.const 1
                i32.sub
                i32.lt_u
                i32.eqz
                br_if 1

                ;; col = 1
                i32.const 1
                local.set $col
                
                block
                    loop
                        ;; while col < gridSize - 1
                        local.get $col
                        local.get $gridSize
                        i32.const 1
                        i32.sub
                        i32.lt_u
                        i32.eqz
                        br_if 1

                        ;; score = sceneicScore(grid, gridSize, row, col)
                        local.get $grid
                        local.get $gridSize
                        local.get $row
                        local.get $col
                        call $scenicScore
                        local.set $score

                        ;; if score > bestScore
                        local.get $score
                        local.get $bestScore
                        i32.gt_u
                        if
                            ;; bestScore = score
                            local.get $score
                            local.set $bestScore
                        end

                        ;; col = col + 1
                        local.get $col
                        i32.const 1
                        i32.add
                        local.set $col
                        br 0
                    end
                end

                ;; row = row + 1
                local.get $row
                i32.const 1
                i32.add
                local.set $row
                br 0
            end
        end

        local.get $bestScore
    )

    (global $currentLine (mut i32) (i32.const 0))
    (func $main
        (local $gridSize i32)
        (local $grid i32)
        (local $row i32)
        (local $col i32)

        ;; line = malloc(maxLine);
        global.get $maxLine
        call $malloc
        global.set $currentLine

        ;; grid = malloc(100*100);
        i32.const 10000
        call $malloc
        local.set $grid

        ;; row = 0
        i32.const 0
        local.set $row

        block
            loop
                ;; while !isEof()
                call $isEof
                br_if 1

                ;; readLine(line)
                global.get $currentLine
                call $readLine

                ;; gridSize = strlen(currentLine)
                global.get $currentLine
                call $strlen
                local.set $gridSize

                ;; col = 0
                i32.const 0
                local.set $col

                block
                    loop
                        ;; while col < gridSize
                        local.get $col
                        local.get $gridSize
                        i32.lt_u
                        i32.eqz
                        br_if 1

                        ;; grid[row * gridSize + col] = currentLine[col] - 48
                        local.get $grid
                        local.get $row
                        local.get $gridSize
                        i32.mul
                        local.get $col
                        i32.add
                        i32.add

                        global.get $currentLine
                        local.get $col
                        call $stringGet
                        i32.const 48
                        i32.sub

                        i32.store8

                        ;; col = col + 1
                        local.get $col
                        i32.const 1
                        i32.add
                        local.set $col
                        br 0
                    end
                end

                ;; row = row + 1
                local.get $row
                i32.const 1
                i32.add
                local.set $row
                br 0
            end
        end

        ;; part 1
        local.get $grid
        local.get $gridSize
        call $countVisibleTrees
        call $println

        ;; part 2
        local.get $grid
        local.get $gridSize
        call $findBestScenicScore
        call $println

    )

    (export "main" (func $main))
)
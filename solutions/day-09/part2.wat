(module
    (import "js" "memory" (memory 1000))
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
                call $array8Get
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

    (global $memoryPos (mut i32) (i32.const 1))

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

    (func $array8Get (param $array i32) (param $i i32) (result i32)
        local.get $array
        local.get $i
        i32.add
        i32.load8_u
    )

    (func $array8Set (param $array i32) (param $i i32) (param $value i32)
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
                call $array8Get
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
                call $array8Get
                i32.const 0
                i32.ne
                local.get $str
                local.get $i
                call $array8Get
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
        call $array8Get
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
                call $array8Get
                i32.const 0
                i32.ne
                i32.eqz
                br_if 1

                ;; to[i] = from[i]
                local.get $to
                local.get $i

                local.get $from
                local.get $i
                call $array8Get

                call $array8Set
                
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
                call $array8Get
                i32.const 0
                i32.ne
                local.get $a
                local.get $i
                call $array8Get
                i32.const 0
                i32.ne
                i32.and
                local.get $a
                local.get $i
                call $array8Get
                local.get $b
                local.get $i
                call $array8Get
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
        call $array8Get
        local.get $b
        local.get $i
        call $array8Get
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
                call $array8Get

                call $array8Set
                
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
        call $array8Set
    )

    (global $rope (mut i32) (i32.const 0))
    (global $ropeLength i32 (i32.const 10))

    (global $grid (mut i32) (i32.const 0))
    (global $gridSize i32 (i32.const 1000))
    (global $centerXY i32 (i32.const 500))

    (func $printState
        (local $x i32)
        (local $y i32)
        (local $i i32)

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while i < ropeLength
                local.get $i
                global.get $ropeLength
                i32.lt_u
                i32.eqz
                br_if 1

                ;; x = rope[i * 4]
                global.get $rope
                local.get $i
                i32.const 4
                i32.mul
                i32.add
                i32.load16_u
                local.set $x
                ;; y = rope[i * 4 + 2]
                global.get $rope
                local.get $i
                i32.const 4
                i32.mul
                i32.add
                i32.const 2
                i32.add
                i32.load16_u
                local.set $y

                local.get $x
                call $printi
                i32.const 47
                call $printch
                local.get $y
                call $printi
                i32.const 32
                call $printch
                
                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        call $flush
    )

    (func $printGrid
        (local $x i32)
        (local $y i32)

        ;; y = gridSize - 1
        global.get $gridSize
        i32.const 1
        i32.sub
        local.set $y
        block
            loop
                ;; while y >= 0
                local.get $y
                i32.const 0
                i32.ge_s
                i32.eqz
                br_if 1

                ;; x = 0
                i32.const 0
                local.set $x
                block
                    loop
                        ;; while x < gridSize
                        local.get $x
                        global.get $gridSize
                        i32.lt_u
                        i32.eqz
                        br_if 1

                        ;; if grid[x * gridSize + y]
                        global.get $grid
                        local.get $x
                        global.get $gridSize
                        i32.mul
                        local.get $y
                        i32.add
                        i32.add
                        i32.load8_u
                        if
                            i32.const 35 ;; #
                            call $printch
                        else
                            i32.const 46 ;; .
                            call $printch
                        end

                        ;; x = x + 1
                        local.get $x
                        i32.const 1
                        i32.add
                        local.set $x
                        br 0
                    end
                end

                call $flush

                ;; y = y - 1
                local.get $y
                i32.const 1
                i32.sub
                local.set $y
                br 0
            end
        end
    )

    (func $abs (param $value i32) (result i32)
        ;; if value < 0
        local.get $value
        i32.const 0
        i32.lt_s
        if (result i32)
            ;; return 0 - value
            i32.const 0
            local.get $value
            i32.sub
        else
            ;; return value
            local.get $value
        end
    )

    (func $doSingleMove (param $direction i32)
        (local $headX i32)
        (local $headY i32)
        (local $tailX i32)
        (local $tailY i32)
        (local $i i32)

        ;; headX = rope[0]
        global.get $rope
        i32.load16_u
        local.set $headX
        ;; headY = rope[2]
        global.get $rope
        i32.const 2
        i32.add
        i32.load16_u
        local.set $headY

        block
            block
                block
                    block
                        block
                            ;; switch direction
                            ;; 0 => U
                            ;; 1 => R
                            ;; 2 => D
                            ;; 3 => L
                            local.get $direction
                            br_table 0 1 2 3
                        end
                        ;; case U:
                        ;; headY = headY + 1
                        local.get $headY
                        i32.const 1
                        i32.add
                        local.set $headY
                        br 3
                    end
                    ;; case R:
                    ;; headX = headX + 1
                    local.get $headX
                    i32.const 1
                    i32.add
                    local.set $headX
                    br 2
                end
                ;; case D:
                ;; headY = headY - 1
                local.get $headY
                i32.const 1
                i32.sub
                local.set $headY
                br 1
            end
            ;; case L
            ;; headX = headX - 1
            local.get $headX
            i32.const 1
            i32.sub
            local.set $headX
        end

        ;; rope[0] = headX
        global.get $rope
        local.get $headX
        i32.store16
        ;; rope[2] = headY
        global.get $rope
        i32.const 2
        i32.add
        local.get $headY
        i32.store16

        block
            loop
                ;; while i < ropeLength - 1
                local.get $i
                global.get $ropeLength
                i32.const 1
                i32.sub
                i32.lt_u
                i32.eqz
                br_if 1

                ;; pullRope(i)
                local.get $i
                call $pullRope

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end
        
        ;; tailX = rope[(ropeLength - 1) * 4]
        global.get $rope
        global.get $ropeLength
        i32.const 1
        i32.sub
        i32.const 4
        i32.mul
        i32.add
        i32.load16_u
        local.set $tailX
        ;; tailY = rope[(ropeLength - 1) * 4 + 2]
        global.get $rope
        global.get $ropeLength
        i32.const 1
        i32.sub
        i32.const 4
        i32.mul
        i32.const 2
        i32.add
        i32.add
        i32.load16_u
        local.set $tailY

        ;; grid[tailX * gridSize + tailY] = 1
        global.get $grid
        local.get $tailX
        global.get $gridSize
        i32.mul
        local.get $tailY
        i32.add
        i32.add
        i32.const 1
        i32.store8

        ;; call $printState
    )

    (func $pullRope (param $segment i32)
        (local $headX i32)
        (local $headY i32)
        (local $tailX i32)
        (local $tailY i32)

        ;; headX = rope[segment * 4]
        global.get $rope
        local.get $segment
        i32.const 4
        i32.mul
        i32.add
        i32.load16_u
        local.set $headX
        ;; headY = rope[segment * 4 + 2]
        global.get $rope
        local.get $segment
        i32.const 4
        i32.mul
        i32.const 2
        i32.add
        i32.add
        i32.load16_u
        local.set $headY
        ;; tailX = rope[segment * 4 + 4]
        global.get $rope
        local.get $segment
        i32.const 4
        i32.mul
        i32.const 4
        i32.add
        i32.add
        i32.load16_u
        local.set $tailX
        ;; tailY = rope[segment * 4 + 6]
        global.get $rope
        local.get $segment
        i32.const 4
        i32.mul
        i32.const 6
        i32.add
        i32.add
        i32.load16_u
        local.set $tailY

        ;; prehandling for large diagonal distance
        ;; if abs(headY - tailY) == 2 && abs(headX - tailX) == 1
        local.get $headY
        local.get $tailY
        i32.sub
        call $abs
        i32.const 2
        i32.eq

        local.get $headX
        local.get $tailX
        i32.sub
        call $abs
        i32.const 1
        i32.eq

        i32.and
        if
            ;; tailX = tailX + (headX - tailX)
            local.get $tailX
            local.get $headX
            local.get $tailX
            i32.sub
            i32.add
            local.set $tailX
        end

        ;; if abs(headX - tailX) == 2 && abs(headY - tailY) == 1
        local.get $headX
        local.get $tailX
        i32.sub
        call $abs
        i32.const 2
        i32.eq

        local.get $headY
        local.get $tailY
        i32.sub
        call $abs
        i32.const 1
        i32.eq

        i32.and
        if
            ;; tailY = tailY + (headY - tailY)
            local.get $tailY
            local.get $headY
            local.get $tailY
            i32.sub
            i32.add
            local.set $tailY
        end

        ;; normal distance=2 handling

        ;; if headX == tailX && abs(headY - tailY) == 2
        local.get $headX
        local.get $tailX
        i32.eq
        local.get $headY
        local.get $tailY
        i32.sub
        call $abs
        i32.const 2
        i32.eq
        i32.and
        if
            ;; tailY = tailY + (headY - tailY) / 2
            local.get $tailY
            local.get $headY
            local.get $tailY
            i32.sub
            i32.const 2
            i32.div_s
            i32.add
            local.set $tailY
        end

        ;; if headY == tailY && abs(headX - tailX) == 2
        local.get $headY
        local.get $tailY
        i32.eq
        local.get $headX
        local.get $tailX
        i32.sub
        call $abs
        i32.const 2
        i32.eq
        i32.and
        if
            ;; tailX = tailX + (headX - tailX) / 2
            local.get $tailX
            local.get $headX
            local.get $tailX
            i32.sub
            i32.const 2
            i32.div_s
            i32.add
            local.set $tailX
        end

        ;; diagonal distance=2 handling

        ;; if abs(headX - tailX) == 2 && abs(headY - tailY) == 2
        local.get $headX
        local.get $tailX
        i32.sub
        call $abs
        i32.const 2
        i32.eq

        local.get $headY
        local.get $tailY
        i32.sub
        call $abs
        i32.const 2
        i32.eq

        i32.and
        if
            ;; tailX = tailX + (headX - tailX) / 2
            local.get $tailX
            local.get $headX
            local.get $tailX
            i32.sub
            i32.const 2
            i32.div_s
            i32.add
            local.set $tailX

            ;; tailY = tailY + (headY - tailY) / 2
            local.get $tailY
            local.get $headY
            local.get $tailY
            i32.sub
            i32.const 2
            i32.div_s
            i32.add
            local.set $tailY
        end

        ;; rope[segment * 4 + 4] = tailX
        global.get $rope
        local.get $segment
        i32.const 4
        i32.mul
        i32.const 4
        i32.add
        i32.add
        local.get $tailX
        i32.store16
        ;; rope[segment * 4 + 6] = tailY
        global.get $rope
        local.get $segment
        i32.const 4
        i32.mul
        i32.const 6
        i32.add
        i32.add
        local.get $tailY
        i32.store16
    )

    (func $doMove (param $direction i32) (param $amount i32)
        (local $i i32)

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < amount
                local.get $i
                local.get $amount
                i32.lt_u
                i32.eqz
                br_if 1

                local.get $direction
                call $doSingleMove

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        ;; call $printGrid
    )

    (func $countVisitedPositions (result i32)
        (local $visitedPositions i32)
        (local $i i32)
        
        ;; visitedPositions = 0
        i32.const 0
        local.set $visitedPositions

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < gridSize * gridSize
                local.get $i
                global.get $gridSize
                global.get $gridSize
                i32.mul
                i32.lt_u
                i32.eqz
                br_if 1

                ;; visitedPositions = grid[i] + vistedPositions
                global.get $grid
                local.get $i
                i32.add
                i32.load8_u
                local.get $visitedPositions
                i32.add
                local.set $visitedPositions

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        local.get $visitedPositions
    )

    ;;     0 
    ;;     U 
    ;; 3 L + R 1
    ;;     D 
    ;;     2 

    (func $parseDirection (param $ch i32) (result i32)
        local.get $ch
        i32.const 85 ;; U
        i32.eq
        if  
            i32.const 0
            return
        end

        local.get $ch
        i32.const 82 ;; R
        i32.eq
        if  
            i32.const 1
            return
        end

        local.get $ch
        i32.const 68 ;; D
        i32.eq
        if  
            i32.const 2
            return
        end

        local.get $ch
        i32.const 76 ;; L
        i32.eq
        if  
            i32.const 3
            return
        end

        unreachable
    )

    (global $currentLine (mut i32) (i32.const 0))

    (func $main
        (local $i i32)

        ;; line = malloc(maxLine);
        global.get $maxLine
        call $malloc
        global.set $currentLine

        ;; grid = malloc(gridSize * gridSize);
        global.get $gridSize
        global.get $gridSize
        i32.mul
        call $malloc
        global.set $grid

        ;; rope = malloc(4 * ropeLength)
        i32.const 4
        global.get $ropeLength
        i32.mul
        call $malloc
        global.set $rope

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < ropeLength * 2
                local.get $i
                global.get $ropeLength
                i32.const 2
                i32.mul
                i32.lt_u
                i32.eqz
                br_if 1

                ;; rope[i * 2] = centerXY
                global.get $rope
                local.get $i
                i32.const 2
                i32.mul
                i32.add
                global.get $centerXY
                i32.store16

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        block
            loop
                ;; while !isEof()
                call $isEof
                br_if 1

                ;; readLine(line)
                global.get $currentLine
                call $readLine
                
                ;; doMove(parseDirection(currentLine[0]), parseInt(currentLine, 2))
                global.get $currentLine
                i32.const 0
                call $array8Get
                call $parseDirection

                global.get $currentLine
                i32.const 2
                call $parseInt                

                call $doMove

                br 0
            end
        end

        call $countVisitedPositions
        call $println

        ;; call $printGrid
    )

    (export "main" (func $main))
)
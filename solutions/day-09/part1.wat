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

    (global $headX (mut i32) (i32.const 0))
    (global $headY (mut i32) (i32.const 0))
    (global $tailX (mut i32) (i32.const 0))
    (global $tailY (mut i32) (i32.const 0))
    (global $grid (mut i32) (i32.const 0))
    (global $gridSize i32 (i32.const 1000))

    (func $printState
        global.get $headX
        call $printi
        i32.const 47
        call $printch
        global.get $headY
        call $printi
        i32.const 61
        call $printch
        global.get $tailX
        call $printi
        i32.const 47
        call $printch
        global.get $tailY
        call $printi
        call $flush
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
        ;; local.get $direction
        ;; call $println

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
                        global.get $headY
                        i32.const 1
                        i32.add
                        global.set $headY
                        br 3
                    end
                    ;; case R:
                    ;; headX = headX + 1
                    global.get $headX
                    i32.const 1
                    i32.add
                    global.set $headX
                    br 2
                end
                ;; case D:
                ;; headY = headY - 1
                global.get $headY
                i32.const 1
                i32.sub
                global.set $headY
                br 1
            end
            ;; case L
            ;; headX = headX - 1
            global.get $headX
            i32.const 1
            i32.sub
            global.set $headX
        end

        ;; prehandling for large diagonal distance
        ;; if abs(headY - tailY) == 2 && abs(headX - tailX) == 1
        global.get $headY
        global.get $tailY
        i32.sub
        call $abs
        i32.const 2
        i32.eq

        global.get $headX
        global.get $tailX
        i32.sub
        call $abs
        i32.const 1
        i32.eq

        i32.and
        if
            ;; tailX = tailX + (headX - tailX)
            global.get $tailX
            global.get $headX
            global.get $tailX
            i32.sub
            i32.add
            global.set $tailX
        end

        ;; if abs(headX - tailX) == 2 && abs(headY - tailY) == 1
        global.get $headX
        global.get $tailX
        i32.sub
        call $abs
        i32.const 2
        i32.eq

        global.get $headY
        global.get $tailY
        i32.sub
        call $abs
        i32.const 1
        i32.eq

        i32.and
        if
            ;; tailY = tailY + (headY - tailY)
            global.get $tailY
            global.get $headY
            global.get $tailY
            i32.sub
            i32.add
            global.set $tailY
        end

        ;; normal distance=2 handling

        ;; if headX == tailX && abs(headY - tailY) == 2
        global.get $headX
        global.get $tailX
        i32.eq
        global.get $headY
        global.get $tailY
        i32.sub
        call $abs
        i32.const 2
        i32.eq
        i32.and
        if
            ;; tailY = tailY + (headY - tailY) / 2
            global.get $tailY
            global.get $headY
            global.get $tailY
            i32.sub
            i32.const 2
            i32.div_s
            i32.add
            global.set $tailY
        end

        ;; if headY == tailY && abs(headX - tailX) == 2
        global.get $headY
        global.get $tailY
        i32.eq
        global.get $headX
        global.get $tailX
        i32.sub
        call $abs
        i32.const 2
        i32.eq
        i32.and
        if
            ;; tailX = tailX + (headX - tailX) / 2
            global.get $tailX
            global.get $headX
            global.get $tailX
            i32.sub
            i32.const 2
            i32.div_s
            i32.add
            global.set $tailX
        end

        ;; grid[tailX * gridSize + tailY] = 1
        global.get $grid
        global.get $tailX
        global.get $gridSize
        i32.mul
        global.get $tailY
        i32.add
        i32.add
        i32.const 1
        i32.store8

        ;; call $printState
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

        ;; headX = 400
        i32.const 400
        global.set $headX
        ;; headY = 400
        i32.const 400
        global.set $headY
        ;; tailX = 400
        i32.const 400
        global.set $tailX
        ;; tailY = 400
        i32.const 400
        global.set $tailY

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
                call $stringGet
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
    )

    (export "main" (func $main))
)
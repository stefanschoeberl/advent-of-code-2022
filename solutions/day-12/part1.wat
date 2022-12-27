(module
    (import "js" "memory" (memory 1000))
    (import "js" "println" (func $println (param i32)))
    (import "js" "prints" (func $prints (param i32)))
    (import "js" "printi" (func $printi (param i32)))
    (import "js" "printb" (func $printb (param i32)))
    (import "js" "printch" (func $printch (param i32)))
    (import "js" "readLine" (func $readLine (param i32)))
    (import "js" "isEof" (func $isEof (result i32)))
    (import "js" "flush" (func $flush))

    (func $parseInt (param $str i32) (param $offset i32) (result i32)
        (local $result i32)
        (local $ch i32)
        (local $negative i32)

        ;; result = 0
        i32.const 0
        local.set $result

        ;; negative = false
        i32.const 0
        local.set $negative
        
        ;; if str[offset] == '-'
        local.get $str
        local.get $offset
        call $array8Get
        i32.const 45 ;; -
        i32.eq
        if
            ;; negative = true
            i32.const 1
            local.set $negative

            ;; offset = offset + 1
            local.get $offset
            i32.const 1
            i32.add
            local.set $offset
        end

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

        ;; if negative
        local.get $negative
        if
            ;; result = 0 - result
            i32.const 0
            local.get $result
            i32.sub
            local.set $result
        end

        ;; return result
        local.get $result
    )

    (global $memoryPos (mut i32) (i32.const 1))

    (global $maxLine i32 (i32.const 200))

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

    (func $strIndexOf (param $str i32) (param $ch i32) (param $offset i32) (result i32)
        (local $i i32)

        ;; i = offset
        local.get $offset
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

    (global $currentLine (mut i32) (i32.const 0))

    (global $maxSize i32 (i32.const 200))

    (global $map (mut i32) (i32.const 0))
    (global $width (mut i32) (i32.const 0))
    (global $height (mut i32) (i32.const 0))

    (global $startX (mut i32) (i32.const 0))
    (global $startY (mut i32) (i32.const 0))

    (global $endX (mut i32) (i32.const 0))
    (global $endY (mut i32) (i32.const 0))

    (global $numberOfSteps (mut i32) (i32.const 0))
    (global $maxSteps (mut i32) (i32.const 10000000))

    ;; struct Point {
    ;;   0  int x  1
    ;;   1  int y  1
    ;; }           2

    (func $initNumberOfSteps
        (local $i i32)

        block
            loop
                ;; while i < maxSize * maxSize
                local.get $i
                global.get $maxSize
                global.get $maxSize
                i32.mul
                i32.lt_u
                i32.eqz
                br_if 1

                ;; numberOfSteps[i] = maxSteps
                global.get $numberOfSteps
                local.get $i
                i32.const 4
                i32.mul
                i32.add
                global.get $maxSteps
                i32.store

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                
                br 0
            end
        end
    )

    (global $queue (mut i32) (i32.const 0))
    (global $queuePos (mut i32) (i32.const 0))
    (global $queueSize (mut i32) (i32.const 0))

    (global $currentX (mut i32) (i32.const 0))
    (global $currentY (mut i32) (i32.const 0))

    (func $expand (param $x i32) (param $y i32)
        ;; local.get $x
        ;; call $println

        ;; local.get $y
        ;; call $println

        ;; if numberOfSteps[x + y * width] == maxSteps && map[x + y * width] <= map[currentX + currentY * width] + 1
        global.get $numberOfSteps
        local.get $x
        local.get $y
        global.get $width
        i32.mul
        i32.add
        i32.const 4
        i32.mul
        i32.add
        i32.load
        global.get $maxSteps
        i32.eq

        global.get $map
        local.get $x
        local.get $y
        global.get $width
        i32.mul
        i32.add
        i32.add
        i32.load8_u

        global.get $map
        global.get $currentX
        global.get $currentY
        global.get $width
        i32.mul
        i32.add
        i32.add
        i32.load8_u
        i32.const 1
        i32.add

        i32.le_u

        i32.and
        if
            ;; queue[queueSize].x = x
            global.get $queue
            global.get $queueSize
            i32.const 2
            i32.mul
            i32.add
            local.get $x
            i32.store8

            ;; queue[queueSize].y = y
            global.get $queue
            global.get $queueSize
            i32.const 2
            i32.mul
            i32.add
            i32.const 1
            i32.add
            local.get $y
            i32.store8
            
            ;; queueSize = queueSize + 1
            global.get $queueSize
            i32.const 1
            i32.add
            global.set $queueSize

            ;; numberOfSteps[x + y * width] = numberOfSteps[currentX + currentY * width] + 1
            global.get $numberOfSteps
            local.get $x
            local.get $y
            global.get $width
            i32.mul
            i32.add
            i32.const 4
            i32.mul
            i32.add

            global.get $numberOfSteps
            global.get $currentX
            global.get $currentY
            global.get $width
            i32.mul
            i32.add
            i32.const 4
            i32.mul
            i32.add
            i32.load
            i32.const 1
            i32.add

            ;; call $spy

            i32.store
        end
    )

    (func $bfs
        call $initNumberOfSteps
        
        ;; queue = malloc(2*maxSize*maxSize)
        i32.const 2
        global.get $maxSize
        global.get $maxSize
        i32.mul
        i32.mul
        call $malloc
        global.set $queue

        ;; queuePos = 0
        i32.const 0
        global.set $queuePos

        ;; queue[0].x = startX
        global.get $queue
        global.get $startX
        i32.store8

        ;; queue[0].y = startY
        global.get $queue
        i32.const 1
        i32.add
        global.get $startY
        i32.store8

        ;; queueSize = 1
        i32.const 1
        global.set $queueSize

        ;; numberOfSteps[startX + startY * width] = 0
        global.get $numberOfSteps
        global.get $startX
        global.get $startY
        global.get $width
        i32.mul
        i32.add
        i32.const 4
        i32.mul
        i32.add
        i32.const 0
        i32.store

        block
            loop
                ;; while queuePos < queueSize
                global.get $queuePos
                global.get $queueSize
                i32.lt_u
                i32.eqz
                br_if 1

                ;; currentX = queue[queuePos].x
                global.get $queue
                global.get $queuePos
                i32.const 2
                i32.mul
                i32.add
                i32.load8_u
                global.set $currentX

                ;; currentY = queue[queuePos].y
                global.get $queue
                global.get $queuePos
                i32.const 2
                i32.mul
                i32.add
                i32.const 1
                i32.add
                i32.load8_u
                global.set $currentY

                ;; if currentX > 0 (expand left)
                global.get $currentX
                i32.const 0
                i32.gt_u
                if
                    ;; expand(currentX - 1, currentY)
                    global.get $currentX
                    i32.const 1
                    i32.sub
                    global.get $currentY
                    call $expand
                end

                ;; if currentY > 0 (expand up)
                global.get $currentY
                i32.const 0
                i32.gt_u
                if
                    ;; expand(currentX, currentY - 1)
                    global.get $currentX
                    global.get $currentY
                    i32.const 1
                    i32.sub
                    call $expand
                end

                ;; if currentX < width - 1 (expand right)
                global.get $currentX
                global.get $width
                i32.const 1
                i32.sub
                i32.lt_u
                if
                    ;; expand(currentX + 1, currentY)
                    global.get $currentX
                    i32.const 1
                    i32.add
                    global.get $currentY
                    call $expand
                end

                ;; if currentY < height - 1 (expand down)
                global.get $currentY
                global.get $height
                i32.const 1
                i32.sub
                i32.lt_u
                if
                    ;; expand(currentX, currentY + 1)
                    global.get $currentX
                    global.get $currentY
                    i32.const 1
                    i32.add
                    call $expand
                end
                
                ;; queuePos = queuePos + 1
                global.get $queuePos
                i32.const 1
                i32.add
                global.set $queuePos
                
                br 0
            end
        end
    )

    (func $main
        (local $i i32)
        (local $ch i32)
        ;; line = malloc(maxLine);
        global.get $maxLine
        call $malloc
        global.set $currentLine

        ;; map = malloc(maxSize * maxSize)
        global.get $maxSize
        global.get $maxSize
        i32.mul
        call $malloc
        global.set $map

        ;; height = 0
        i32.const 0
        global.set $height

        ;; numberOfSteps = malloc(maxSize * maxSize * 4)
        global.get $maxSize
        global.get $maxSize
        i32.const 4
        i32.mul
        i32.mul
        call $malloc
        global.set $numberOfSteps

        block
            loop
                ;; while !isEof()
                call $isEof
                br_if 1

                ;; readLine(currentLine)
                global.get $currentLine
                call $readLine

                ;; width = strlen(currentLine)
                global.get $currentLine
                call $strlen
                global.set $width

                ;; i = 0
                i32.const 0
                local.set $i

                block
                    loop
                        ;; while i < width
                        local.get $i
                        global.get $width
                        i32.lt_u
                        i32.eqz
                        br_if 1

                        ;; ch = array8Get(currentLine, i)
                        global.get $currentLine
                        local.get $i
                        call $array8Get
                        local.set $ch

                        ;; if ch == 'S'
                        local.get $ch
                        i32.const 83 ;; 'S'
                        i32.eq
                        if
                            ;; ch = 'a'
                            i32.const 97 ;; 'a'
                            local.set $ch

                            ;; startX = i
                            local.get $i
                            global.set $startX

                            ;; startY = height
                            global.get $height
                            global.set $startY
                        end

                        ;; if ch == 'E'
                        local.get $ch
                        i32.const 69 ;; 'E'
                        i32.eq
                        if
                            ;; ch = 'z'
                            i32.const 122 ;; 'z'
                            local.set $ch

                            ;; endX = i
                            local.get $i
                            global.set $endX

                            ;; endY = height
                            global.get $height
                            global.set $endY
                        end

                        ;; array8Set(map, height * width + i, ch)
                        global.get $map
                        global.get $height
                        global.get $width
                        i32.mul
                        local.get $i
                        i32.add
                        local.get $ch
                        call $array8Set

                        ;; i = i + 1
                        local.get $i
                        i32.const 1
                        i32.add
                        local.set $i

                        br 0
                    end
                end

                ;; height = height + 1
                global.get $height
                i32.const 1
                i32.add
                global.set $height
                
                br 0
            end
        end

        call $bfs

        ;; println(numberOfSteps[endX + endY * width])
        global.get $numberOfSteps
        global.get $endX
        global.get $endY
        global.get $width
        i32.mul
        i32.add
        i32.const 4
        i32.mul
        i32.add
        i32.load
        call $println
    )

    (export "main" (func $main))
)
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
    (global $cycleNumber (mut i32) (i32.const 0))
    (global $registerX (mut i32) (i32.const 0))

    (func $startCycle
        (local $pixel i32)
        ;; cycleNumber = cycleNumber + 1
        global.get $cycleNumber
        i32.const 1
        i32.add
        global.set $cycleNumber

        ;; pixel = (cycleNumber - 1) % 40
        global.get $cycleNumber
        i32.const 1
        i32.sub
        i32.const 40
        i32.rem_u
        local.set $pixel

        ;; if pixel >= registerX - 1 && pixel <= registerX + 1
        local.get $pixel
        global.get $registerX
        i32.const 1
        i32.sub
        i32.ge_s

        local.get $pixel
        global.get $registerX
        i32.const 1
        i32.add
        i32.le_s

        i32.and
        if
            ;; printch('#')
            i32.const 35 ;; #
            call $printch
        else
            ;; printch('.')
            i32.const 46 ;; .
            call $printch
        end

        ;; if cycleNumber % 40 == 0
        global.get $cycleNumber
        i32.const 40
        i32.rem_u
        i32.const 0
        i32.eq
        if
            call $flush
        end
    )

    (func $main
        ;; line = malloc(maxLine);
        global.get $maxLine
        call $malloc
        global.set $currentLine

        ;; counter = 1
        i32.const 1
        global.set $registerX

        ;; cycleNumber = 0
        i32.const 0
        global.set $cycleNumber

        block
            loop
                ;; while !isEof()
                call $isEof
                br_if 1

                ;; readLine(line)
                global.get $currentLine
                call $readLine

                ;; if currentLine[0] == 'n'
                global.get $currentLine
                i32.const 0
                call $array8Get
                i32.const 110 ;; n
                i32.eq
                if
                    ;; noop
                    call $startCycle
                else
                    ;; addx
                    call $startCycle
                    call $startCycle

                    global.get $currentLine
                    i32.const 5
                    call $parseInt
                    global.get $registerX
                    i32.add
                    global.set $registerX
                end
                
                br 0
            end
        end
    )

    (export "main" (func $main))
)
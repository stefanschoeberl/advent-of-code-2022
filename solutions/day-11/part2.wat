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

    (global $maxMonkeys i32 (i32.const 10))
    (global $numMonkeys (mut i32) (i32.const 0))

    (global $maxItems i32 (i32.const 100))

    (global $monkeyData (mut i32) (i32.const 0))
    (global $monkeyStats (mut i32) (i32.const 0))

    (global $divisorProduct (mut i32) (i32.const 0))

    ;; operation
    ;;   0 *
    ;;   1 +

    ;; struct monkey {
    ;;    0  int8   operation             1 byte
    ;;    1  bool   operandIsOld          1 byte
    ;;    2  int8   operand               1 byte
    ;;    3  int8   divisibleBy           1 byte
    ;;    4  int8   monkeyIfTrue          1 byte
    ;;    5  int8   monkeyIfFalse         1 byte
    ;;    6  int8   numItems              1 byte
    ;;    7  int32[maxItems] mailbox    400 byte
    ;; }                                407 byte
    (global $monkeySize i32 (i32.const 407))

    (func $readMonkey
        (local $numItems i32)
        (local $intPos i32)
        ;; read "Monkey X"
        ;; readLine(line)
        global.get $currentLine
        call $readLine

        ;; read "Starting items: ..."
        ;; readLine(line)
        global.get $currentLine
        call $readLine

        ;; numItems = 0
        i32.const 0
        local.set $numItems

        ;; intPos = 18
        i32.const 18
        local.set $intPos

        block
            loop
                ;; while intPos > 0
                local.get $intPos
                i32.const 0
                i32.gt_s
                i32.eqz
                br_if 1

                ;; monkeyData[numMonkeys].mailbox[numItems] = parseInt(currentLine, intPos)
                global.get $monkeyData
                global.get $numMonkeys
                global.get $monkeySize
                i32.mul
                i32.add
                i32.const 7
                i32.add
                local.get $numItems
                i32.const 4
                i32.mul
                i32.add

                global.get $currentLine
                local.get $intPos
                call $parseInt

                i32.store

                ;; numItems = numItems + 1
                local.get $numItems
                i32.const 1
                i32.add
                local.set $numItems

                ;; intPos = strIndexOf(currentLine, ' ', intPos) + 1
                global.get $currentLine
                i32.const 32 ;; ' '
                local.get $intPos
                call $strIndexOf
                i32.const 1
                i32.add
                local.set $intPos
                br 0
            end
        end

        ;; monkeyData[numMonkeys].numItems = numItems
        global.get $monkeyData
        global.get $numMonkeys
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 6
        i32.add

        local.get $numItems

        i32.store8

        ;; read "Operation: ..."
        ;; readLine(line)
        global.get $currentLine
        call $readLine

        ;; 42 = *
        ;; 43 = +

        ;; monkeyData[numMonkeys].operation = currentLine[23] - 42
        global.get $monkeyData
        global.get $numMonkeys
        global.get $monkeySize
        i32.mul
        i32.add

        global.get $currentLine
        i32.const 23
        call $array8Get
        i32.const 42
        i32.sub

        i32.store8

        ;; if currentLine[25] == 'o'
        global.get $currentLine
        i32.const 25
        call $array8Get
        i32.const 111 ;; o
        i32.eq
        if
            ;; monkeyData[numMonkeys].operandIsOld = true
            global.get $monkeyData
            global.get $numMonkeys
            global.get $monkeySize
            i32.mul
            i32.add
            i32.const 1
            i32.add

            i32.const 1

            i32.store8
        else
            ;; monkeyData[numMonkeys].operandIsOld = false
            global.get $monkeyData
            global.get $numMonkeys
            global.get $monkeySize
            i32.mul
            i32.add
            i32.const 1
            i32.add

            i32.const 0

            i32.store8

            ;; monkeyData[numMonkeys].operand = parseInt(currentLine, 25)
            global.get $monkeyData
            global.get $numMonkeys
            global.get $monkeySize
            i32.mul
            i32.add
            i32.const 2
            i32.add

            global.get $currentLine
            i32.const 25
            call $parseInt

            i32.store8
        end

        ;; read "Test: ..."
        ;; readLine(line)
        global.get $currentLine
        call $readLine

        ;; monkeyData[numMonkeys].divisbleBy = parseInt(currentLine, 21)
        global.get $monkeyData
        global.get $numMonkeys
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 3
        i32.add

        global.get $currentLine
        i32.const 21
        call $parseInt

        i32.store8

        ;; read "If true: ..."
        ;; readLine(line)
        global.get $currentLine
        call $readLine

        ;; monkeyData[numMonkeys].monkeyIfTrue = parseInt(currentLine, 29)
        global.get $monkeyData
        global.get $numMonkeys
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 4
        i32.add

        global.get $currentLine
        i32.const 29
        call $parseInt

        i32.store8

        ;; read "If false: ..."
        ;; readLine(line)
        global.get $currentLine
        call $readLine

        ;; monkeyData[numMonkeys].monkeyIfFalse = parseInt(currentLine, 30)
        global.get $monkeyData
        global.get $numMonkeys
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 5
        i32.add

        global.get $currentLine
        i32.const 30
        call $parseInt

        i32.store8
    )

    (func $printMonkeys
        (local $i i32)
        (local $item i32)
        
        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < numMonkeys
                local.get $i
                global.get $numMonkeys
                i32.lt_u
                i32.eqz
                br_if 1

                ;; println(i)
                local.get $i
                call $println

                ;; printi(monkeyData[i].numItems)
                global.get $monkeyData
                local.get $i
                global.get $monkeySize
                i32.mul
                i32.add
                i32.const 6
                i32.add
                i32.load8_u
                call $printi
                call $flush

                ;; printch('[')
                i32.const 91 ;; [
                call $printch

                ;; printch(' ')
                i32.const 32 ;; ' '
                call $printch

                ;; item = 0
                i32.const 0
                local.set $item

                block
                    loop
                        ;; while item < monkeyData[i].numItems
                        local.get $item
                        global.get $monkeyData
                        local.get $i
                        global.get $monkeySize
                        i32.mul
                        i32.add
                        i32.const 6
                        i32.add
                        i32.load8_u
                        i32.lt_u
                        i32.eqz
                        br_if 1

                        ;; printi(monkeyData[i].mailbox[item])
                        global.get $monkeyData
                        local.get $i
                        global.get $monkeySize
                        i32.mul
                        i32.add
                        i32.const 7
                        i32.add
                        local.get $item
                        i32.const 4
                        i32.mul
                        i32.add
                        i32.load
                        call $printi

                        ;; printch(' ')
                        i32.const 32 ;; ' '
                        call $printch

                        ;; item = item + 1
                        local.get $item
                        i32.const 1
                        i32.add
                        local.set $item
                        br 0
                    end
                end
                ;; printch('[')
                i32.const 93 ;; [
                call $printch

                call $flush

                ;; printch('+')
                i32.const 43 ;; +
                call $printch

                ;; printi(monkeyData[i].operation)
                global.get $monkeyData
                local.get $i
                global.get $monkeySize
                i32.mul
                i32.add
                i32.load8_u
                call $printi
                call $flush

                ;; printi(monkeyData[i].operandIsOld)
                global.get $monkeyData
                local.get $i
                global.get $monkeySize
                i32.mul
                i32.add
                i32.const 1
                i32.add
                i32.load8_u
                call $printb
                call $flush

                ;; printi(monkeyData[i].operand)
                global.get $monkeyData
                local.get $i
                global.get $monkeySize
                i32.mul
                i32.add
                i32.const 2
                i32.add
                i32.load8_u
                call $printi
                call $flush

                ;; printch('d')
                i32.const 100 ;; d
                call $printch

                ;; printi(monkeyData[i].divisibleBy)
                global.get $monkeyData
                local.get $i
                global.get $monkeySize
                i32.mul
                i32.add
                i32.const 3
                i32.add
                i32.load8_u
                call $printi
                call $flush

                ;; printch('T')
                i32.const 84 ;; T
                call $printch

                ;; printi(monkeyData[i].monkeyIfTrue)
                global.get $monkeyData
                local.get $i
                global.get $monkeySize
                i32.mul
                i32.add
                i32.const 4
                i32.add
                i32.load8_u
                call $printi
                call $flush

                ;; printch('F')
                i32.const 70 ;; F
                call $printch

                ;; printi(monkeyData[i].monkeyIfFalse)
                global.get $monkeyData
                local.get $i
                global.get $monkeySize
                i32.mul
                i32.add
                i32.const 5
                i32.add
                i32.load8_u
                call $printi
                call $flush

                ;; printch(' ')
                ;; flush()
                i32.const 32
                call $printch
                call $flush

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end
    )

    (func $doOperation (param $a i32) (param $b i32) (param $op i32) (result i32)
        local.get $op
        if (result i64)
            local.get $a
            i64.extend_i32_u
            local.get $b
            i64.extend_i32_u
            i64.add
        else
            local.get $a
            i64.extend_i32_u
            local.get $b
            i64.extend_i32_u
            i64.mul
        end
        global.get $divisorProduct
        i64.extend_i32_u
        i64.rem_u
        i32.wrap_i64
    )

    (func $addItemToMailbox (param $monkey i32) (param $item i32)
        (local $numItems i32)

        ;; numItems = monkeyData[monkey].numItems
        global.get $monkeyData
        local.get $monkey
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 6
        i32.add
        i32.load8_u
        local.set $numItems

        ;; monkeyData[monkey].mailbox[numItems] = item
        global.get $monkeyData
        local.get $monkey
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 7
        i32.add
        local.get $numItems
        i32.const 4
        i32.mul
        i32.add

        local.get $item
        i32.store

        ;; monkeyData[monkey].numItems = numItems + 1
        global.get $monkeyData
        local.get $monkey
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 6
        i32.add

        local.get $numItems
        i32.const 1
        i32.add

        i32.store8
    )

    (func $inspectItem (param $monkey i32) (param $item i32)
        (local $value i32)

        ;; value = monkeyData[monkey].mailbox[item]
        global.get $monkeyData
        local.get $monkey
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 7
        i32.add
        local.get $item
        i32.const 4
        i32.mul
        i32.add
        i32.load
        local.set $value

        ;; put value on stack
        local.get $value

        ;; put operand on stack
        ;; if monkeyData[monkey].operandIsOld
        global.get $monkeyData
        local.get $monkey
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 1
        i32.add
        i32.load8_u
        if (result i32)
            local.get $value
        else
            ;; monkeyData[monkey].operand
            global.get $monkeyData
            local.get $monkey
            global.get $monkeySize
            i32.mul
            i32.add
            i32.const 2
            i32.add
            i32.load8_u
        end

        ;; monkeyData[monkey].operation
        global.get $monkeyData
        local.get $monkey
        global.get $monkeySize
        i32.mul
        i32.add
        i32.load8_u

        ;; do operation
        call $doOperation

        local.set $value

        ;; if value % monkeyData[monkey].divisibleBy == 0
        local.get $value

        global.get $monkeyData
        local.get $monkey
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 3
        i32.add
        i32.load8_u

        i32.rem_u
        i32.const 0
        i32.eq
        if  
            ;; addItemToMailBox(monkeyData[monkey].monkeyIfTrue, value)
            global.get $monkeyData
            local.get $monkey
            global.get $monkeySize
            i32.mul
            i32.add
            i32.const 4
            i32.add
            i32.load8_u

            local.get $value

            call $addItemToMailbox
        else
            ;; addItemToMailBox(monkeyData[monkey].monkeyIfFalse, value)
            global.get $monkeyData
            local.get $monkey
            global.get $monkeySize
            i32.mul
            i32.add
            i32.const 5
            i32.add
            i32.load8_u

            local.get $value

            call $addItemToMailbox
        end
    )

    (func $doSingleMonkeyRound (param $monkey i32)
        (local $numItems i32)
        (local $i i32)

        ;; numItems = monkeyData[monkey].numItems
        global.get $monkeyData
        local.get $monkey
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 6
        i32.add
        i32.load8_u
        local.set $numItems

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < numItems
                local.get $i
                local.get $numItems
                i32.lt_u
                i32.eqz
                br_if 1

                ;; inspectItem(monkey, i)
                local.get $monkey
                local.get $i
                call $inspectItem

                ;; monkeyStats[monkey] = monkeyStats[monkey] + 1
                global.get $monkeyStats
                local.get $monkey
                i32.const 4
                i32.mul
                i32.add

                global.get $monkeyStats
                local.get $monkey
                i32.const 4
                i32.mul
                i32.add
                i32.load

                i32.const 1
                i32.add

                i32.store


                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        ;; clear own mailbox

        ;; monkeyData[monkey].numItems = 0
        global.get $monkeyData
        local.get $monkey
        global.get $monkeySize
        i32.mul
        i32.add
        i32.const 6
        i32.add

        i32.const 0

        i32.store8
    )

    (func $doMonkeyRound
        (local $monkey i32)

        ;; monkey = 0
        i32.const 0
        local.set $monkey

        block
            loop
                ;; while monkey < numMonkeys
                local.get $monkey
                global.get $numMonkeys
                i32.lt_u
                i32.eqz
                br_if 1

                ;; doSingleMonkeyRound(monkey)
                local.get $monkey
                call $doSingleMonkeyRound

                ;; monkey = monkey + 1
                local.get $monkey
                i32.const 1
                i32.add
                local.set $monkey
                br 0
            end
        end

    )

    (func $printStats
        (local $i i32)

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < numMonkeys
                local.get $i
                global.get $numMonkeys
                i32.lt_u
                i32.eqz
                br_if 1

                ;; println(monkeyStats[i])
                global.get $monkeyStats
                local.get $i
                i32.const 4
                i32.mul
                i32.add
                i32.load
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

    (func $main
        (local $i i32)
        ;; line = malloc(maxLine);
        global.get $maxLine
        call $malloc
        global.set $currentLine

        ;; monkeyData = malloc(maxMonkeys * 407)
        global.get $maxMonkeys
        i32.const 407
        i32.mul
        call $malloc
        global.set $monkeyData

        ;; monkeyStats = malloc(maxMonkeys * 4)
        global.get $maxMonkeys
        i32.const 4
        i32.mul
        call $malloc
        global.set $monkeyStats

        ;; numMonkeys = 0
        i32.const 0
        global.set $numMonkeys

        block
            loop
                ;; while !isEof()
                call $isEof
                br_if 1

                call $readMonkey

                ;; if !isEof()
                call $isEof
                i32.eqz
                if
                    ;; read empty line
                    ;; readLine(line)
                    global.get $currentLine
                    call $readLine
                end

                ;; monkeyStats[numMonkeys] = 0
                global.get $monkeyStats
                global.get $numMonkeys
                i32.const 4
                i32.mul
                i32.add
                i32.const 0
                i32.store

                ;; numMonkeys = numMonkeys + 1
                global.get $numMonkeys
                i32.const 1
                i32.add
                global.set $numMonkeys
                
                br 0
            end
        end

        ;; calc product of all divisors

        ;; divisorProduct = 1
        i32.const 1
        global.set $divisorProduct

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < numMonkeys
                local.get $i
                global.get $numMonkeys
                i32.lt_u
                i32.eqz
                br_if 1

                ;; divisorProduct = monkeyData[i].divisbleBy * divisorProduct
                global.get $monkeyData
                local.get $i
                global.get $monkeySize
                i32.mul
                i32.add
                i32.const 3
                i32.add
                i32.load8_u

                global.get $divisorProduct
                i32.mul
                global.set $divisorProduct

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end

        ;; println(divisorProduct)
        global.get $divisorProduct
        call $println

        ;; i = 0
        i32.const 0
        local.set $i

        block
            loop
                ;; while i < 10000
                local.get $i
                i32.const 10000
                i32.lt_u
                i32.eqz
                br_if 1

                call $doMonkeyRound

                ;; if (i + 1) % 1000 == 0
                local.get $i
                i32.const 1
                i32.add
                i32.const 1000
                i32.rem_u
                i32.const 0
                i32.eq
                if
                    call $printStats
                end

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end
    )

    (export "main" (func $main))
)
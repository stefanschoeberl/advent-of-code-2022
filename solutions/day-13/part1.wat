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

    ;; -------------------------------------------------

    ;; struct node {
    ;;   0  boolean  isList  1
    ;;   1  node*    next    4
    ;;   5  node*    head    4  set if isList
    ;;   9  int      value   4  set if !isList
    ;; }                    13

    (global $nodeSize i32 (i32.const 13))

    (func $printNodeRec (param $node i32)
        (local $n i32)

        ;; if node.isList
        local.get $node
        i32.load8_u
        if
            i32.const 91
            call $printch

            i32.const 32
            call $printch

            ;; n = node.head
            local.get $node
            i32.const 5
            i32.add
            i32.load
            local.set $n

            block
                loop
                    ;; while n != null
                    local.get $n
                    i32.eqz
                    br_if 1

                    ;; printNodeRec(n)
                    local.get $n
                    call $printNodeRec

                    i32.const 32
                    call $printch

                    ;; n = n.next
                    local.get $n
                    i32.const 1
                    i32.add
                    i32.load
                    local.set $n
                    br 0
                end
            end

            i32.const 93
            call $printch
        else
            local.get $node
            i32.const 9
            i32.add
            i32.load
            call $printi
        end
    )

    (func $printNode (param $node i32)
        ;; printNodeRec(node)
        local.get $node
        call $printNodeRec
        call $flush
    )

    (global $maxLine i32 (i32.const 300))
    (global $currentLine (mut i32) (i32.const 0))

    (global $parsePosition (mut i32) (i32.const 0))

    (func $parseCurrentLine (result i32)
        ;; parsePosition = 0
        i32.const 0
        global.set $parsePosition

        call $parseList
    )

    (func $nextCh
        ;; parsePosition = parsePosition + 1
        global.get $parsePosition
        i32.const 1
        i32.add
        global.set $parsePosition
    )

    (func $parseIntValue (result i32)
        (local $result i32)
        (local $ch i32)
        (local $currentNode i32)

        ;; result = 0
        i32.const 0
        local.set $result

        block
            loop
                ;; ch = currentLine[parsePosition]
                global.get $currentLine
                global.get $parsePosition
                call $array8Get
                local.set $ch

                ;; while parsePosition < strlen(currentLine) && ch >= 48 && ch <= 57
                global.get $parsePosition
                global.get $currentLine
                call $strlen
                i32.lt_u

                local.get $ch
                i32.const 48
                i32.ge_u
                
                local.get $ch
                i32.const 57
                i32.le_u
                
                i32.and
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

                ;; nextCh()
                call $nextCh
                br 0
            end
        end

        ;; currentNode = malloc(nodeSize)
        global.get $nodeSize
        call $malloc
        local.set $currentNode

        ;; currentNode.isList = false
        local.get $currentNode
        i32.const 0
        i32.store8

        ;; currentNode.next = null
        local.get $currentNode
        i32.const 1
        i32.add
        i32.const 0
        i32.store

        ;; currentNode.value = result
        local.get $currentNode
        i32.const 9
        i32.add
        local.get $result
        i32.store

        ;; return currentNode
        local.get $currentNode
    )

    (func $parseList (result i32)
        (local $currentNode i32)
        (local $tail i32)
        (local $newNode i32)

        ;; currentNode = malloc(nodeSize)
        global.get $nodeSize
        call $malloc
        local.set $currentNode

        ;; currentNode.isList = true
        local.get $currentNode
        i32.const 1
        i32.store8

        ;; currentNode.next = null
        local.get $currentNode
        i32.const 1
        i32.add
        i32.const 0
        i32.store

        ;; currentNode.head = null
        local.get $currentNode
        i32.const 5
        i32.add
        i32.const 0
        i32.store

        ;; skip '['
        call $nextCh

        ;; if array8Get(currentLine, parsePosition) != ']'
        global.get $currentLine
        global.get $parsePosition
        call $array8Get
        i32.const 93 ;; ']'
        i32.ne
        if
            ;; if array8Get(currentLine, parsePosition) == '['
            global.get $currentLine
            global.get $parsePosition
            call $array8Get
            i32.const 91 ;; '['
            i32.eq
            if
                ;; tail = parseList()
                call $parseList
                local.set $tail
            else
                ;; tail = parseInt()
                call $parseIntValue
                local.set $tail
            end

            ;; currentNode.head = tail
            local.get $currentNode
            i32.const 5
            i32.add
            local.get $tail
            i32.store

            block
                loop
                    ;; while array8Get(currentLine, parsePosition) == ','
                    global.get $currentLine
                    global.get $parsePosition
                    call $array8Get
                    i32.const 44 ;; ','
                    i32.eq
                    i32.eqz
                    br_if 1

                    ;; skip ','
                    call $nextCh

                    global.get $currentLine
                    global.get $parsePosition
                    call $array8Get
                    i32.const 91 ;; '['
                    i32.eq
                    if
                        ;; newNode = parseList()
                        call $parseList
                        local.set $newNode
                    else
                        ;; newNode = parseInt()
                        call $parseIntValue
                        local.set $newNode
                    end

                    ;; tail.next = newNode
                    local.get $tail
                    i32.const 1
                    i32.add
                    local.get $newNode
                    i32.store

                    ;; tail = newNode
                    local.get $newNode
                    local.set $tail

                    br 0
                end
            end

        end

        ;; skip ']'
        call $nextCh

        ;; return currentNode
        local.get $currentNode
    )

    (func $listOf (param $value i32) (result i32)
        (local $valueNode i32)
        (local $listNode i32)

        ;; valueNode = malloc(nodeSize)
        global.get $nodeSize
        call $malloc
        local.set $valueNode

        ;; valueNode.isList = false
        local.get $valueNode
        i32.const 0
        i32.store8

        ;; valueNode.next = null
        local.get $valueNode
        i32.const 1
        i32.add
        i32.const 0
        i32.store

        ;; valueNode.value = value
        local.get $valueNode
        i32.const 9
        i32.add
        local.get $value
        i32.store

        ;; ---

        ;; listNode = malloc(nodeSize)
        global.get $nodeSize
        call $malloc
        local.set $listNode

        ;; listNode.isList = true
        local.get $listNode
        i32.const 1
        i32.store8

        ;; listNode.next = null
        local.get $listNode
        i32.const 1
        i32.add
        i32.const 0
        i32.store

        ;; listNode.head = valueNode
        local.get $listNode
        i32.const 5
        i32.add
        local.get $valueNode
        i32.store

        ;; return listNode
        local.get $listNode
    )

    (func $compareLists (param $leftList i32) (param $rightList i32) (result i32)
        (local $left i32)
        (local $right i32)
        (local $order i32)

        ;; i32.const 999999
        ;; call $println

        ;; local.get $leftList
        ;; call $printNode

        ;; local.get $rightList
        ;; call $printNode

        ;; left = leftList.head
        local.get $leftList
        i32.const 5
        i32.add
        i32.load
        local.set $left

        ;; right = rightList.head
        local.get $rightList
        i32.const 5
        i32.add
        i32.load
        local.set $right

        ;; order = 0
        i32.const 0
        local.set $order
        
        block
            loop
                ;; while order == 0 && left != null && right != null
                local.get $order
                i32.eqz
                local.get $left
                i32.const 0
                i32.ne
                local.get $right
                i32.const 0
                i32.ne
                i32.and
                i32.and

                i32.eqz
                br_if 1

                ;; order = compare(left, right)
                local.get $left
                local.get $right
                call $compare
                local.set $order

                ;; left = left.next
                local.get $left
                i32.const 1
                i32.add
                i32.load
                local.set $left

                ;; right = right.next
                local.get $right
                i32.const 1
                i32.add
                i32.load
                local.set $right

                br 0
            end
        end

        ;; if order == 0
        local.get $order
        i32.eqz
        if
            ;; if left == null && right != null
            local.get $left
            i32.eqz
            local.get $right
            i32.const 0
            i32.ne
            i32.and
            if
                ;; order = -1
                i32.const -1
                local.set $order
            end

            ;; if left != null && right == null
            local.get $left
            i32.const 0
            i32.ne
            local.get $right
            i32.eqz
            i32.and
            if
                ;; order = 1
                i32.const 1
                local.set $order
            end
        end

        ;; return order
        local.get $order
    )

    (func $compare (param $left i32) (param $right i32) (result i32)
        ;; if left.isList && right.isList
        local.get $left
        i32.load8_u
        local.get $right
        i32.load8_u
        i32.and
        if (result i32)
            ;; return compareLists(left, right)
            local.get $left
            local.get $right
            call $compareLists
        else
            ;; if !left.isList && !right.isList
            local.get $left
            i32.load8_u
            i32.eqz
            local.get $right
            i32.load8_u
            i32.eqz
            i32.and
            if (result i32)
                ;; return left.value - right.value
                local.get $left
                i32.const 9
                i32.add
                i32.load

                local.get $right
                i32.const 9
                i32.add
                i32.load

                i32.sub
            else
                ;; if left.isList && !right.isList
                local.get $left
                i32.load8_u
                local.get $right
                i32.load8_u
                i32.eqz
                i32.and
                if (result i32)
                    ;; return compareLists(left, listOf(right.value))
                    local.get $left
                    local.get $right
                    i32.const 9
                    i32.add
                    i32.load
                    call $listOf
                    call $compareLists
                else
                    ;; return compareLists(listOf(left.value), right)
                    local.get $left
                    i32.const 9
                    i32.add
                    i32.load
                    call $listOf
                    local.get $right
                    call $compareLists
                end
            end
        end
    )

    (func $main
        (local $i i32)
        (local $left i32)
        (local $right i32)
        (local $sum i32)

        ;; line = malloc(maxLine);
        global.get $maxLine
        call $malloc
        global.set $currentLine

        ;; i = 1
        i32.const 1
        local.set $i

        ;; sum = 0
        i32.const 0
        local.set $sum

        block
            loop
                ;; while !isEof()
                call $isEof
                br_if 1

                ;; readLine(currentLine)
                global.get $currentLine
                call $readLine

                ;; parseCurrentLine()
                call $parseCurrentLine
                local.set $left

                ;; readLine(currentLine)
                global.get $currentLine
                call $readLine

                ;; parseCurrentLine()
                call $parseCurrentLine
                local.set $right

                ;; if compare(left, right) < 0
                local.get $left
                local.get $right
                call $compare
                i32.const 0
                i32.lt_s
                if
                    ;; sum = sum + i
                    local.get $sum
                    local.get $i
                    i32.add
                    local.set $sum
                end

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                
                ;; if !isEof()
                call $isEof
                i32.eqz
                if
                    ;; skip empty line

                    ;; readLine(currentLine)
                    global.get $currentLine
                    call $readLine
                end
                
                br 0
            end
        end

        local.get $sum
        call $println
    )

    (export "main" (func $main))
)
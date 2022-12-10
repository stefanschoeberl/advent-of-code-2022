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
                call $arrayGet
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

    (func $arrayGet (param $array i32) (param $i i32) (result i32)
        local.get $array
        local.get $i
        i32.add
        i32.load8_u
    )

    (func $arraySet (param $array i32) (param $i i32) (param $value i32)
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
                call $arrayGet
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
                call $arrayGet
                i32.const 0
                i32.ne
                local.get $str
                local.get $i
                call $arrayGet
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
        call $arrayGet
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
                call $arrayGet
                i32.const 0
                i32.ne
                i32.eqz
                br_if 1

                ;; to[i] = from[i]
                local.get $to
                local.get $i

                local.get $from
                local.get $i
                call $arrayGet

                call $arraySet
                
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
                call $arrayGet
                i32.const 0
                i32.ne
                local.get $a
                local.get $i
                call $arrayGet
                i32.const 0
                i32.ne
                i32.and
                local.get $a
                local.get $i
                call $arrayGet
                local.get $b
                local.get $i
                call $arrayGet
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
        call $arrayGet
        local.get $b
        local.get $i
        call $arrayGet
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
                call $arrayGet

                call $arraySet
                
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
        call $arraySet
    )

    ;; struct fsnode {
    ;;    0  bool     isDirectory   1 byte
    ;;    1  char[]   name         20 byte (should be enough)
    ;;   21  int      size          4 byte
    ;;   25  fsnode * parent        4 byte
    ;;   29  fsnode * firstChild    4 byte
    ;;   33  fsnode * nextSibling   4 byte
    ;; }                           37 byte
    (global $fsNodeSize i32 (i32.const 37))

    (func $printTree (param $node i32) (param $indent i32)
        (local $i i32)
        (local $child i32)

        ;; i = 0
        i32.const 0
        local.set $i
        block
            loop
                ;; while i < indent
                local.get $i
                local.get $indent
                i32.lt_u
                i32.eqz
                br_if 1
                
                ;; printch(' ') x2
                i32.const 32 ;; ' '
                call $printch
                i32.const 32 ;; ' '
                call $printch

                ;; i = i + 1
                local.get $i
                i32.const 1
                i32.add
                local.set $i
                br 0
            end
        end
        ;; prints(node.name)
        local.get $node
        i32.const 1
        i32.add
        call $prints

        ;; if !node.isDirectory
        local.get $node
        i32.load8_u
        i32.eqz
        if
            ;; printch(' ')
            i32.const 32 ;; ' '
            call $printch
            ;; printch('(')
            i32.const 40 ;; '('
            call $printch
            
            ;; printi(node.size)
            local.get $node
            i32.const 21
            i32.add
            i32.load
            call $printi

            ;; printch(')')
            i32.const 41 ;; ')'
            call $printch
        end

        call $flush
        
        ;; child = node.firstChild
        local.get $node
        i32.const 29
        i32.add
        i32.load
        local.set $child
        block
            loop
                ;; while child != 0
                local.get $child
                i32.eqz
                br_if 1

                ;; printTree(child, indent + 1)
                local.get $child
                local.get $indent
                i32.const 1
                i32.add
                call $printTree

                ;; child = child.nextSibling
                local.get $child
                i32.const 33
                i32.add
                i32.load
                local.set $child
                br 0
            end
        end
    )

    (global $currentLine (mut i32) (i32.const 0))
    (global $rootNode (mut i32) (i32.const 0))
    (global $currentNode (mut i32) (i32.const 0))

    (func $processListingLine
        (local $newNode i32)
        (local $nameIndex i32)

        ;; newNode = malloc(fsNodeSize)
        global.get $fsNodeSize
        call $malloc
        local.set $newNode

        ;; newNode.parent = currentNode
        local.get $newNode
        i32.const 25
        i32.add
        global.get $currentNode
        i32.store

        ;; newNode.nextSibling = currentNode.firstChild
        local.get $newNode
        i32.const 33
        i32.add
        global.get $currentNode
        i32.const 29
        i32.add
        i32.load
        i32.store

        ;; currentNode.firstChild = newNode
        global.get $currentNode
        i32.const 29
        i32.add
        local.get $newNode
        i32.store

        ;; nameIndex = strIndexOf(currentLine, ' ') + 1
        global.get $currentLine
        i32.const 32 ;; ' '
        call $strIndexOf
        i32.const 1
        i32.add
        local.set $nameIndex

        ;; substring(currentLine, nameIndex, strlen(currentLine) - nameIndex, newNode.name)
        global.get $currentLine
        local.get $nameIndex
        global.get $currentLine
        call $strlen
        local.get $nameIndex
        i32.sub
        local.get $newNode
        i32.const 1 
        i32.add
        call $substring

        ;; if line[0] == 'd'
        global.get $currentLine
        i32.const 0
        call $arrayGet
        i32.const 100 ;; d
        i32.eq
        if
            ;; directory
            ;; newNode.isDirectory = true
            local.get $newNode
            i32.const 1
            i32.store8
        else
            ;; file
            ;; newNode.isDirectory = false
            local.get $newNode
            i32.const 0
            i32.store8

            ;; newNode.size = parseInt(currentLine, 0)
            local.get $newNode
            i32.const 21
            i32.add
            global.get $currentLine
            i32.const 0
            call $parseInt
            i32.store
        end
    )

    (global $currentName (mut i32) (i32.const 0))
    (func $processCommandLine
        (local $child i32)

        ;; if line[2] == 'c' (cd <...>)
        global.get $currentLine
        i32.const 2
        call $arrayGet
        i32.const 99 ;; c
        i32.eq
        if
            ;; if line[5] == '.' (cd ..)
            global.get $currentLine
            i32.const 5
            call $arrayGet
            i32.const 46 ;; .
            i32.eq
            if
                ;; currentNode = currentNode.parent
                global.get $currentNode
                i32.const 25
                i32.add
                i32.load
                global.set $currentNode
            else

                ;; child = currentNode.firstChild
                global.get $currentNode
                i32.const 29
                i32.add
                i32.load
                local.set $child

                ;; substring(currentLine, 5, strlen(currentLine) - 5, currentName)
                global.get $currentLine
                i32.const 5
                global.get $currentLine
                call $strlen
                i32.const 5
                i32.sub
                global.get $currentName
                call $substring
                block
                    loop
                        ;; local.get $child
                        ;; i32.const 1
                        ;; i32.add
                        ;; call $prints
                        ;; call $flush

                        ;; while child.name != currentName
                        local.get $child
                        i32.const 1
                        i32.add
                        global.get $currentName
                        call $stringEquals
                        br_if 1

                        ;; child = child.nextSibling
                        local.get $child
                        i32.const 33
                        i32.add
                        i32.load
                        local.set $child
                        br 0
                    end
                end

                local.get $child
                global.set $currentNode
            end
        end
    )

    (func $totalSize (param $node i32) (result i32)
        (local $size i32)
        (local $child i32)

        ;; size = 0
        i32.const 0
        local.set $size

        ;; if node.isDirectory
        local.get $node
        i32.load8_u
        if
            ;; child = node.firstChild
            local.get $node
            i32.const 29
            i32.add
            i32.load
            local.set $child

            block
                loop
                    ;; while child != 0
                    local.get $child
                    i32.eqz
                    br_if 1

                    ;; size = totalSize(child) + size
                    local.get $child
                    call $totalSize
                    local.get $size
                    i32.add
                    local.set $size

                    ;; child = child.nextSibling
                    local.get $child
                    i32.const 33
                    i32.add
                    i32.load
                    local.set $child
                    br 0
                end
            end
        else
            ;; size = node.size
            local.get $node
            i32.const 21
            i32.add
            i32.load
            local.set $size  
        end

        local.get $size
    )

    (global $totalSumOfSmallDirectories (mut i32) (i32.const 0))
    (func $sumSmallDirectories (param $node i32)
        (local $size i32)
        (local $child i32)

        ;; if node.isDirectory
        local.get $node
        i32.load8_u
        if
            ;; size = totalSize(node)
            local.get $node
            call $totalSize
            local.set $size

            ;; if size <= 100000
            local.get $size
            i32.const 100000
            i32.le_u
            if
                ;; totalSumOfSmallDirectories = totalSumOfSmallDirectories + size
                global.get $totalSumOfSmallDirectories
                local.get $size
                i32.add
                global.set $totalSumOfSmallDirectories
            end

            ;; child = node.firstChild
            local.get $node
            i32.const 29
            i32.add
            i32.load
            local.set $child

            block
                loop
                    ;; while child != 0
                    local.get $child
                    i32.eqz
                    br_if 1

                    ;; sumSmallDirectories(child)
                    local.get $child
                    call $sumSmallDirectories

                    ;; child = child.nextSibling
                    local.get $child
                    i32.const 33
                    i32.add
                    i32.load
                    local.set $child
                    br 0
                end
            end
        end
    )

    (global $minimumSizeToDelete (mut i32) (i32.const 0))
    (global $directorySizeToDelete (mut i32) (i32.const 0))
    (func $findDirectoryToDelete (param $node i32)
        (local $size i32)
        (local $child i32)

        ;; if node.isDirectory
        local.get $node
        i32.load8_u
        if
            ;; size = totalSize(node)
            local.get $node
            call $totalSize
            local.set $size

            ;; if size < directorySizeToDelete && size >= minimumSizeToDelete
            local.get $size
            global.get $directorySizeToDelete
            i32.lt_u
            local.get $size
            global.get $minimumSizeToDelete
            i32.ge_u
            i32.and
            if
                ;; directorySizeToDelete = size
                local.get $size
                global.set $directorySizeToDelete
            end

            ;; child = node.firstChild
            local.get $node
            i32.const 29
            i32.add
            i32.load
            local.set $child

            block
                loop
                    ;; while child != 0
                    local.get $child
                    i32.eqz
                    br_if 1

                    ;; findDirectoryToDelete(child)
                    local.get $child
                    call $findDirectoryToDelete

                    ;; child = child.nextSibling
                    local.get $child
                    i32.const 33
                    i32.add
                    i32.load
                    local.set $child
                    br 0
                end
            end
        end
    )

    (func $main
        ;; line = malloc(maxLine);
        global.get $maxLine
        call $malloc
        global.set $currentLine

        ;; currentName = malloc(maxLine);
        global.get $maxLine
        call $malloc
        global.set $currentName

        ;; skip first line (cd /)
        ;; readLine(line)
        global.get $currentLine
        call $readLine

        ;; currentNode = malloc(fsNodeSize)
        global.get $fsNodeSize
        call $malloc
        global.set $currentNode

        ;; rootNode = currentNode
        global.get $currentNode
        global.set $rootNode

        ;; currentNode.isDir = true
        global.get $currentNode
        i32.const 1
        i32.store8
        
        ;; substring(currentLine, 5, 1, currentNode.name)
        global.get $currentLine
        i32.const 5
        i32.const 1
        global.get $currentNode
        i32.const 1
        i32.add
        call $substring
        ;; currentNode.parent = 0
        global.get $currentNode
        i32.const 25
        i32.add
        i32.const 0
        i32.store
        ;; currentNode.firstChild = 0
        global.get $currentNode
        i32.const 29
        i32.add
        i32.const 0
        i32.store
        ;; currentNode.nextSibling = 0
        global.get $currentNode
        i32.const 33
        i32.add
        i32.const 0
        i32.store

        block
            loop
                ;; while !isEof()
                call $isEof
                br_if 1

                ;; readLine(line)
                global.get $currentLine
                call $readLine

                ;; if line[0] == '$'
                global.get $currentLine
                i32.const 0
                call $arrayGet
                i32.const 36 ;; $
                i32.eq
                if
                    call $processCommandLine
                else
                    call $processListingLine
                end

                br 0
            end
        end

        ;; part 1
        i32.const 0
        global.set $totalSumOfSmallDirectories

        global.get $rootNode
        call $sumSmallDirectories

        global.get $totalSumOfSmallDirectories
        call $println

        ;; part 2
        i32.const 70000000
        global.set $directorySizeToDelete

        global.get $rootNode
        call $totalSize
        i32.const 40000000
        i32.sub
        global.set $minimumSizeToDelete

        global.get $rootNode
        call $findDirectoryToDelete

        global.get $directorySizeToDelete
        call $println

        global.get $rootNode
        i32.const 0
        call $printTree
    )

    (export "main" (func $main))
)
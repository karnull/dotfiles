tmp=\$(mktemp)

\${EDITOR:-vi} \"\$tmp\"

{
    echo
    date \"+%d/%m/%y %H:%M\"
    echo

    awk '\''
    {
        gsub(/^[[:space:]]+|[[:space:]]+$/, \"\")

        if (\$0 == \"\") {
            if (!blank) {
                lines[++n] = \"\"
                blank = 1
            }
        } else {
            lines[++n] = \$0
            blank = 0
        }
    }

    END {
        start = 1
        while (start <= n && lines[start] == \"\")
            start++

        end = n
        while (end >= start && lines[end] == \"\")
            end--

        prev = \"\"

        for (i = start; i <= end; i++) {
            if (lines[i] == \"\") {
                print \"\"
            } else if (i == start || prev == \"\") {
                print \"  - \" lines[i]
            } else {
                print \"    \" lines[i]
            }
            prev = lines[i]
        }
    }
    '\'' \"\$tmp\"

    echo
} >> ~/.local/state/todo


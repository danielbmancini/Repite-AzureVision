#!/usr/bin/gawk -f
BEGIN {
    FS=":"
    OFS=""
}
    {
    # Comparar tempo com a função HH:MM -> HH*100 + MM (HHMM)
    timeValue = $1 * 100 + $2

    # Inicializar variaveis
    if (NR == 1) {
        line = sprintf("%02d:%02d", $1, $2)
        prevTime = timeValue
        next
    }

    # 00:00 representa FOLGA, conforme parse.sh
    if (timeValue == 0) {
        line = line "\nFOLGA\n"
        prevTime = timeValue
    } else {
        # Se este tempo é 'antes' ao tempo processado anteriormente
        if (timeValue < prevTime) {
           
            # Print the current line and start a new line
            print line > "fin4pontos.txt"
            line = sprintf("%02d:%02d", $1, $2)
        } else {
            sep = " "
             if (prevTime == 0)
                sep = ""
            # Append the current time to the existing line
            line = line sep sprintf("%02d:%02d", $1, $2)
        } 
        prevTime = timeValue

    }
}
END {
    # Print the last line if not empty
    NF > 0
    if (line != "") {
        print line > "fin4pontos.txt"
    }
}

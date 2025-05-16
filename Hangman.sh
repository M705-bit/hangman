#!/bin/bash
func_compara()
{
    caracter=$1
    string=$2 
    palavra_atual=$3
    nova_palavra=""
    count=0

    for ((i=0; i<${#string}; i++)); do
        c="${string:i:1}"
        a="${palavra_atual:i:1}"
        if [[ "$caracter" == "$c" ]]; then
            nova_palavra+="$c"
            ((count++))
        else
            nova_palavra+="$a"
        fi
    done

    if [[ $count -ne 0 ]]; then
        echo "$nova_palavra|$count"
	
    else
	echo "Essa letra não existe nesta palavra"
    fi
}

start=$(date +%s)
echo "O cronometro começou"

while true; do 

	timedout=0
	pontos=1
	PALAVRAS=$(find data1/ -type f -name "palavras.txt")  
	rows=$(wc -l < "$PALAVRAS")
	rnumber=$(( (RANDOM % rows) + 1))
	LETRAS=$(awk -v row="$rnumber" 'NR == row { print length($0); exit }' "$PALAVRAS")
	PALAVRA=$(awk -v row="$rnumber" 'NR == row { print $0 }' "$PALAVRAS")
	
	
	echo "O jogo começou!"

	
	echo "A palavra tem $LETRAS letras" 
	declare -a palavra_atual  
	palavra_atual=$(awk -v n=$LETRAS 'BEGIN { for (i=1;i<=n; i++) printf "_"; }')
	echo "$palavra_atual"
		while [[ "$palavra_atual" != "$PALAVRA" && $pontos -lt 5 ]]; do
	
			for ((i=0; i<(LETRAS-1); i++)); do
			       		
				read -p "Entre com uma letra: " letra
				read saida < <(func_compara "$letra" "$PALAVRA" "$palavra_atual")
				saida=$(func_compara "$letra" "$PALAVRA" "$palavra_atual")
				mensagem="${saida%%|*}"   # tudo antes do |
				count="${saida##*|}"      # tudo depois do |
				if [[ "$mensagem" == "Essa letra não existe nesta palavra" ]]; then
					if (( pontos < 5 )); then 
						((pontos++))
						echo "$mensagem"
					else 
						echo "Você perdeu!"
						now=$(date +%s)
	        				elapsed=$((now - start))
        					printf "\r Você Perdeu! Elapsed time: %02d:%02d:%02d" $((elapsed/3600)) $(( (elapsed/60)%60 )) $((elapsed%60)) > timed.log
        					sleep 1
						timedout=1
						break 
					fi
				else 
					
					palavra_atual="$mensagem"
					echo "$palavra_atual"

					 
					((i + count))


                		fi
				echo "$i"
       	        done
        	if [[ "$timedout" == 0 ]]; then
                	echo "Você venceu! A resposta era mesmo $PALAVRA"
			echo "$i"
                	timedout=1
			now=$(date +%s)
		        elapsed=$((now - start))
        		printf "\r Você venceu! Elapsed time: %02d:%02d:%02d" $((elapsed/3600)) $(( (elapsed/60)%60 )) $((elapsed%60)) > timed.log
        		sleep 1

        	fi

	done
	
done 

#!/bin/bash
func_compara()
{
    input_char=$1 #letra que user escrever 
    real_word=$2 #palavra real
    palavra_atual=$3 # a palavra atualmente 
    nova_palavra=""
    count=0

    for ((i=0; i<${#real_word}; i++)); do
        c="${real_word:i:1}"
        a="${palavra_atual:i:1}"
        if [[ "$input_char" == "$c" ]]; then
            nova_palavra+="$c"
            ((count++))
        else
            nova_palavra+="$a" 
        fi
    done

    if [[ $count -ne 0 ]]; then # se count not equal 0, ou seja a alternativa do user estava certa 
           echo "$nova_palavra|$count"

    else
        echo "Essa letra não existe nesta palavra"
    fi
}
#PALAVRAS=$(/usr/share/dict/words)
PALAVRAS=$(find . -type f -name "portuguese")  
rows=$(wc -l < "$PALAVRAS") 
contador=0  
timedout=0
pontos=1

#escolhe uma palavra aleatóriamente para o jogo
rnumber=$(( (RANDOM % rows) + 1)) #escolhe um número aleatório 
PALAVRA=$(awk -v row="$rnumber" 'NR == row { print $0 }' "$PALAVRAS")
nmr_de_letras=${#PALAVRA}

#inicia o jogo 
echo "O jogo começou!"
start=$(date +%s)
echo "O cronometro começou"
echo "A palavra tem $nmr_de_letras letras" 
declare -a palavra_atual  
palavra_atual=$(awk -v n=$nmr_de_letras 'BEGIN { for (i=1;i<=n; i++) printf "_"; }')
echo "$palavra_atual"

#seção na qual o user tem que tentar acertar a palavra
while [[ "$palavra_atual" != "$PALAVRA" && $pontos -lt 5 ]]; do

                                read -p "Entre com uma letra: " letra
                                #read saida < <(func_compara "$letra" "$PALAVRA" "$palavra_atual")
                                saida=$(func_compara "$letra" "$PALAVRA" "$palavra_atual")
                                mensagem="${saida%%|*}"   # tudo antes do |
                                count="${saida##*|}"      # tudo depois do |
                                if [[ "$mensagem" == "Essa letra não existe nesta palavra" ]]; then
                                         ((pontos++))
                                         echo "$mensagem"
                
                                else

                                        palavra_atual="$mensagem"
                                        echo "$palavra_atual"
                                fi
done
if [[ "$palavra_atual" == $PALAVRA ]]; then
       echo "Você venceu! A resposta era mesmo $PALAVRA"
       now=$(date +%s)
       elapsed=$((now - start))
       printf "\r Você venceu! Elapsed time: %02d:%02d:%02d" $((elapsed/3600)) $(( (elapsed/60)%60 )) $((elapsed%60)) > timed.log
       sleep 1
else 
	echo "Você perdeu! A resposta era $PALAVRA"
	now=$(date +%s)
        elapsed=$((now - start))
        printf "\r Você perdeu! Elapsed time: %02d:%02d:%02d" $((elapsed/3600)) $(( (elapsed/60)%60 )) $((elapsed%60)) > timed.log
        sleep 1

fi

                                                                                                                                                                                                                                                                                                                                                                                                           

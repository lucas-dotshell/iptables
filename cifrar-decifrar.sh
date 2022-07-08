#!/bin/sh
# @(#) cifrar-decifrar.sh - native secure script to encrypt and decrypt texts, without traces
setterm -foreground green
echo "################# github.com/lucas-dotshell ##################"
echo ""

echo "Press p/ 1 -> cifrar || 2 -> decifrar"
read OPTION
if [ ${OPTION} = 1 ]; then
  echo "Informe a sua chave de codificação"
  read KEY
fi
if [ ${OPTION} = 2 ]; then
  echo "Hora de mandar os dados p/ decodificar. Digite-os abaixo:"
  echo ""
  read DATATODECODE
fi

# End script
setterm -foreground white
echo "Fim da execução"

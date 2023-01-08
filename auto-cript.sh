#!/usr/bin/env bash

#GNU PRIVACY GUARD
#AUTOMATIZANDO CRIPTOGRAFIA GPG 
#ALGUMAS FUNÇOES IMPORTANTES DO PROGRAMA DE CRIPTOGRAFIA
#CRIADO POR LUCIANO RAMONE.
#PRIMEIRO PROJETO DE 2023

#CORES
verm="\033[31;1m"
verde="\033[32;1m"
lar="\033[33;1m"
azul="\033[34;1m"
roxo="\033[35;1m"
cor="\033[m"
#==============================================

#ROOT==========================================
(($UID > 0)) && { echo -e "${verm}ENTRE COM MODO ROOT!!! ${cor}" ; exit 1 ;}
#==============================================

#FUNÇÕES=======================================
function intro(){
cat <<EOF
GPG (GNU Privacy Guard) é uma ferramenta de criptografia de dados que permite aos usuários enviar e receber mensagens, arquivos e outros tipos de informação de forma segura.
Esse script é apenas uma automação do gpg, criado para acelerar processos e ajudar no dia-a-dia.
Criado por: R4m0n3
2023 (c)
EOF
}

function lista(){
echo -e "${verde}Listando chaves... ${cor}\n " ; sleep 2s

echo -e "${verde}Chaves Publicas:\n $(gpg --list-key) ${cor} \n"

echo -e "${verde}============================================== ${cor} "

echo -e "${roxo}Chaves Privadas:\n $(gpg -K) ${cor} "

}

function pub_key(){
echo -e "${azul}
Escolha tipo de chave ou padrão (default)
Escolha tamanho da chave max 4096, quanto maior a chave maior o tempo para gera-la.
Escolher o tempo de expiração se for 0 não expira.
Responder informações pessoais.
Nome e e-mail.
E comentário.
Confirmar tudo e criar uma senha forte.
Enquanto gera a chave mexer no terminal ou rodar comandos aleatórios para gerar entropia
${cor}"
sleep 2s

echo -e "${roxo}Iniciando...${cor}"

gpg --full-generate-key
}

function revoke(){
read -p "Arquivo de saida: " rev
read -p "Email ou Key-ID: " email1

gpg --output $rev --gen-revoke $email1
sleep 2s
echo -e "${azul}Certificado de revogação criado....\nCriptografe com chave simétrica preferencialmente e guarde.${cor}"
}

function expo-key(){
read -p "Nome do arquivo: " arq2
read -p "Email ou Key-ID: " email2

echo "Exportar de forma legivel?[Y/n]"
read yn
if [[ $yn == y ]]; then
   gpg --export --armor $email2 > $arq2.txt
    echo -e "${verde}Exportado com sucesso!${cor}}"
else
   gpg --export $email2 > $arq2.txt
    echo -e "${verde}Exportado com sucesso!${cor}}"
fi
}

function expo-privkey(){
read -p "Nome do arquivo: " arq3
read -p "Email ou Key-ID: " email3

echo "Exportar de forma legivel?[Y/n]"
read yn
if [[ $yn == y ]]; then
   gpg --export-secret-keys --armor $email3 > $arq3.txt
    echo -e "${verde}Exportado com sucesso!${cor}}"
else
   gpg --export-secret-keys $email3 > $arq3.txt
    echo -e "${verde}Exportado com sucesso!${cor}}"
fi
}

function crip-sym(){
echo -e "${azul}Digite o nome do arquivo em seguida a senha de sua criptografia...${cor}"

read -e -p "Arquivo: " arq4

gpg --symmetric $arq4

echo -e "${verde}Arquivo criptogrado com chave simétrica.${cor}"
}

function desc(){
read -e -p "Arquivo criptografado: " arq6
read -p "Arquivo de saida: " arq5

gpg --output $arq5 -d $arq6
sleep 1s

echo -e "${azul}Arquivo ${arq5} descriptografado com sucesso!!!${cor}"
}

function impo-key(){
read -p "Arquivo chave: " arq7
gpg --import $arq7

echo -e "${roxo}Chave importada com sucesso, escolha opção 2 no menu para checar a chave importada. ${cor}"
}

function conf(){
cat<<EOF
Alterar nivel de confiança de uma chave
Primeiro digite o email ou key-id da pessoa, depois abrira o modo editor
digite TRUST minusculo e escolha o nivel de 1 a 5 (5 é o maior nivel ULTIMATE)
quer dizer muito confiavel. Por fim digite SAVE minusculo.
EOF

read -p "Email OU KEY-ID: " email8
gpg --edit-key $email8

echo -e "${roxo}Nivel de confiança alterado com sucesso... para verificar alteração escolha opção 2 no menu. ${cor}"

}

function doc_create(){
echo "1) Criar documento assinado    2) Assinar arquivo existente"
read yynn

if [[ $yynn -eq 1 ]]; then
cat <<EOF
APOS DIGITAR O TEXTO APERTAR CTRL + D E DIGITAR A SENHA PARA FINALIZAR.

VAI GERAR UM ARQUIVO .ASC NESSE LOCAL COM O TEXTO E  ASSINATURA.
EOF

 read -p "Nome do arquivo assinado: " ascc
 gpg --clear-sign > $ascc.asc

else
 echo -e "Assinatura de arquivo existente, no final criara um arquivo .asc"

 read -e -p "Arquivo existente: " arq11
gpg --clear-sign $arq11
 sleep 1s
 echo -e "${azul}Arquivo assinado com sucesso!!${cor}"
fi

}

function ver_ass(){
cat <<EOF
Escolha o arquivo assinado para verificar
deve aparecer GOOD SIGNATURE para estar tudo ok com o arquivo.
se for BAD SIGNATURE foi alterado.
EOF

read -e -p "Arquivo assinado: " arq9
gpg --verify $arq9

}

function crip-assym(){
read -e -p "Arquivo a ser criptogrado: " arq10
read -p "Email ou KEY-ID: " email10
echo -e "${verde}Foi ultilizado a chave publica de ${email10} para encriptar ${cor}"

gpg --encrypt --recipient $email10 $arq10

echo -e "${verm}ARQUIVO COM EXTENSAO .GPG GERADO NESTE LOCAL.${cor}"

}

function help(){
cat <<EOF
FUNÇÃO AJUDA
EOF

}

#==============================================
if which gpg &>/dev/null; then
   echo -e "${verde}GPG encontrado!!! ${cor}"
   sleep 1s
   clear
else
   echo -e "${verm}GPG não instalado!${cor}"
   echo -e "${verde}Instalando...${cor}"
   apt install gpg
   clear
fi

intro
sleep 2s

#MENU==========================================
echo -e "${verm}
GNU PRIVACY GUARD -----------------------
1) Gerar chave pub
2) Listar chaves
3) Certificado de revogação
4) Exportar chave pub
5) Exportar chave priv
6) Criptografar (simetrica)
7) Desencriptar
8) Importar uma chave pub
9) Alterar confiança
10) Assinatura digital
11) Verificar uma assinatura
12) Criptografar arquivo (assimetrica)
13) Ajuda
0) Sair
-------------------------------------------${cor}
"
while :; do
echo " "
read -p "Opção: " menu

case $menu in
1) pub_key #CHAVE PUBLICA
;;

2) lista #LISTAGEM DE CHAVES IMPORTADAS/GERADAS
;;

3) revoke #CERTIFICADO DE REVOGAÇÃO
;;

4) expo-key #EXPORTAR CHAVE PUB
;;

5) expo-privkey #EXPORTAR CHAVE PRIV
;;

6) crip-sym #CRIPTOGRAFIA SIMETRICA
;;

7) desc #DESENCRIPTANDO
;;

8) impo-key #IMPORTAR CHAVE PUB
;;

9) conf #ALTERAR NIVEL DE CONFIANÇA
;;

10) doc_create #GERAR DOCUMENTO ASSINADO
;;

11) ver_ass #VERIFICAR ASSINATURA
;;

12) crip-assym #CRIPTOGRAFIA ASSIMÉTRICA
;;

13) help #AJUDA
;;

0) exit 0 
;;

*) echo -e "${verm}OPÇÃO INVALIDA!! ${cor}" ;;

esac
done
#==============================================

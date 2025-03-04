#!/bin/bash
clear

# Exibe mensagem inicial 
echo "Apresentando..."
sleep 2

# Limpa o terminal
#clear

# Função para exibir data e hora atual
show_current_time() {
    echo -e "Current Date and Time (UTC): $(date '+%Y-%m-%d %H:%M:%S')"
    echo
}

# Função para animação de digitação
type_text() {
    text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.05
    done
    echo
}

# Códigos de cores ANSI
blue="\e[34m"   # cor final: azul
reset="\e[0m"

# Vetor expandido com 15 cores em degradê
colors=(
    "\e[38;5;196m"  # Vermelho vivo
    "\e[38;5;202m"  # Laranja escuro
    "\e[38;5;208m"  # Laranja
    "\e[38;5;214m"  # Laranja claro
    "\e[38;5;220m"  # Amarelo
    "\e[38;5;226m"  # Amarelo brilhante
    "\e[38;5;190m"  # Verde-amarelado
    "\e[38;5;118m"  # Verde claro
    "\e[38;5;46m"   # Verde
    "\e[38;5;48m"   # Verde água
    "\e[38;5;51m"   # Ciano
    "\e[38;5;45m"   # Azul claro
    "\e[38;5;39m"   # Azul
    "\e[38;5;63m"   # Azul-violeta
    "\e[38;5;129m"  # Violeta
)

# Arte ASCII do DRL Edition
ascii_art=(
"██████╗ ██████╗  ██╗         ███████╗██████╗ ██╗████████╗██╗ ██████╗ ███╗   ██╗"
"██╔══██╗██╔══██╗ ██║         ██╔════╝██╔══██╗██║╚══██╔══╝██║██╔═══██╗████╗  ██║"
"██║  ██║██████╔╝ ██║         █████╗  ██║  ██║██║   ██║   ██║██║   ██║██╔██╗ ██║"
"██║  ██║██╔══██╗ ██║         ██╔══╝  ██║  ██║██║   ██║   ██║██║   ██║██║╚██╗██║"
"██████╔╝██║  ██║ ███████╗    ███████╗██████╔╝██║   ██║   ██║╚██████╔╝██║ ╚████║"
"╚═════╝ ╚═╝  ╚═╝ ╚══════╝    ╚══════╝╚═════╝ ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝"
)

# Animação da arte ASCII com efeito degradê
for ((k=0; k<3; k++)); do  # 3 ciclos completos
    for ((i=0; i<${#colors[@]}; i++)); do
        clear
        # Mostra data e hora 
        show_current_time
        
        # Mostra a arte ASCII na cor atual do degradê
        for line in "${ascii_art[@]}"; do
            echo -e "${colors[$i]}${line}${reset}"
        done
        sleep 0.1
    done
done

# Mostra a versão final em azul
clear
show_current_time
for line in "${ascii_art[@]}"; do
    echo -e "${blue}${line}${reset}"
done

# Pula uma linha
echo ""

# Mensagem final com animação de digitação
echo -ne "${PURPLE}"  # Cor roxa para a mensagem final
type_text "Obrigado por executar este script!"
type_text "Desenvolvido por DRLEdition19"
sleep 2
clear

# Mensagem de boas-vindas
echo "Seja bem vindo ao instalador automático do emulador de jogos J2me by DRL Edition."

# Diretório temporário para download
TEMP_DIR="/userdata/tmp/freej2me"
DRL_FILE="$TEMP_DIR/freej2me.zip"
DEST_DIR="/"

# Cria o diretório temporário
echo "Criando diretório temporário para download..."
mkdir -p $TEMP_DIR

# Faz o download do arquivo drl 
echo "Fazendo download do arquivo freej2me.drl..."
curl -L -o $DRL_FILE "https://github.com/DRLEdition19/J2me-Batocera/raw/refs/heads/master/Freej2me2/extra/freej2me.zip"

# Extrai o arquivo drl com barra de progresso e altera permissões de cada arquivo extraído
echo "Extraindo o arquivo drl e definindo permissões para cada arquivo..."
unzip -o $DRL_FILE -d $TEMP_DIR | while IFS= read -r file; do
    if [ -f "$TEMP_DIR/$file" ]; then
        chmod 777 "$TEMP_DIR/$file"
    fi
done

# Copia os arquivos extraídos para o diretório raiz, substituindo os existentes
echo "Copiando arquivos extraídos para o diretório raiz..."
cp -r $TEMP_DIR/* $DEST_DIR

# Cria links simbólicos
echo "Criando links simbólicos..."

# Função para criar link simbólico e substituir se já existir
create_symlink() {
    local target=$1
    local link=$2
    if [ -e "$link" ]; then
        echo "Substituindo link simbólico existente: $link"
        rm -f "$link"
    fi
    ln -s "$target" "$link"
}

create_symlink "/userdata/system/configs/bat-drl/AntiMicroX" "/opt/AntiMicroX"
create_symlink "/userdata/system/configs/bat-drl/AntiMicroX/antimicrox" "/usr/bin/antimicrox"
create_symlink "/userdata/system/configs/bat-drl/Freej2me" "/opt/Freej2me"
create_symlink "/userdata/system/configs/bat-drl/Freej2me/freej2me.jar" "/userdata/bios/freej2me.jar"
create_symlink "/userdata/system/configs/bat-drl/Freej2me/freej2me-lr.jar" "/userdata/bios/freej2me-lr.jar"
create_symlink "/userdata/system/configs/bat-drl/Freej2me/freej2me-sdl.jar" "/userdata/bios/freej2me-sdl.jar"

# Defina o caminho do arquivo
FILE="/usr/share/batocera/configgen/configgen-defaults.yml"

# Adicione o conteúdo desejado ao arquivo
#"echo -e "\nj2me:\n  emulator: libretro\n  core:     freej2me" >> $FILE"

# Verifique se as informações já estão no arquivo
if ! grep -q "j2me:" "$FILE"; then
    # Adicione o conteúdo desejado ao arquivo
    echo -e "\nj2me:\n  emulator: libretro\n  core:     freej2me" >> "$FILE"
    echo "Informações adicionadas ao arquivo."
else
    echo "As informações já existem no arquivo. Nenhuma alteração foi feita."
fi

# Define permissões para arquivos específicos
echo "Definindo permissões para arquivos específicos..."
chmod 777 /userdata/system/configs/bat-drl/Freej2me/freej2me.sh
chmod 777 /userdata/system/configs/bat-drl/Freej2me/freej2me2.sh
chmod 777 /userdata/system/configs/bat-drl/Freej2me/Update_j2me.sh
chmod 777 /userdata/system/configs/bat-drl/AntiMicroX/antimicrox
chmod 777 /userdata/system/configs/bat-drl/AntiMicroX/antimicrox.sh
chmod 777 /userdata/roms/ports/-Update_j2me.sh
chmod 777 $FILE
chmod 777 /usr
chmod 777 /usr/share
chmod 777 /usr/share/batocera
chmod 777 /usr/share/batocera/configgen

# Exclui o arquivo freej2me.zip do diretório raiz
echo "Excluindo o arquivo freej2me.zip do diretório raiz..."
rm -rf $TEMP_DIR/freej2me.zip
rm -rf /freej2me.zip

# Limpa o diretório temporário
echo "Limpando diretório temporário..."
rm -rf $TEMP_DIR

# Salva as alterações
echo "Salvando alterações..."
batocera-save-overlay

# Verifica se o diretório /userdata/system/pro/java existe
if [ -d "/userdata/system/configs/bat-drl/java" ]; then
    echo "O diretório /userdata/system/configs/bat-drl/java já existe. Finalizando o script."
    exit 0
fi

# Executa o script java.sh se o diretório /userdata/system/pro/java não existir
echo "Executando o script java.sh..."
curl -Ls https://github.com/DRLEdition19/J2me-Batocera/raw/master/java/java.sh | bash


# Salva as alterações
echo "Salvando alterações..."
chmod 777 /usr
chmod 777 /usr/bin
chmod 777 /usr/lib
batocera-save-overlay

echo "Instalação concluída com sucesso."

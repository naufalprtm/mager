#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' 

if ! command -v screen &> /dev/null
then
    echo -e "${RED}screen tidak terinstal. Silakan instal screen terlebih dahulu.${NC}"
    exit 1
fi

SESSION_PREFIX="worker"

show_device_info() {
    echo -e "${CYAN}Informasi Perangkat:${NC}"
    
    OS_INFO=$(uname -a)
    echo -e "${BLUE}Sistem Operasi:${NC} ${GREEN}$OS_INFO${NC}"

    CPU_INFO=$(lscpu | grep "Model name" | awk -F: '{print $2}')
    CPU_CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}') 
    echo -e "${BLUE}CPU:${NC} ${GREEN}$CPU_INFO${NC}"
    echo -e "${BLUE}Cores:${NC} ${GREEN}$CPU_CORES${NC}"
    echo -e "${BLUE}CPU Usage:${NC} ${GREEN}$CPU_USAGE%${NC}"
    
    TOTAL_RAM=$(free -m | awk '/^Mem:/{print $2}')  
    USED_RAM=$(free -m | awk '/^Mem:/{print $3}') 
    echo -e "${BLUE}RAM Usage:${NC} ${GREEN}${USED_RAM}MB / ${TOTAL_RAM}MB${NC}"
    
    DISK_INFO=$(df -h / | grep '/' | awk '{print $2, $3, $4, $5}')
    echo -e "${BLUE}Disk Usage (root):${NC} ${GREEN}$DISK_INFO${NC}"
    
    if command -v nvidia-smi &> /dev/null; then
        GPU_INFO=$(nvidia-smi --query-gpu=name,utilization.gpu --format=csv,noheader,nounits)
        echo -e "${BLUE}GPU Info:${NC} ${GREEN}$GPU_INFO${NC}"
    else
        echo -e "${YELLOW}GPU tidak terdeteksi atau driver NVIDIA tidak terinstal.${NC}"
    fi
}

start_workers() {
    if [[ ! -f "data.txt" ]]; then
        echo -e "${RED}File data.txt tidak ditemukan.${NC}"
        return
    fi

    WORKER_COUNT=$(wc -l < data.txt)
    echo -e "${CYAN}Jumlah pekerja yang akan dijalankan: $WORKER_COUNT${NC}"

    local i=1
    while IFS= read -r PHRASE; do
        SESSION_NAME="${SESSION_PREFIX}${i}"

        echo -e "${BLUE}Membuat sesi screen untuk: $SESSION_NAME${NC}"
        sudo screen -S "$SESSION_NAME" -dm
        if ! sudo screen -S "$SESSION_NAME" -p 0 -X stuff "node mine.js --fomo --chain=mainnet --phrase=$PHRASE\n"; then
            echo -e "${RED}Gagal menjalankan sesi $SESSION_NAME dengan frasa: $PHRASE.${NC}"
        else
            echo -e "${GREEN}Sesi $SESSION_NAME telah dimulai dengan frasa: $PHRASE${NC}"
        fi

        ((i++))
    done < data.txt
}

check_log() {
    echo -e "${BLUE}Daftar sesi screen yang berjalan:${NC}"
    sudo screen -ls
    read -p "Masukkan PID atau nama sesi (misal: PID.nama_sesi): " SESSION_NAME
    sudo screen -r "$SESSION_NAME"
}

stop_all() {
    echo -e "${YELLOW}Menghentikan semua sesi screen...${NC}"
    for i in $(seq 1 10); do
        SESSION_NAME="${SESSION_PREFIX}${i}"
        sudo screen -S "$SESSION_NAME" -X quit 2>/dev/null
        echo -e "${RED}Sesi $SESSION_NAME telah dihentikan.${NC}"
    done
}

while true; do
    show_device_info
    
    echo -e "${CYAN}Pilih opsi:${NC}"
    echo "1. Mulai pekerja"
    echo "2. Periksa log sesi"
    echo "3. Hentikan semua sesi"
    echo "4. Keluar"
    read -p "Masukkan pilihan (1, 2, 3, atau 4): " CHOICE

    case $CHOICE in
        1)
            start_workers
            ;;
        2)
            check_log
            ;;
        3)
            stop_all
            ;;
        4)
            echo -e "${GREEN}Keluar dari skrip.${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Pilihan tidak valid. Silakan pilih 1, 2, 3, atau 4.${NC}"
            ;;
    esac
done

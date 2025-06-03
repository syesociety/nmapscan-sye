#!/bin/bash

# Renkler
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
NC='\e[0m'

logdir="logs"
mkdir -p $logdir

clear
figlet "NMAP SYE TOOL" | lolcat
echo -e "${BLUE}Gelişmiş Nmap Tarayıcıya Hoş Geldiniz.${NC}"
sleep 1

while true; do
  echo ""
  echo -e "${YELLOW}Lütfen bir işlem seçin:${NC}"
  echo "1) Hızlı Tarama (T4 -F)"
  echo "2) Tam Port Taraması (-p- -T4)"
  echo "3) Zafiyet Taraması (--script vuln)"
  echo "4) OS Tespiti (-O)"
  echo "5) Versiyon Taraması (-sV)"
  echo "6) Ping Scan (-sn)"
  echo "7) UDP Taraması (-sU)"
  echo "8) Belirli Port Taraması (-p 80,443)"
  echo "9) Aggressive Scan (-A)"
  echo "10) Script Scan (--script default)"
  echo "11) Canlılık Kontrolü (ping)"
  echo "12) Hepsi Bir Arada (Ağır Tarama)"
  echo "13) Çıkış"
  echo ""

  read -p "Seçiminiz (1-13): " secim

  if [[ "$secim" -ge 1 && "$secim" -le 12 ]]; then
    read -p "Hedef IP veya domain: " hedef
    timestamp=$(date +%Y%m%d_%H%M%S)
    outfile="${logdir}/nmap_${hedef//./_}_$timestamp.txt"
  fi

  case $secim in
    1) nmap -T4 -F $hedef | tee $outfile ;; 
    2) nmap -p- -T4 $hedef | tee $outfile ;;
    3) nmap --script vuln $hedef | tee $outfile ;; 
    4) nmap -O $hedef | tee $outfile ;; 
    5) nmap -sV $hedef | tee $outfile ;; 
    6) nmap -sn $hedef | tee $outfile ;; 
    7) nmap -sU $hedef | tee $outfile ;; 
    8) read -p "Portlar (örn: 21,22): " portlar; nmap -p $portlar $hedef | tee $outfile ;; 
    9) nmap -A $hedef | tee $outfile ;; 
    10) nmap --script default $hedef | tee $outfile ;; 
    11) ping -c 4 $hedef | tee $outfile ;; 
    12) nmap -A -sV -O -p- $hedef | tee $outfile ;; 
    13) echo -e "${GREEN}Çıkılıyor...${NC}"; exit ;; 
    *) echo -e "${RED}Geçersiz seçim!${NC}" ;;
  esac

  echo -e "${YELLOW}Log dosyası: ${outfile}${NC}"
  read -p "Devam için Enter..."
  clear
  figlet "NMAP SYE TOOL" | lolcat
done

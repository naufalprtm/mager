# mager

skip if this is already done

    git clone https://github.com/suidouble/sui_meta_miner.git
    cd sui_meta_miner
    npm install
    
then download this

    wget https://raw.githubusercontent.com/naufalprtm/mager/main/kamu-diam.sh
    wget https://raw.githubusercontent.com/naufalprtm/mager/main/data.txt
or

    curl -O https://raw.githubusercontent.com/naufalprtm/mager/main/kamu-diam.sh
    curl -O https://raw.githubusercontent.com/naufalprtm/mager/main/data.txt


# Usage
- `access`
```
chmod +x kamu-diam.sh
```
- `Edit data.txt`

```
    "suiprivkeyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    "suiprivkeyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    "suiprivkeyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    "suiprivkeyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    "suiprivkeyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    "suiprivkeyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```
### note if there are 2 wallets then add them to 3 lines
example:
```
    "suiprivkeyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"line1
    "suiprivkeyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"line1
    "blank"line3
```



- `run`

```
    ./kamu-diam.sh
```


# Options


### - `1. Mulai pekerja/Start worker`
start all workers automatically based on the number of phases in data.txt
if there are 10 then it will run 10
#### "IMPORTANT"
before starting many workers, go to the file
/includes/NonceFinder.js
find this variable and adjust it to your device

    change this._workersCount = 8; #Default, Change this


### - `2. Periksa log sesi/Check session log`
example:

        There are screens on:
                140417.worker6  (10/05/24 03:40:41)     (Detached)
                140393.worker5  (10/05/24 03:40:41)     (Detached)
                140369.worker4  (10/05/24 03:40:41)     (Detached)
                140345.worker3  (10/05/24 03:40:41)     (Detached)
                140325.worker2  (10/05/24 03:40:41)     (Detached)
                140306.worker1  (10/05/24 03:40:41)     (Detached)

Masukkan PID atau nama sesi (misal: PID.nama_sesi):
Enter the PID or session name (e.g. PID.session_name):

input

    140306.worker1

return? ctrl a+d


### - `3. Hentikan semua sesi/Stop all sessions`
- 
  "IMPORTANT"
This will exit all sessions on the screen, you can change or add the script. or do it manually

      screen -X -S <session-name> quit
      screen -X -S 140369.worker4 quit

```
stop_all() {
    echo -e "${YELLOW}Menghentikan semua sesi screen...${NC}"
    for i in $(seq 1 10); do
        SESSION_NAME="${SESSION_PREFIX}${i}"
        sudo screen -S "$SESSION_NAME" -X quit 2>/dev/null
        echo -e "${RED}Sesi $SESSION_NAME telah dihentikan.${NC}"
    done
}
```
### - `4. Keluar/exit`















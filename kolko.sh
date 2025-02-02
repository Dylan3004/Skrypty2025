
board=(0 1 2 3 4 5 6 7 8)

# Zmienna określająca, kto zaczyna grę: 1 - gracz 1, 2 - gracz 2
starting_player=1
# Zmienna określająca tryb gry: 0 - gra z komputerem, 1 - gra dla dwóch graczy
game_mode=1
# Zmienna określająca obecnego gracza
current_player="X"

display_infoboard() {
    local infoboard=(0 1 2 3 4 5 6 7 8)
    echo "-------------"
    echo "| ${infoboard[0]} | ${infoboard[1]} | ${infoboard[2]} |"
    echo "-------------"
    echo "| ${infoboard[3]} | ${infoboard[4]} | ${infoboard[5]} |"
    echo "-------------"
    echo "| ${infoboard[6]} | ${infoboard[7]} | ${infoboard[8]} |"
    echo "-------------"
}

game_check() {
    combinations=(
        "0 1 2"
        "3 4 5"
        "6 7 8"
        "0 3 6"
        "1 4 7"
        "2 5 8"
        "0 4 8"
        "2 4 6"
    )

    for combination in "${combinations[@]}"; do
        set -- $combination
        if [[ "${board[$1]}" == "${board[$2]}" && "${board[$1]}" == "${board[$3]}" && "${board[$1]}" =~ [XO] ]]; then
            echo "Gratulacje! Gracz ${board[$1]} wygrał!"
            return 1
        fi
    done

    for i in "${board[@]}"; do
        if [[ "$i" =~ ^[0-8]$ ]]; then
            return 2
        fi
    done

    echo "Gra zakończona remisem!"
    return 0
}

display_board() {
    echo "-------------"
    echo "| ${board[0]} | ${board[1]} | ${board[2]} |"
    echo "-------------"
    echo "| ${board[3]} | ${board[4]} | ${board[5]} |"
    echo "-------------"
    echo "| ${board[6]} | ${board[7]} | ${board[8]} |"
    echo "-------------"
}

save_game() {
    echo "Zapisuje grę do pliku..."
    echo "$starting_player   $game_mode   $current_player   ${board[@]}" > game_save.txt
    echo "Gra zapisana!"
}

reload_game() {
    echo "Wczytuję poprzedni zapis..."

    if [[ -f game_save.txt ]]; then
        read -r game_data < game_save.txt
        IFS='   ' read -r starting_player game_mode current_player board_str <<< "$game_data"
        IFS=' ' read -r -a board <<< "$board_str"

        echo "Gra wczytana pomyślnie!"
        display_board

        if [[ "$game_mode" == "1" ]]; then
            two_player_game_continue "$current_player"
        elif [[ "$game_mode" == "2" ]]; then
            SI_game_continue "$current_player"
        else
            echo "Nieznany tryb gry w zapisie."
        fi
    else
        echo "Brak zapisanego stanu gry."
    fi
}

# Gra dla dwóch graczy (nowa gra)
two_player_game() {
    echo "Rozpoczynam nową grę dla dwóch graczy!"
    board=(0 1 2 3 4 5 6 7 8)
    starting_player=1
    game_mode=1
    current_player="X"
    two_player_game_continue "$current_player"
}

# Gra dla dwóch graczy (kontynuacja)
two_player_game_continue() {
    local current_player="$1"

    while true; do
        if [[ "$current_player" == "X" ]]; then
            while true; do
                echo "Gracz 1 (X): wybierz pole do zagrania (0-8)"
                display_board
                read ruch

                if [[ "$ruch" == "save" ]]; then
                    save_game
                    return
                fi

                if [[ "$ruch" =~ ^[0-8]$ && "${board[$ruch]}" =~ ^[0-8]$ ]]; then
                    board[$ruch]="X"
                    current_player="O"
                    break
                else
                    echo "Pole $ruch jest już zajęte lub nieprawidłowe. Wybierz inne."
                fi
            done
        else
            while true; do
                echo "Gracz 2 (O): wybierz pole do zagrania (0-8)"
                display_board
                read ruch

                if [[ "$ruch" == "save" ]]; then
                    save_game
                    return
                fi

                if [[ "$ruch" =~ ^[0-8]$ && "${board[$ruch]}" =~ ^[0-8]$ ]]; then
                    board[$ruch]="O"
                    current_player="X"
                    break
                else
                    echo "Pole $ruch jest już zajęte lub nieprawidłowe. Wybierz inne."
                fi
            done
        fi

        display_board
        game_check
        if [[ $? -ne 2 ]]; then
            break
        fi
    done
}

# Gra przeciwko komputerowi (nowa gra)
SI_game() {
    echo "Rozpoczynam nową grę przeciwko komputerowi!"
    board=(0 1 2 3 4 5 6 7 8)
    starting_player=1
    game_mode=2
    current_player="X"
    SI_game_continue "$current_player"
}

# Gra przeciwko komputerowi (kontynuacja)
SI_game_continue() {
    local current_player="$1"

    while true; do
        if [[ "$current_player" == "X" ]]; then
            while true; do
                echo "Gracz 1 (X): wybierz pole do zagrania (0-8)"
                display_board
                read ruch

                if [[ "$ruch" == "save" ]]; then
                    save_game
                    return
                fi

                if [[ "$ruch" =~ ^[0-8]$ && "${board[$ruch]}" =~ ^[0-8]$ ]]; then
                    board[$ruch]="X"
                    current_player="O"
                    break
                else
                    echo "Pole $ruch jest już zajęte lub nieprawidłowe. Wybierz inne."
                fi
            done
        else
            echo "Komputer wykonuje ruch..."
            while true; do
                local komputer_ruch=$((RANDOM % 9))
                if [[ "${board[$komputer_ruch]}" =~ ^[0-8]$ ]]; then
                    board[$komputer_ruch]="O"
                    current_player="X"
                    echo "Komputer wybrał pole $komputer_ruch."
                    break
                fi
            done
        fi

        display_board
        game_check
        if [[ $? -ne 2 ]]; then
            break
        fi
    done
}

# Gra w kółko i krzyżyk
echo "Kółko i krzyżyk"
echo "1. Rozpocznij grę - dwie osoby"
echo "2. Wczytaj poprzedni zapis"
echo "3. Zacznij grać z komputerem"

read opcja
case $opcja in
    1)
        two_player_game
        ;;
    2)
        reload_game
        ;;
    3)
        SI_game
        ;;
    *)
        echo "Nieprawidłowy wybór!"
        ;;
esac

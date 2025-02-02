-- Wymiary planszy
local board_width = 15
local board_height = 20
local cell_size = 30

-- Kolory
local colors = {
    {0.8, 0.1, 0.1},
    {0.1, 0.8, 0.1},
    {0.1, 0.1, 0.8},
    {0.8, 0.8, 0.1},
    {0.8, 0.1, 0.8},
    {0.1, 0.8, 0.8},
    {0.5, 0.5, 0.5},
}

-- Kształty tetromino
local tetrominos = {
    {{0, 1, 0}, {1, 1, 1}}, -- T
    {{1, 1}, {1, 1}},       -- O
    {{1, 1, 1, 1}},         -- I
    {{0, 1, 1}, {1, 1, 0}}, -- Z
    {{1, 1, 0}, {0, 1, 1}}, -- S
    {{1, 1, 1}, {1, 0, 0}}, -- L
    {{1, 1, 1}, {0, 0, 1}}, -- J
}

-- Stan gry
local board = {}
local current_tetromino
local current_x, current_y
local timer = 0
local drop_time = 0.5

-- Inicjalizacja planszy
local function initialize_board()
    for y = 1, board_height do
        board[y] = {}
        for x = 1, board_width do
            board[y][x] = 0
        end
    end
end

-- Generowanie nowego tetromino
local function spawn_tetromino()
    current_tetromino = tetrominos[math.random(#tetrominos)] -- Losowy kształt
    current_x = math.floor(board_width / 2) - math.floor(#current_tetromino[1] / 2) -- Miejsce startowe
    current_y = 1
end

-- Sprawdzenie kolizji
local function check_collision(x_offset, y_offset, shape)
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] ~= 0 then -- Sprawdzenie niepustego bloku
                local new_x = current_x + x + x_offset - 1
                local new_y = current_y + y + y_offset - 1
                if new_x < 1 or new_x > board_width or new_y > board_height or (new_y > 0 and board[new_y][new_x] ~= 0) then -- Sprawdzenie kolizji
                    return true
                end
            end
        end
    end
    return false -- Brak kolizji
end

-- Zablokowanie tetromino na planszy
local function lock_tetromino()
    for y = 1, #current_tetromino do
        for x = 1, #current_tetromino[y] do
            if current_tetromino[y][x] ~= 0 then -- Sprawdzenie niepustego bloku
                board[current_y + y - 1][current_x + x - 1] = current_tetromino[y][x]
            end
        end
    end
end

-- Czyszczenie pełnych linii
local function clear_lines()
    for y = board_height, 1, -1 do -- Przeglądanie planszy w dół
        local full = true
        for x = 1, board_width do  -- Sprawdzenie całego wiersza
            if board[y][x] == 0 then
                full = false
                break
            end
        end
        if full then 
            table.remove(board, y)
            table.insert(board, 1, {}) -- Usunięcie z planszy
            for x = 1, board_width do  -- Usunięcie z tabeli
                board[1][x] = 0
            end
        end
    end
end

-- Obrót tetromino
local function rotate_tetromino()
    local new_tetromino = {}
    for x = 1, #current_tetromino[1] do
        new_tetromino[x] = {}
        for y = #current_tetromino, 1, -1 do
            new_tetromino[x][#current_tetromino - y + 1] = current_tetromino[y][x] -- Obrót klocka
        end
    end
    if not check_collision(0, 0, new_tetromino) then -- Sprawdzenie kolizji
        current_tetromino = new_tetromino  -- Zastosowanie obrotu
    end
end

-- Funkcje Love2D
function love.load()
    math.randomseed(os.time())
    love.window.setMode(board_width * cell_size, board_height * cell_size)
    initialize_board()
    spawn_tetromino() -- Inicjalizacja gry
end

function love.update(dt)
    timer = timer + dt
    if timer >= drop_time then
        timer = 0
        if not check_collision(0, 1, current_tetromino) then -- Przesunięcie w dół
            current_y = current_y + 1
        else -- Zatrzymanie
            lock_tetromino()
            clear_lines()
            spawn_tetromino()
            if check_collision(0, 0, current_tetromino) then
                initialize_board() -- Koniec gry
            end
        end
    end
end

function love.draw()
    -- Rysowanie planszy
    for y = 1, board_height do
        for x = 1, board_width do
            if board[y][x] ~= 0 then
                love.graphics.setColor(colors[board[y][x]])
                love.graphics.rectangle("fill", (x - 1) * cell_size, (y - 1) * cell_size, cell_size, cell_size) -- Rysowanie planszy
            end
        end
    end

    -- Rysowanie aktualnego tetromino
    for y = 1, #current_tetromino do
        for x = 1, #current_tetromino[y] do
            if current_tetromino[y][x] ~= 0 then
                love.graphics.setColor(colors[current_tetromino[y][x]])
                love.graphics.rectangle("fill", (current_x + x - 2) * cell_size, (current_y + y - 2) * cell_size, cell_size, cell_size)  -- Rysowanie klocka
            end
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
    if key == "left" and not check_collision(-1, 0, current_tetromino) then -- Ruch w lewo
        current_x = current_x - 1
    elseif key == "right" and not check_collision(1, 0, current_tetromino) then -- Ruch w prawo
        current_x = current_x + 1
    elseif key == "down" and not check_collision(0, 1, current_tetromino) then -- Szybszy opad
        current_y = current_y + 1
    elseif key == "up" then
        rotate_tetromino() -- Obrót
    end
end

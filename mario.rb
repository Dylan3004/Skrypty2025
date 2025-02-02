require 'ruby2d'

# Ustawienia okna
set title: "Mario Game", width: 800, height: 600, background: 'lightblue'

# Tworzenie obiektów
class Player
  attr_accessor :x, :y, :width, :height

  def initialize
    @x = 50
    @y = 500
    @width = 40
    @height = 40
    @velocity_y = 0
    @on_ground = false
    @shape = Square.new(x: @x, y: @y, size: @width, color: 'red')
    @falling = false # Zmienna do animacji spadania
  end

  def update(platforms)
    @velocity_y += 1 unless @on_ground # grawitacja
    @y += @velocity_y

    # Sprawdzanie kolizji z podłożem
    @on_ground = false
    platforms.each do |platform|
      if collides_with?(platform)
        @y = platform[:y] - @height
        @on_ground = true
        @velocity_y = 0
      end
    end

    # Aktualizacja pozycji gracza
    @shape.x = @x
    @shape.y = @y
  end

  def jump
    @velocity_y = -15 if @on_ground
  end

  def move_left
    @x -= 5
  end

  def move_right
    @x += 5
  end

  def collides_with?(platform)
    @x < platform[:x] + platform[:width] &&
    @x + @width > platform[:x] &&
    @y < platform[:y] + platform[:height] &&
    @y + @height > platform[:y]
  end

  # Funkcja zmieniająca stan gracza, gdy wpada do dziury
  def fall_effect
    @falling = true
    @shape.color = 'blue' # Ciemniejszy odcień czerwonego
  end

  # Funkcja resetująca efekt spadania
  def reset_fall_effect
    @falling = false
    @shape.color = 'red' # Przywrócenie pierwotnego koloru
  end
end

# Tworzenie poziomu
platforms = [
  { x: 0, y: 560, width: 200, height: 40 },
  { x: 300, y: 560, width: 250, height: 40 },
  { x: 650, y: 560, width: 150, height: 40 },
  { x: 150, y: 400, width: 100, height: 20 },
  { x: 300, y: 300, width: 100, height: 20 },
  { x: 500, y: 200, width: 100, height: 20 },
  { x: 700, y: 500, width: 100, height: 20 }
]

platform_shapes = platforms.map do |platform|
  Rectangle.new(x: platform[:x], y: platform[:y], width: platform[:width], height: platform[:height], color: 'green')
end

# Tworzenie dziur
danger_zones = [
  { x: 200, y: 560, width: 100, height: 40 },
  { x: 550, y: 560, width: 100, height: 40 }
]

danger_shapes = danger_zones.map do |danger|
  Rectangle.new(x: danger[:x], y: danger[:y], width: danger[:width], height: danger[:height], color: 'black')
end

# Funkcja sprawdzająca, czy gracz wpada do dziury
def player_in_hole?(player, danger_zones)
  danger_zones.any? do |danger|
    player.x < danger[:x] + danger[:width] &&
    player.x + player.width > danger[:x] &&
    player.y + player.height >= danger[:y]
  end
end

# Inicjalizacja gracza
game_over = false
player = Player.new

keys_held = {}

# Rejestracja przytrzymanych klawiszy
on :key_down do |event|
  keys_held[event.key] = true
  player.jump if event.key == 'space'
end

on :key_up do |event|
  keys_held.delete(event.key)
end

# Główna pętla gry
update do
  unless game_over
    player.move_left if keys_held['left']
    player.move_right if keys_held['right']
    player.update(platforms)

    # Sprawdzanie, czy gracz wpada do dziury
    if player_in_hole?(player, danger_zones)
      player.fall_effect
      game_over = true
    end

    # Sprawdzanie, czy gracz spadł poza ekran
    game_over = true if player.y > Window.height
  end

  if game_over
    Text.new("Game Over!", x: 300, y: 250, size: 40, color: 'black')
  end
end

show

import random
import sys
import pygame

# Инициализация Pygame
pygame.init()

# Настройки окна и сетки
WIDTH, HEIGHT = 600, 400
GRID_SIZE = 20  # Размер одной ячейки (и змейки, и еды)
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Мини-игра: Змейка")

# Цвета (RGB)
BLACK = (20, 20, 20)
GREEN = (50, 205, 50)
RED = (230, 50, 50)
WHITE = (255, 255, 255)

# Часы для контроля скорости (FPS)
clock = pygame.time.Clock()
font = pygame.font.SysFont("arial", 24)


class Snake:

    def __init__(self):
        # Начальная позиция змейки (центр экрана)
        self.body = [(100, 100), (80, 100), (60, 100)]
        self.direction = (GRID_SIZE, 0)  # Движемся вправо

    def move(self):
        # Вычисляем новую позицию головы
        head_x, head_y = self.body[0]
        dir_x, dir_y = self.direction
        new_head = (head_x + dir_x, head_y + dir_y)

        # Вставляем новую голову в начало списка
        self.body.insert(0, new_head)
        # Удаляем хвост (если змейка не съела еду, хвост удаляется в логике игры)
        self.body.pop()

    def change_direction(self, new_dir):
        # Запрещаем поворот на 180 градусов (например, влево, если ползли вправо)
        if (new_dir[0] * -1, new_dir[1] * -1) != self.direction:
            self.direction = new_dir

    def draw(self, surface):
        for segment in self.body:
            rect = pygame.Rect(segment[0], segment[1], GRID_SIZE, GRID_SIZE)
            pygame.draw.rect(surface, GREEN, rect)


class Food:

    def __init__(self):
        self.position = (0, 0)
        self.respawn()

    def respawn(self):
        # Помещаем еду в случайную ячейку сетки
        x = random.randint(0, (WIDTH - GRID_SIZE) // GRID_SIZE) * GRID_SIZE
        y = random.randint(0, (HEIGHT - GRID_SIZE) // GRID_SIZE) * GRID_SIZE
        self.position = (x, y)

    def draw(self, surface):
        rect = pygame.Rect(
            self.position[0], self.position[1], GRID_SIZE, GRID_SIZE
        )
        pygame.draw.rect(surface, RED, rect)


# Создаем объекты
snake = Snake()
food = Food()
score = 0

# Главный игровой цикл
running = True
while running:
    # 1. Обработка нажатий клавиш
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP:
                snake.change_direction((0, -GRID_SIZE))
            elif event.key == pygame.K_DOWN:
                snake.change_direction((0, GRID_SIZE))
            elif event.key == pygame.K_LEFT:
                snake.change_direction((-GRID_SIZE, 0))
            elif event.key == pygame.K_RIGHT:
                snake.change_direction((GRID_SIZE, 0))

    # 2. Логика движения
    snake.move()
    head_x, head_y = snake.body[0]

    # Проверка: съела ли змейка еду?
    if snake.body[0] == food.position:
        snake.body.append(snake.body[-1])  # Увеличиваем хвост
        food.respawn()
        score += 10

    # Проверка: врезалась ли в стену?
    if head_x < 0 or head_x >= WIDTH or head_y < 0 or head_y >= HEIGHT:
        print(f"Игра окончена! Ваши очки: {score}")
        running = False

    # Проверка: врезалась ли в себя?
    if snake.body[0] in snake.body[1:]:
        print(f"Игра окончена! Ваши очки: {score}")
        running = False

    # 3. Отрисовка кадра
    screen.fill(BLACK)
    snake.draw(screen)
    food.draw(screen)

    # Вывод счета на экран
    score_text = font.render(f"Очки: {score}", True, WHITE)
    screen.blit(score_text, (10, 10))

    pygame.display.flip()

    # Скорость игры (чем больше число, тем быстрее змейка)
    clock.tick(10)

pygame.quit()
sys.exit()
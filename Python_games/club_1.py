import sys
import pygame

pygame.init()

WIDTH, HEIGHT = 800, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Клуб: Прогулка и Общение")

# Цвета
BG_COLOR = (25, 20, 35)
PLAYER_COLOR = (50, 150, 255)
UI_BG = (40, 35, 55)
WHITE = (240, 240, 240)
YELLOW = (255, 220, 100)

clock = pygame.time.Clock()
font = pygame.font.SysFont("arial", 20)
dialog_font = pygame.font.SysFont("arial", 22)


class Player:
    """Класс игрока, которым мы управляем"""

    def __init__(self, x, y):
        self.rect = pygame.Rect(x, y, 24, 24)
        self.speed = 4

    def move(self, keys):
        if (keys[pygame.K_LEFT] or keys[pygame.K_a]) and self.rect.left > 0:
            self.rect.x -= self.speed
        if (
            keys[pygame.K_RIGHT] or keys[pygame.K_d]
        ) and self.rect.right < WIDTH:
            self.rect.x += self.speed
        if (keys[pygame.K_UP] or keys[pygame.K_w]) and self.rect.top > 0:
            self.rect.y -= self.speed
        if (
            keys[pygame.K_DOWN] or keys[pygame.K_s]
        ) and self.rect.bottom < HEIGHT:
            self.rect.y += self.speed

    def draw(self, surface):
        pygame.draw.rect(surface, PLAYER_COLOR, self.rect, border_radius=4)


class NPC:
    """Класс людей в клубе, с которыми можно заговорить"""

    def __init__(self, name, x, y, color, dialogs):
        self.name = name
        self.rect = pygame.Rect(x, y, 24, 24)
        self.color = color
        self.dialogs = dialogs  # Список реплик
        self.dialog_index = 0

    def get_current_dialog(self):
        """Возвращает текущую реплику и переключает на следующую"""
        text = self.dialogs[self.dialog_index]
        self.dialog_index = (self.dialog_index + 1) % len(self.dialogs)
        return text

    def draw(self, surface):
        pygame.draw.rect(surface, self.color, self.rect, border_radius=4)
        # Подпись имени над персонажем
        name_surf = font.render(self.name, True, WHITE)
        surface.blit(name_surf, (self.rect.x - 10, self.rect.y - 22))


# Создаем игрока и людей вокруг
player = Player(400, 500)

npcs = [
    NPC(
        "Диджей",
        400,
        100,
        (255, 50, 100),
        [
            "Диджей: Эй! Вышел новый трек, оценил?",
            "Диджей: Не отвлекай, я выбираю следующий сет!",
        ],
    ),
    NPC(
        "Бармен",
        150,
        250,
        (255, 200, 50),
        [
            "Бармен: Налить тебе сока или воды?",
            "Бармен: Сегодня отличная вечеринка!",
        ],
    ),
    NPC(
        "Охранник",
        650,
        450,
        (100, 100, 120),
        [
            "Охранник: Соблюдай порядок в клубе.",
            "Охранник: Никаких драка и скандалов!",
        ],
    ),
]

active_dialog = None  # Текст диалога, если мы с кем-то говорим
active_speaker = ""  # Имя того, с кем говорим

running = True
while running:
    keys = pygame.key.get_pressed()

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        elif event.type == pygame.KEYDOWN:
            # Нажмите ПРОБЕЛ, чтобы начать или продолжить разговор
            if event.key == pygame.K_SPACE:
                # Ищем NPC поблизости (рядом с игроком)
                near_npc = None
                for npc in npcs:
                    # Создаем увеличенную зону вокруг NPC для проверки близости
                    talk_zone = npc.rect.inflate(30, 30)
                    if talk_zone.colliderect(player.rect):
                        near_npc = npc
                        break

                if near_npc:
                    active_speaker = near_npc.name
                    active_dialog = near_npc.get_current_dialog()
                else:
                    active_dialog = None  # Закрываем диалог, если рядом никого

    # Логика движения
    player.move(keys)

    # Отрисовка
    screen.fill(BG_COLOR)

    # Рисуем танцпол/декор
    pygame.draw.rect(
        screen, (40, 30, 60), (300, 50, 200, 120), border_radius=10
    )  # Сцена диджея

    # Рисуем NPC и Игрока
    for npc in npcs:
        npc.draw(screen)
    player.draw(screen)

    # Подсказка по управлению вверху
    help_text = font.render(
        "Управление: WASD / Стрелки. Подойти к человеку + ПРОБЕЛ — говорить.",
        True,
        WHITE,
    )
    screen.blit(help_text, (10, 10))

    # Отрисовка окна диалога (если заговорено с кем-то)
    if active_dialog:
        # Диалоговое окно внизу экрана
        dialog_rect = pygame.Rect(50, 460, 700, 100)
        pygame.draw.rect(screen, UI_BG, dialog_rect, border_radius=10)
        pygame.draw.rect(screen, YELLOW, dialog_rect, width=2, border_radius=10)

        # Текст
        speaker_surf = font.render(
            f"--- {active_speaker} ---", True, YELLOW
        )
        text_surf = dialog_font.render(active_dialog, True, WHITE)

        screen.blit(speaker_surf, (70, 470))
        screen.blit(text_surf, (70, 505))

    pygame.display.flip()
    clock.tick(60)

pygame.quit()
sys.exit()

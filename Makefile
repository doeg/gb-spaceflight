ASM = rgbasm
LINK = rgblink
FIX = rgbfix

#Change the following lines
ROM_NAME = spaceflight
# SOURCES = src/main.asm src/lcd.asm src/memory.asm src/splash.asm src/joypad.asm src/game.asm
SOURCES = \
	src/main.asm \
	src/joypad.asm \
	src/lcd.asm \
	src/memory.asm \
	src/splash.asm \
	src/game.asm

FIX_FLAGS = -v -p 0

INCDIR = include
OBJECTS = $(SOURCES:%.asm=%.o)

all: $(ROM_NAME)

$(ROM_NAME): $(OBJECTS)
	$(LINK) -o $@.gb -n $@.sym $(OBJECTS)
	$(FIX) $(FIX_FLAGS) $@.gb

%.o: %.asm
	$(ASM) -i$(INCDIR)/ -o $@ $<

clean:
	rm $(ROM_NAME).gb $(ROM_NAME).sym $(OBJECTS)

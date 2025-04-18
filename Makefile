roms := \
	pokeblue.gbc \
	pokeblue_debug.gbc\

rom_obj := \
	audio.o \
	main.o \
	text.o \
	wram.o \

pokeblue_obj := $(rom_obj:.o=_blue.o)
pokeblue_debug_obj := $(rom_obj:.o=_blue_debug.o)

### Build tools

ifeq (,$(shell which sha1sum))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink


### Build targets

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: all blue blue_debug clean tidy compare tools

all: $(roms)
blue: pokeblue.gbc
blue_debug: pokeblue_debug.gbc

# For contributors to make sure a change didn't affect the contents of the rom.
compare: $(roms)
	@$(SHA1) -c roms.sha1

clean: tidy
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' \) -exec rm {} +

tidy:
	rm -f $(roms) $(pokeblue_obj) $(pokeblue_debug_obj) $(roms:.gbc=.map) $(roms:.gbc=.sym) rgbdscheck.o 
	$(MAKE) clean -C tools/

tools:
	$(MAKE) -C tools/

RGBASMFLAGS = -Weverything
rgbdscheck.o: rgbdscheck.asm
	$(RGBASM) -o $@ $<
	

RGBASMFLAGS += -h -l
# -h makes it so that a nop instruction is NOT automatically added by the compiler after every halt instruction
# -l automatically optimizes the ld instruction to ldh where applicable
# -Weverything makes the compiler print all applicable warnings

# Create a sym/map for debug purposes if `make` run with `DEBUG=1`
ifeq ($(DEBUG),1)
RGBASMFLAGS += -E
endif

# _RED, _BLUE, and _GREEN are the base rom tags. You can only have one of these.
# _SWBACKS modifies any base rom. It uses spaceworld 48x48 back sprites.

# You must have one, and only one, of the following tags to set the encounter tables, trades, and game corner prizes:
# _ENCRED for the data used by japanese and international red version.
# _ENCBLUEGREEN for the data used by japanese green and international blue versions.
# _ENCBLUEJP for the data used by japanese blue version.

# _SWSPRITES modifies any base rom but cannot be used with other _*SPRITES tags. It uses spaceworld front 'mon sprites.
# _YSPRITES modifies any base rom but cannot be used with other _*SPRITES tags. It uses yellow front 'mon sprites.
# _RGSPRITES modifies any base rom but cannot be used with other _*SPRITES tags. It uses redjp/green front 'mon sprites.

# _REDGREENJP modifies _RED or _GREEN. It reverts back many audio-visual presentation aspects of japanese red & green.
# _BLUEJP modifies _BLUE. It reverts back certain aspects that were unique to japanese blue.
# _REDJP modifies _RED. It is for minor things exclusive to japanese red.

# _JPTXT modifies any base rom. It restores some japanese text translations that were altered in english.
# _JPLOGO modifies any base rom. It builds a japanese-style title screen logo.
# _RGTITLE modifies any base rom. It builds a red-jp/green-style title screen layout and presentation.
# _METRIC modifies any base rom. It converts the pokedex data back to metric units.

# _FPLAYER modifies any base rom. It includes code to support a female trainer player option.
# _MOVENPCS adds move deleter and relearner NPCs in a Saffron house.
# _RUNSHOES Allows player to run by holding B
# _EXPBAR Adds an EXP bar to the battle UI

# _JPFLASHING modifies any base rom. It restores flashing move animations that were in japanese red and green.
# !!WARNING!! The flashing of the restored moves may be harmful to those with photosensitivity or epilepsy.
# This tag would normally be added to the GREEN and RED_JP roms, but it remains inactive by default for safety.
# Please act responsibly should you choose to compile using this tag.
# Dev Note: The added flashing can become quite displeasing regardless. Leaving it out makes for a better experience.

$(pokeblue_obj): 	   RGBASMFLAGS += -D _BLUE
$(pokeblue_debug_obj): RGBASMFLAGS += -D _BLUE -D _DEBUG

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
define DEP
$1: $2 $$(shell tools/scan_includes $2) | rgbdscheck.o
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef
	

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tidy tools,$(MAKECMDGOALS)))
$(info $(shell $(MAKE) -C tools))

# Dependencies for objects (drop _red and _blue and etc from asm file basenames)
$(foreach obj, $(pokeblue_obj), $(eval $(call DEP,$(obj),$(obj:_blue.o=.asm))))
$(foreach obj, $(pokeblue_debug_obj), $(eval $(call DEP,$(obj),$(obj:_blue_debug.o=.asm))))

endif


%.asm: ;

#gbcnote - use cjsv to compile as GBC+DMG rom
#pokeblue_opt 	= -cjsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON BLUE"
pokeblue_pad       = 0x00
pokeblue_debug_pad = 0xff
pokeblue_opt       = -cjsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "POKEMON BLUE"
pokeblue_debug_opt = -cjsv -n 0 -k 01 -l 0x33 -m 0x13 -r 03 -t "POKEMON BLUE"

%.gbc: $$(%_obj) layout.link
#	$(RGBLINK) -d -m $*.map -n $*.sym -l layout.link -o $@ $(filter %.o,$^)
#	$(RGBFIX) $($*_opt) $@
	$(RGBLINK) -p $($*_pad) -d -m $*.map -n $*.sym -l layout.link -o $@ $(filter %.o,$^)
	$(RGBFIX) -p $($*_pad) $($*_opt) $@

gfx/mainmenu/intro_nido_1.2bpp: rgbgfx += -Z
gfx/mainmenu/intro_nido_2.2bpp: rgbgfx += -Z
gfx/mainmenu/intro_nido_3.2bpp: rgbgfx += -Z

gfx/tiles/game_boy.2bpp: tools/gfx += --remove-duplicates
gfx/tiles/theend.2bpp: tools/gfx += --interleave --png=$<
gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace

%.png: ;

%.2bpp: %.png
	$(RGBGFX) $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)
%.1bpp: %.png
	$(RGBGFX) $(rgbgfx) -d1 -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)
%.pic:  %.2bpp
	tools/pkmncompress $< $@

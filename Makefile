
ALL_BUILT_FILES=keyboard_key_emulator volume_up volume_down volume_mute music_playpause music_next music_previous

all: $(ALL_BUILT_FILES)

keyboard_key_emulator:
	gcc -o keyboard_key_emulator keyboard_key_emulator.m  -framework IOKit -framework Cocoa

volume_down:
	gcc -DVOLUME_DOWN -o volume_down keyboard_key_emulator.m  -framework IOKit -framework Cocoa

volume_up:
	gcc -DVOLUME_UP -o volume_up keyboard_key_emulator.m  -framework IOKit -framework Cocoa

volume_mute:
	gcc -DVOLUME_MUTE -o volume_mute keyboard_key_emulator.m  -framework IOKit -framework Cocoa

music_previous:
	gcc -DMUSIC_PREVIOUS -o music_previous keyboard_key_emulator.m  -framework IOKit -framework Cocoa

music_playpause:
	gcc -DMUSIC_PLAYPAUSE -o music_playpause keyboard_key_emulator.m  -framework IOKit -framework Cocoa

music_next:
	gcc -DMUSIC_NEXT -o music_next keyboard_key_emulator.m  -framework IOKit -framework Cocoa

clean:
	rm -f $(ALL_BUILT_FILES)


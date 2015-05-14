esmc.new.run:

esmc.bin: 
	cp 'Educational System Master Cartridge (Atari).bin' $@

%.new.run: %.new.bin
	altirra $<

%.new.bin: %.asm
	xasm /t:$*.lab /l:$*.lst $< /o:$@
	perl -pi -e 's/^n/ /' $*.lab

%.asm: %.long.asm
	perl -pe 's/h-/h-f+/;print "    org \$$A000\n    dta \$$FF\n    org \$$B800\n" if /org/;$$_="" if /org/../B7FF/;' $< $(out)

%.long.asm: %.dop %.bin
	dis -a $^ $(out)

out = > $@~ && mv $@~ $@

.PRECIOUS: %.new.bin %.asm %.long.asm

esmc2.run:
esmc.bin:

%.run: %.bin
	altirra $<

%.bin: %.asm
	xasm /t:$*.lab /l:$*.lst $< /o:$@

.PRECIOUS: %.bin

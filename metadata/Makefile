SHELL := /bin/bash

all: language-confidence.txt latin-confidence.txt language-confidence-sorted.txt latin-confidence-sorted.txt combined-confidence.txt combined-confidence-sorted.txt

language-confidence.txt: djvus
	find . -name '*_djvu.txt' | langid -b | dos2unix > $@

latin-confidence.txt: djvus
	find . -name '*_djvu.txt' | langid -l la -b | dos2unix > $@

%-confidence-sorted.txt: %-confidence.txt
	awk -F, '{print $$3 "," $$2 "," $$1}' < $^ | sort -g > $@

combined-confidence.txt: latin-confidence.txt language-confidence.txt
	paste -d, <(sort < language-confidence.txt) <(sort < latin-confidence.txt) > $@

combined-confidence-sorted.txt: combined-confidence.txt
	awk -F, '{print $$6 "," $$2 "," $$3 "," $$1}' < $^ | sort -g > $@

ids.txt: Makefile.ids
	make -f Makefile.ids $@

djvus: ids.txt $(shell make -s -f Makefile.ids; sed -e 's/$$/_djvu.txt/' -e 's/^/djvus\//' < ids.txt)
	touch djvus

djvus/%_djvu.txt:
	wget -P djvus "https://archive.org/download/$(patsubst djvus/%_djvu.txt,%,$@)/$@"

clean:
	rm -fv language-confidence.txt latin-confidence.txt language-confidence-sorted.txt latin-confidence-sorted.txt combined-confidence.txt combined-confidence-sorted.txt

clean-data:
	rm -rfv djvus

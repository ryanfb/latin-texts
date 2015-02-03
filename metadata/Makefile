SHELL := /bin/bash

DIRS := djvus latin_txt greatbooks
TXT_PREFIXES := $(foreach dir,$(DIRS),$(dir)-language-confidence $(dir)-latin-confidence $(dir)-combined-confidence $(dir)-combined-confidence-diff)
TXT_SORTED := $(addsuffix -sorted,$(TXT_PREFIXES))
TXT_TARGETS := $(addsuffix .txt,$(TXT_PREFIXES) $(TXT_SORTED))

TXT_FILES := language-confidence.txt latin-confidence.txt language-confidence-sorted.txt latin-confidence-sorted.txt combined-confidence.txt combined-confidence-sorted.txt

all: $(TXT_TARGETS)

print-%  : ; @echo $* = $($*)

%-language-confidence.txt: %
	find $^ -type f | langid -b | dos2unix > $@

%-latin-confidence.txt: %
	find $^ -type f | langid -l la -b | dos2unix > $@

%-combined-confidence-sorted.txt: %-combined-confidence.txt
	awk -F, '{print $$6 "," $$2 "," $$3 "," $$1}' < $^ | sort -g > $@

%-confidence-sorted.txt: %-confidence.txt
	awk -F, '{print $$3 "," $$2 "," $$1}' < $^ | sort -g > $@

%-combined-confidence.txt: %-language-confidence.txt %-latin-confidence.txt
	paste -d, <(sort < $(word 1,$^)) <(sort < $(word 2,$^)) > $@

%-combined-confidence-diff.txt: %-combined-confidence-sorted.txt
	awk -F, '{diff = sprintf("%.0f",$$1 - $$3); print diff "," $$1 "," $$2 "," $$3 "," $$4 }' < $^ > $@

%-combined-confidence-diff-sorted.txt: %-combined-confidence-diff.txt
	sort -g < $^ > $@

ids.txt: Makefile.ids
	make -f Makefile.ids $@

djvus: ids.txt $(shell make -s -f Makefile.ids; sed -e 's/$$/_djvu.txt/' -e 's/^/djvus\//' < ids.txt)
	touch djvus

djvus/%_djvu.txt:
	wget -P djvus "https://archive.org/download/$(patsubst djvus/%_djvu.txt,%,$@)/$(patsubst djvus/%_djvu.txt,%_djvu.txt,$@)"

greatbooks: greatbooks.txt $(shell sed -e 's/$$/_djvu.txt/' -e 's/^/greatbooks\//' < greatbooks.txt)
	touch greatbooks

greatbooks/%_djvu.txt:
	wget -P greatbooks "https://archive.org/download/$(patsubst greatbooks/%_djvu.txt,%,$@)/$(patsubst greatbooks/%_djvu.txt,%_djvu.txt,$@)"

gdown.pl:
	wget 'https://raw.githubusercontent.com/Nanolx/patchimage/master/tools/gdown.pl'
	chmod +x gdown.pl

latin_txt.tar.gz: gdown.pl
	./gdown.pl 'https://docs.google.com/uc?id=0B5pGKi0iCsnbZEdHZ3N6d216am8&export=download' $@

latin_txt: latin_txt.tar.gz
	tar xzvf $^

clean:
	rm -fv $(TXT_TARGETS)

clean-data:
	rm -rfv djvus

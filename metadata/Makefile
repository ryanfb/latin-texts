SHELL := /bin/bash

DIRS := djvus latin_txt greatbooks
TXT_PREFIXES := $(foreach dir,$(DIRS),$(dir)-language-confidence $(dir)-latin-confidence $(dir)-combined-confidence $(dir)-combined-confidence-diff $(dir)-lines)
TXT_SORTED := $(addsuffix -sorted,$(TXT_PREFIXES))
TXT_TARGETS := $(addsuffix .txt,$(TXT_PREFIXES) $(TXT_SORTED))

TXT_FILES := language-confidence.txt latin-confidence.txt language-confidence-sorted.txt latin-confidence-sorted.txt combined-confidence.txt combined-confidence-sorted.txt

all: $(TXT_TARGETS)

print-%  : ; @echo $* = $($*)

%-language-confidence.txt: %
	find $^ -type f | langid -b | dos2unix > $@

%-latin-confidence.txt: %
	find $^ -type f | langid -l la -b | dos2unix > $@

%-lines.txt: %
	find $^ -type f -exec wc -l {} \; | awk '{print $$1 "," $$2}' > $@

%-lines-sorted.txt: %-lines.txt
	sort -n < $^ > $@

%-combined-confidence-sorted.txt: %-combined-confidence.txt
	awk -F, '{print $$6 "," $$2 "," $$3 "," $$1 "," $$8}' < $^ | sort -g > $@

%-confidence-sorted.txt: %-confidence.txt
	awk -F, '{print $$3 "," $$2 "," $$1}' < $^ | sort -g > $@

%-combined-confidence.txt: %-language-confidence.txt %-latin-confidence.txt %-lines.txt
	paste -d, <(sort < $(word 1,$^)) <(sort < $(word 2,$^)) <(awk -F, '{print $$2 "," $$1}' < $(word 3,$^) | sort) > $@

%-combined-confidence-diff.txt: %-combined-confidence-sorted.txt
	awk -F, '{diff = sprintf("%.0f",($$1 - $$3) * $$5); print diff "," $$1 "," $$2 "," $$3 "," $$4 "," $$5 }' < $^ > $@

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

missing_ids_404.txt missing_ids_200.txt: missing_ids.txt
	rm -fv missing_ids_404.txt missing_ids_200.txt
	while read id; do if curl -s --fail --head -o /dev/null http://archive.org/download/$$id; then echo $$id >> missing_ids_200.txt; else echo $$id >> missing_ids_404.txt; fi; done < missing_ids.txt

missing_ids_200_derivatives.txt missing_ids_200_no_derivatives.txt: missing_ids_200.txt
	rm -fv missing_ids_200_derivatives.txt missing_ids_200_no_derivatives.txt
	while read id; do if (curl -s -L http://archive.org/download/$${id}/$${id}_files.xml | grep derivative > /dev/null 2>&1); then echo $$id >> missing_ids_200_derivatives.txt; else echo $$id >> missing_ids_200_no_derivatives.txt; fi; done < missing_ids_200.txt

missing_ids_200_pdfs.txt missing_ids_200_no_pdfs.txt: missing_ids_200_derivatives.txt
	rm -fv missing_ids_200_pdfs.txt missing_ids_200_no_pdfs.txt
	while read id; do if curl -s --fail -L -r 0-0 -o /dev/null http://archive.org/download/$${id}/$${id}.pdf; then echo $$id >> missing_ids_200_pdfs.txt; else echo $$id >> missing_ids_200_no_pdfs.txt; fi; done < missing_ids_200_derivatives.txt

clean:
	rm -fv $(TXT_TARGETS)

clean-data:
	rm -rfv djvus

MCC=/usr/local/MATLAB/R2013b/bin/mcc
MEX=/usr/local/MATLAB/R2013b/bin/mex
MFLAGS=-m -R -singleCompThread -R -nodisplay -R -nojvm
#SRCDIR=src
#IDIRS=-I ./$(SRCDIR) -I ./$(SRCDIR)/dprime -I ./$(SRCDIR)/jsonlab -I ./$(SRCDIR)/splat
SRCDIR=.
IDIRS=
.PHONEY: clean clean-all all source_code.tar.gz extract

all: IterLasso binaries.tar.gz

source_code.tar.gz: src dependencies
	tar czhf source_code.tar.gz src dependencies

extract: source_code.tar.gz
	-mkdir source_code/
	tar xzf source_code.tar.gz -C ./source_code/

IterLasso: $(SRCDIR)/runIterativeLasso.m
	$(MCC) $(MFLAGS) $(IDIRS) -o $@ runIterativeLasso.m 

binaries.tar.gz: SOSLasso run_SOSLasso.sh summarize_jobs run_summarize_jobs.sh
	mkdir bin/
	mv IterLasso run_IterLasso.sh bin/
	tar czvf $@ bin/

clean:
	-rm *.dmr
	-rm _condor_std???
	-rm readme.txt
	-rm mccExcludedFiles.log

clean-all: binaries.tar.gz
	rm -rf src/ bin/

# paths
buildDir=.build
sourceDir=./


sources+=asmCallGraph.dot
sourcesFull=$(addprefix $(sourceDir)/,$(objects))

objects=$(sources:.dot=.png)
objectsFull=$(addprefix $(buildDir)/,$(objects))
objectsFull+=index.html

doc: $(objectsFull)

$(buildDir):
	mkdir -p $(buildDir) 
$(buildDir)/%.png: $(sourceDir)/%.dot $(buildDir)
	dot -Tpng $< > $@

index.html:
	export SOURCEDIR=".." && \
	doxygen

clean:
	rm -fvR $(buildDir)
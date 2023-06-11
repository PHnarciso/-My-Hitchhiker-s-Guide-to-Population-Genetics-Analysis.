#Script for calculating genetic diversity indices of natural populations and performing AMOVA analysis.

library("dartR")
library("adegenet")
library("pegas")
library("poppr")
library("vcfR")
library("hierfstat")
require(SeqVarTools) # when using vcf as input file


setwd("path")

#Load DArT data with metadata (pop information) and recalculating locus information
#ATENTION: this commands changes 1s and 2s, so the input should have 
#1 as alternative homozygotes and 2 as heterozygotes.
gl <- gl.read.dart(filename = "*_PCA.csv", ind.metafile = "*_metadata.csv",mono.rm=T,recalc=T)
#Confirm conversion was done corectly (1 - hetero; 2 - homo alternative).
t(as.matrix(gl))[c(1,5,17), 1:18]

#Visualize the SNP table
glPlot(gl) 

#Genetic Diversity, most "important" vaules are:
#m_0Da (Allelic richness), m_1Da (Shannon diversity) and m_2Ha (Heterozygosity). 
#Might use m_1Ha (Shannon entropy)
#Statistics calculated according to:
#Sherwin, W. B., Chao, A., Jost, L., & Smouse, P. E. (2017). 
#Information theory broadens the spectrum of molecular ecology and evolution.
#Trends in ecology & evolution, 32(12), 948-963.
gl.report.diversity(gl)

#Estimate Ho and He
gl.report.heterozygosity(gl)


#Private alleles. To use this you need to prepare one metafile for each population,
#collapsing the reamining population (e.g. naming them as "other")
pa=0
for (i in levels(gl@pop)) {
  gl <- gl.read.dart(filename = "*_PCA.csv",ind.metafile = paste("*_metadata_",i,".csv",sep=""),recalc=T)
  pa=rbind(pa,gl.report.pa(gl))
}
pa

#Reload the original input
gl <- gl.read.dart(filename = "*_PCA.csv", ind.metafile = "*_metadata.csv",mono.rm=T,recalc=T)

#Convert to genind - I think this is not being done correctly, 
#hetero and alternative homozygotes are being confounded.
#I believe this because Ho is higher than He.
gi <- gl2gi(gl, probar = FALSE, verbose = NULL)
fstat_input <- genind2hierfstat(gi)

#Estimate Fis and allelic richness with for each population
stats = basic.stats(fstat_input)
colMeans(stats$Fis,  na.rm = T)
colMeans(stats$Ho,  na.rm = T)
colMeans(stats$Hs,  na.rm = T)

colMeans(allelic.richness(fstat_input)$Ar,  na.rm = T)

#Also get overall stats
stats$overvall

#Set levels for AMOVA
strata(gl)=data.frame(gl@pop)

#Remove missing data
filt.gl=gl.filter.callrate(gl,threshold = 1.0)

#perform AMOVA - from https://grunwaldlab.github.io/poppr/reference/poppr.amova.html
amova.result <- poppr.amova(filt.gl,~gl.pop)
amova.result

#Significance
amova.test <- randtest(amova.result)
amova.test

#Perform AMOVA with pegas
amova.pegas <- poppr.amova(filt.gl,~gl.pop, method = "pegas")
amova.pegas$varcomp/sum(amova.pegas$varcomp)

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert2sbml.R
\name{convert2sbml}
\alias{convert2sbml}
\title{Write a model in a SBML format.}
\usage{
convert2sbml(data, outfile, optimizedFor = "sybil", boundary = "b")
}
\arguments{
\item{data}{A data.frame with the following mandatory colnames: \itemize{
\item \code{"ID":} A list of single character strings containing the reaction abbreviations, Entries in the field abbreviation are used as reaction ids, so they must be unique.
\item \code{"REACTION":} A set of stoichiometric reaction with the following format: \code{"H2O[c] + Urea-1-carboxylate[c] <=> 2 CO2[c] + 2 NH3[c]"} Where arrows and plus signs are surrounded by a "space character".
It is also expected that stoichiometry coefficients are surrounded by spaces, (nothe the "2" before the CO2[c] or the NH3[c]).
It also expects arrows to be in the form "\code{=>}" or "\code{<=>}".
Meaning that arrows like "\code{==>}", "\code{<==>}", "\code{-->}" or "\code{->}" will not be parsed and will lead to errors.,
\item \code{"GPR":} A set of genes joined by boolean operators as AND or OR, rules may be nested by parenthesis. (optional: column can be empty),
\item \code{"LOWER.BOUND":} A list of numeric values containing the lower bounds of the reaction rates.
If not set, zero is used for an irreversible reaction and 1000 for a reversible reaction. (optional: column can be empty),
\item \code{"UPPER.BOUND":} A list of numeric values containing the upper bounds of the reaction rates.
If not set, 1000 is used by default. (optional: column can be empty),
\item \code{"OBJECTIVE":} A list of numeric values containing objective values for each reaction (optional: column can be empty).
}}

\item{outfile}{A writable path for the output 'SBML' file to be generated.}

\item{optimizedFor}{A character string specifying the toolbox for which the SBML file must be optimized; must be one of \code{'sybil'}, \code{'RAVEN'} or \code{'COBRA'}. A \code{'sybil'} optimized SBML file is generated by default.}

\item{boundary}{A character string specifying the compartment to be used as boundary}
}
\value{
A SBML file.
}
\description{
This function converts a data.frame to a valid SBML file. The Systems Biology Markup Language (SBML) is a representation format, based on XML, for communicating and storing computational models of biological processes.
More Info: Encyclopedia of Systems Biology Dubitzky, W., Wolkenhauer, O., Yokota, H., Cho, K.-H. (Eds.) SBML, pp2057-2062 Springer 2013.
}
\details{
This function takes a data.frame as input and convert it to a valid sbmlR object, then the object is written into the SBML output file.
}
\examples{
\dontrun{
# Loading a CSV file
glycolysis <- read.csv2(system.file("extdata", "glycolysisKEGG.csv", package = "minval"))

# Data structure
head(glycolysis)

# Writing SBML file
## Optimized for the 'sybil' package
convert2sbml(
 data = glycolysis, 
 outfile = "glycolysis_sybil.xml", 
 optimizedFor = "sybil", 
 boundary = "b"
 )
 
## Optimized for the 'COBRA' toolbox
convert2sbml(
 data = glycolysis, 
 outfile = "glycolysis_cobra.xml", 
 optimizedFor = "COBRA", 
 boundary = "b"
 )
 
## Optimized for the 'RAVEN' toolbox
convert2sbml(
 data = glycolysis, 
 outfile = "glycolysis_raven.xml", 
 optimizedFor = "RAVEN", 
 boundary = "b"
 )
}
}
\author{
Created by: Tomas Radivoyevitch - Modified and Maintained by: Daniel Camilo Osorio <dcosorioh@unal.edu.co>
}
\seealso{
Original 'saveSBML': https://www.bioconductor.org/packages/release/bioc/html/SBMLR.html
}
\keyword{Convert}
\keyword{Metabolic}
\keyword{Reconstruction}
\keyword{SBML}


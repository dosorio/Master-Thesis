#' @export isValidSyntax
#' @author Daniel Camilo Osorio <dcosorioh@unal.edu.co>
# Bioinformatics and Systems Biology Lab      | Universidad Nacional de Colombia
# Experimental and Computational Biochemistry | Pontificia Universidad Javeriana
#' @title Evaluate if a stoichiometric reaction has a valid syntax
#' @description  For a set of given stoichiometric reactions, this function makes the following syntactic evaluations for each reaction: \itemize{
#' \item Evaluates if the reaction contain more than one coefficient by metabolite
#' \item Evaluates if the reaction contain metabolite coefficients between parenthesis
#' \item Evaluates if the reaction contain arrow symbol between spaces
#' \item Evaluates if the reaction contain not allowed arrow symbols
#' \item Evaluates if the reaction contain metabolites name separated by a plus symbol between spaces
#' \item Evaluates if the reaction contain substituents separated of the metabolite names
#' }
#' @param reactionList A set of stoichiometric reaction with the following format: 
#' 
#' \code{"H2O[c] + Urea-1-carboxylate[c] <=> 2 CO2[c] + 2 NH3[c]"} 
#' 
#' Where arrows and plus signs are surrounded by a "space character".
#' It is also expected that stoichiometry coefficients are surrounded by spaces, (nothe the "2" before the CO2[c] or the NH3[c]).
#' It also expects arrows to be in the form "\code{=>}" or "\code{<=>}". 
#' Meaning that arrows like "\code{==>}", "\code{<==>}", "\code{-->}" or "\code{->}" will not be parsed and will lead to errors.
#' @return  A boolean value 'TRUE' if reaction has a valid syntax.
#' @examples 
#' # Loading a CSV file
#' glycolysis <- read.csv2(system.file("extdata", "glycolysisKEGG.csv", package = "minval"))
#'
#' # Data structure
#' head(glycolysis)
#' 
#' # Evaluating syntax
#' isValidSyntax(
#'  reactionList = glycolysis$REACTION
#' )
isValidSyntax <- function(reactionList){
  valid.syntax <- NULL
  # Coefficient validation
  valid.syntax <- c(valid.syntax,grepl("([[:digit:]][[:blank:]][[:digit:]][[:blank:]])+",reactionList))
  valid.syntax <- c(valid.syntax,grepl("(\\([[:digit:]]+\\)[[:blank:]]+)",reactionList))
  # Directionality validation
  valid.syntax <- c(valid.syntax, (!grepl("[[:blank:]]+<?=>[[:blank:]]*",reactionList)))
  valid.syntax <- c(valid.syntax,grepl("(<)?\\-(\\-)?>",reactionList))
  # Metabolite names validation
  valid.syntax <- c(valid.syntax,grepl("[[:alnum:]]+\\+[[:alnum:]]+",reactionList))
  # Blank spaces validation
  valid.syntax <- c(valid.syntax, (!grepl("[[:blank:]]",reactionList)))
  # Validating metabolite name
  valid.syntax <- c(valid.syntax, grepl("[[:blank:]]\\-[[:alnum:]]",reactionList))
  # Warnings!
  valid.syntax <- matrix(valid.syntax,ncol = 7)
  sapply(which(valid.syntax[,1]==TRUE),function(x){warning(paste0("Reaction ",x,": Invalid coefficients. Metabolites should have just one coefficient."),call. = FALSE)})
  sapply(which(valid.syntax[,2]==TRUE),function(x){warning(paste0("Reaction ",x,": Invalid coefficients. Coefficients should have not parentheses."),call. = FALSE)})
  sapply(which(valid.syntax[,3]==TRUE),function(x){warning(paste0("Reaction ",x,": Invalid directionality symbols. Arrow symbols should be between blank spaces."),call. = FALSE)})
  sapply(which(valid.syntax[,4]==TRUE),function(x){warning(paste0("Reaction ",x,": Invalid directionality symbols. Please use <=> or => instead of <-> or -> or -->."),call. = FALSE)})
  sapply(which(valid.syntax[,5]==TRUE),function(x){warning(paste0("Reaction ",x,": Metabolites names should be separated by a plus symbol between spaces."),call. = FALSE)})
  sapply(which(valid.syntax[,6]==TRUE),function(x){warning(paste0("Reaction ",x,": No blank spaces detected."),call. = FALSE)})
  sapply(which(valid.syntax[,7]==TRUE),function(x){warning(paste0("Reaction ",x,": Invalid metabolite name. Substituent should not be separated of the metabolite name."),call. = FALSE)})
  # Return
  valid.syntax <- sapply(seq_along(reactionList), function(reaction){all(valid.syntax[reaction,]==FALSE)})
  return(valid.syntax)
}

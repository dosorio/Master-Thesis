require(sybilSBML)

# FBA
matureAstrocyte_Model <- readSBMLmod("Results/matureAstrocyte.xml")
model_FBA <- optimizeProb(matureAstrocyte_Model)
# Minimizing the total absolute fluxes MTF (Evaluando las múltiples posibles soluciones)
model_MTF <- optimizeProb(matureAstrocyte_Model, algorithm = "mtf", wtobj = mod_obj(model_FBA))
getNetFlux(getFluxDist(model_MTF,findExchReact(matureAstrocyte_Model)))

pdf(file = "Slides/Figures/IC50.pdf",width = 13,height = 8.45)
par(mfcol=c(1,6))
# Palmitate Value
IC50 <- function(model, controlReaction, range, Smain){
  robValues <- suppressMessages(robAna(model = model,ctrlreact = controlReaction, rng = range, numP = 1000))
  IC <- robValues@ctrlfl[which.min(abs(round((robValues@lp_obj/robValues@lp_obj[1000])-1,6)+0.5))]
  R <- suppressMessages(robAna(model = model,ctrlreact = controlReaction, rng = range, numP = 20))
  plot(R,ylim=c(0,3),xlab="HDCA uptake rate \n mM/gWD*h",main=Smain,ylab="Objective Function Value")
  title(main=Smain,outer=F)
  abline(v = abs(IC),col="red")
  #abline(h = robValues@lp_obj[1000]/2,col="red")
  text(abs(IC),robValues@lp_obj[1000],substitute(IC[50]==t0, list(t0 = abs(round(IC,3)))),pos = 4)
  return(IC)
}

Palmitate <- NULL
# Biomass Function
Palmitate <- c(Palmitate,IC50(model = matureAstrocyte_Model,controlReaction = "EX_hdca(e)",range = c(-0.5,0),Smain = "BIOMASS\nDMEM medium"))

# Biomass Function + glu -> gln
matureAstrocyte_Model <- addReact(model = matureAstrocyte_Model,
                                  id = "MC",
                                  met = c("glu_L[e]","gln_L[e]"),
                                  Scoef = c(-1,1),
                                  reversible = FALSE,
                                  ub = 1000,
                                  obj = TRUE)
Palmitate <- c(Palmitate,IC50(model = matureAstrocyte_Model,controlReaction = "EX_hdca(e)",range = c(-0.5,0),Smain = "GLU[e] to GLN[e]\nConvertion"))

# Biomass Function + gly -> D-serine
matureAstrocyte_Model <- addReact(model = matureAstrocyte_Model,
                                  id = "MC",
                                  met = c("gly[c]","ser_D[e]"),
                                  Scoef = c(-1,1),
                                  reversible = FALSE,
                                  ub = 1000,
                                  obj = TRUE)
Palmitate <- c(Palmitate,IC50(model = matureAstrocyte_Model,controlReaction = "EX_hdca(e)",range = c(-0.5,0),Smain = "GLY[e] to dSER[e]\nConvertion"))

# Biomass Function + glc -> lactate
matureAstrocyte_Model <- addReact(model = matureAstrocyte_Model,
                                  id = "MC",
                                  met = c("glc_D[c]","lac_L[e]"),
                                  Scoef = c(-1,2),
                                  reversible = FALSE,
                                  ub = 1000,
                                  obj = TRUE)
Palmitate <- c(Palmitate,IC50(model = matureAstrocyte_Model,controlReaction = "EX_hdca(e)",range = c(-0.5,0),Smain = "GLC[e] to LACTATE[e]\nConvertion"))

# Biomass Function + Cys -> Gthrd
matureAstrocyte_Model <- addReact(model = matureAstrocyte_Model,
                                  id = "MC",
                                  met = c("cys_L[c]","gthrd[e]"),
                                  Scoef = c(-1,1),
                                  reversible = FALSE,
                                  ub = 1000,
                                  obj = TRUE)
Palmitate <- c(Palmitate,IC50(model = matureAstrocyte_Model,controlReaction = "EX_hdca(e)",range = c(-0.5,0),Smain = "CYS[e] to GTHRD[e]\nConvertion"))

# Biomass Function + glc -> ATP
matureAstrocyte_Model <- addReact(model = matureAstrocyte_Model,
                                  id = "MC",
                                  met = c("glc_D[c]","atp[e]"),
                                  Scoef = c(-1,1),
                                  reversible = FALSE,
                                  ub = 1000,
                                  obj = TRUE)
Palmitate <- c(Palmitate,IC50(model = matureAstrocyte_Model,controlReaction = "EX_hdca(e)",range = c(-0.5,0),Smain = "GLC[e] to ATP[e]\nConvertion"))
dev.off()
# Inflammation Palmitate Uptake
IC50palmitate_v <- round(mean(Palmitate),3)
IC50palmitate_d <- round(sd(Palmitate),3)



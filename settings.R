## General settings

# General directories
root.dir <- here::here()
# R Code Library
lib.dir <- file.path(root.dir, "lib")
# Shiny Parts
shiny.parts.dir <- file.path(root.dir, "parts")
# Data directory
data.dir <- file.path(root.dir, "data")


### GGplot labels

p.label.ln <- function(.l) {bquote("ln"~.(.l)) }
p.label.log <- function(.l, base=10) {bquote("log"[.(base)]~.(.l)) }

p.label.mu <- bquote(mu~("h"^-1))
p.label.dt <- bquote(Delta*"t"~(h))
p.label.condition <- "Condition"
p.label.time.h <- bquote("Time"~(h))
p.label.r.sq <- bquote("R"^2)
p.label.pbr <- "PBR"
p.label.channel <- "Channel"
p.label.dO2 <- bquote("dO"[2]~("%"))
p.label.intensity <- bquote("LI"~(mu*"E"^-1*"m"^-2*"s"^-1))
p.label.red.intensity <- bquote("red" ~ .(p.label.intensity))
p.label.lac.conc <- "[Na-L-lactate]"
p.label.dataset <- "Dataset"
p.label.n.points <- "# OD measurements"
p.lalel.n.generations <- "# Generations"
p.label.dt <- bquote("Doubling time"~(h))
p.label.method <- "Method"
p.label.od <- function(.w) { bquote("OD"[.(.w)]) }
p.label.od.720 <- p.label.od(720)
p.label.od.730 <- p.label.od(730)
p.label.od.ln <- function(.w) { p.label.ln(p.label.od(.w)) }
p.label.od.ln.720 <- p.label.od.ln(720)
p.label.cdr <- ~ bquote("Cumulative d"~("h"^-1))
p.label.temperature <-  bquote("Temperature"~(degree*"C"))
p.label.size <-  bquote("Size"~(mu*"m"))
p.label.counts <- "# Counts"

p.label.dna.conc <- bquote("[DNA]"~("ng"%.%mu*"L"^-1))
p.label.conc.phs.mM <- bquote("Phosphate (mM)")

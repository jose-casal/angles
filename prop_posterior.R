#setwd("DIRECTORY")

extras <-
  c("mosaic", "dplyr", "ggplot2", "Cairo", "Hmisc")
if (length(setdiff(extras, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(extras, rownames(installed.packages())))
}

lapply(extras, require, character.only = TRUE)

# Angles

R1 <- 45
R2 <- 135
L1 <- 225
L2 <- 315

tbl_Acells <- read.csv("tbl_Acells.csv")

tbl_Pcells <- read.csv("tbl_Pcells.csv")

tbl_Acells <- tbl_df(tbl_Acells)

tbl_Pcells <- tbl_df(tbl_Pcells)

sim.reps <- 10000

Acells.boot <- do(sim.reps) * mean((tbl_Acells %>% mutate(file= sample(tbl_Acells$id, replace=FALSE))  %>% group_by(file) %>% summarise(anterior=count(between(Angle, R2, L1)), posterior=n()-count(between(Angle, R1, L2)), total_AP = anterior + posterior, prop_post=(posterior*100)/total_AP))$prop_post)

confint(Acells.boot, level= 0.95, method="quantile")

#  name  lower    upper level     method estimate
#1 mean 54.638 56.14841  0.95 percentile 55.58424

Pcells.boot <- do(sim.reps) * mean((tbl_Pcells %>% mutate(file= sample(tbl_Pcells$id, replace=FALSE))  %>% group_by(file) %>% summarise(anterior=count(between(Angle, R2, L1)), posterior=n()-count(between(Angle, R1, L2)), total_AP = anterior + posterior, prop_post=(posterior*100)/total_AP))$prop_post)

confint(Pcells.boot, level= 0.95, method="quantile")

#  name    lower    upper level     method estimate
#1 mean 42.54158 44.39804  0.95 percentile 43.72493

Acells <- tbl_Acells %>% group_by(id) %>% summarise(anterior=count(between(Angle, R2, L1)), posterior=n()-count(between(Angle, R1, L2)), total_AP = anterior + posterior, prop_post=(posterior*100)/total_AP

Pcells <- tbl_Pcells %>% group_by(id) %>% summarise(anterior=count(between(Angle, R2, L1)), posterior=n()-count(between(Angle, R1, L2)), total_AP = anterior + posterior, prop_post=(posterior*100)/total_AP

cells <- bind_rows(Acells,Pcells) %>% mutate(position=c(rep("A", 10), rep("P", 10))

plotProp <- ggplot(cells, aes(x=position, y=prop_post)) + geom_jitter(width = 0.1, height = 0.1, size=5) + ylim(c(0,100)) + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width=0.3, colour="blue") + stat_summary(fun.y = "mean", colour = "blue", size = 2, geom = "point") + theme(text = element_text(size=20),panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + ylab("Posterior growing comets (%)") + xlab("Cell Position")

plotProp

ggsave(plotProp, filename = "GENOTYPE_prop.pdf", device = cairo_pdf, width = 7, height = 7, units = "in")





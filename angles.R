# # in terminal
#
# cd /Users/lince/Downloads/Olofsson\ et\ al\,\ Figure\ 4H
#
# find . -name '*.xls'\
# | awk 'BEGIN{ a=1 }{ printf "cp \"%s\" /Volumes/Data/\"R Projects\"/tests/pk_sple_UAS.pk_%02d.xls\n", $0, a++ }'\
# | bash
#
# cd /Volumes/Data/R\ Projects/tests
#
# soffice --headless --convert-to csv *.xls
#
# rm *.xls
#
# # in RStudio

# #########################################
# Find and replace GENOTYPE with actual one
# #########################################

setwd("DIRECTORY")

extras <-
  c("mosaic", "dplyr", "ggplot2", "Cairo")
if (length(setdiff(extras, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(extras, rownames(installed.packages())))
}

lapply(extras, require, character.only = TRUE)

# Angles

R1 <- 45
R2 <- 135
L1 <- 225
L2 <- 315

Ra <- 60
Rb <- 120
La <- 240
Lb <- 300

files_GENOTYPE <- list.files(path = ".", pattern = glob2rx("GENOTYPE*.csv"), full.names = T)

tbl_GENOTYPE <- sapply(files_GENOTYPE, read.csv, sep = ",", simplify=FALSE) %>%  bind_rows(.id = "id")  %>% mutate(Angle = ifelse(Angle < 0, Angle + 360, Angle))

head(tbl_GENOTYPE)

Posterior <- nrow(tbl_GENOTYPE) - nrow(filter(tbl_GENOTYPE, between(Angle, R1, L2)))

Anterior <- nrow(filter(tbl_GENOTYPE, between(Angle, R2, L1)))

Up <- nrow(filter(tbl_GENOTYPE, between(Angle, R1, R2)))

Down <- nrow(filter(tbl_GENOTYPE, between(Angle, L1, L2)))

total_AP <- Anterior + Posterior

total_UD <- Up + Down


sink('GENOTYPE.txt')

x <- paste("\nAngles\n", R1, R2, L1, L2, "\n\n")
y <- paste("\nAngles\n", Ra, Rb, La, Lb, "\n\n")

writeLines(x)

# #########################################################
# change test as wished: "less" or "greater" or "two.sided"
# #########################################################

cat("===========================================================================\n")
cat("Binomial test: Frequency of Right comets of GENOTYPE is less than 0.5\n")
cat("===========================================================================\n")

binom.test(x = Up, n = total_UD, p = 0.5, alternative = c("less"), conf.level = 0.95)

cat("===========================================================================\n")
cat("Binomial test: Frequency of Right comets of GENOTYPE is greater than 0.5\n")
cat("===========================================================================\n")

binom.test(x = Up, n = total_UD, p = 0.5, alternative = c("greater"), conf.level = 0.95)

cat("===========================================================================\n")
cat("Binomial test: Frequency of Right comets of GENOTYPE is different from 0.5\n")
cat("===========================================================================\n")

binom.test(x = Up, n = total_UD, p = 0.5, alternative = c("two.sided"), conf.level = 0.95)

cat("===========================================================================\n")
cat("Binomial test: Frequency of Posterior comets of GENOTYPE is less than 0.5\n")
cat("===========================================================================\n")

binom.test(x = Posterior, n = total_AP, p = 0.5, alternative = c("less"), conf.level = 0.95)

cat("===========================================================================\n")
cat("Binomial test: Frequency of Posterior comets of GENOTYPE is greater than 0.5\n")
cat("===========================================================================\n")

binom.test(x = Posterior, n = total_AP, p = 0.5, alternative = c("greater"), conf.level = 0.95)

cat("===========================================================================\n")
cat("Binomial test: Frequency of Posterior comets of GENOTYPE is different from 0.5\n")
cat("===========================================================================\n")

binom.test(x = Posterior, n = total_AP, p = 0.5, alternative = c("two.sided"), conf.level = 0.95)

# ###########################################
# change test as wished: "<=" or ">=" or "=="
# ###########################################

cat("===========================================================================\n")
cat("Proportion of simulations where Right comets of GENOTYPE is <= observed\n")
cat("===========================================================================\n")

prop(~rbinom(100000, prob=0.5, size= total_UD) <= Up)

cat("===========================================================================\n")
cat("Proportion of simulations where Posterior comets of GENOTYPE is <= observed\n")
cat("===========================================================================\n")

prop(~rbinom(100000, prob=0.5, size= total_AP) <= Posterior)

cat("===========================================================================\n")
cat("Proportion of simulations where Right comets of GENOTYPE is >= observed\n")
cat("===========================================================================\n")

prop(~rbinom(100000, prob=0.5, size= total_UD) >= Up)

cat("===========================================================================\n")
cat("Proportion of simulations where Posterior comets of GENOTYPE is >= observed\n")
cat("===========================================================================\n")

prop(~rbinom(100000, prob=0.5, size= total_AP) >= Posterior)

sink()

X <- select(tbl_Larval_P, Angle)

br <- seq(0, 360, by=4)

ranges <- paste(head(br,-1), br[-1], sep=" - ")

freq <- hist(pull(X), breaks=br, include.lowest=TRUE, plot=FALSE)

Xtable <- data.frame(range = ranges, frequency = freq$counts )

Xtable <- Xtable %>% mutate(percentage = (frequency/ sum(frequency)) *100) %>% mutate(numbers=seq(1,360,4))

Xtable$range <- factor(Xtable$range, levels =Xtable$range)

plot <- ggplot(Xtable) + geom_bar(width = 4,stat="identity", position = position_nudge(x = 1), aes(x = numbers, y = percentage)) + coord_polar(start = -pi/2, direction =-1)
 
# pdf(file = "wt.pdf", width=7, height=7, encoding="MacRoman")
#
# plot + scale_x_continuous(limits= c(0,360),
# breaks= c(0, 45, 90, 135, 180, 225, 270, 315),
# labels=c(expression(paste(0^o)), expression(paste(45^o)), expression(paste(90^o)), expression(paste(135^o)), expression(paste(180^o)), expression(paste(225^o)), expression(paste(270^o)),expression(paste(315^o))), name = "EB1 comet angles in wt cells") + theme_grey(base_size = 22)


# dev.off()

plot <- plot + scale_x_continuous(limits= c(0,360),
breaks= c(0, 45, 90, 135, 180, 225, 270, 315),
labels=c("0º", "45º", "90º", "135º", "180º", "225º", "270º", "315º"), name = "EB1 comet angles in wt cells") + theme_grey(base_size = 22,base_family = "Arial")

plot

#library(Cairo)

ggsave(plot, filename = "GENOTYPE_cairo.pdf", device = cairo_pdf, width = 7, height = 7, units = "in")


tbl_GENOTYPE %>% group_by(file) %>% summarise(anterior=count(between(Angle, R2, L1)), posterior=n()-count(between(Angle, R1, L2)), total_AP = anterior + posterior, prop_post=(posterior*100)/total_AP)

sim.reps <- 10000

posterior.boot <- do(sim.reps) * mean((tbl_GENOTYPE %>% mutate(file= sample(tbl_GENOTYPE$file, replace=FALSE))  %>% group_by(file) %>% summarise(anterior=count(between(Angle, R2, L1)), posterior=n()-count(between(Angle, R1, L2)), total_AP = anterior + posterior, prop_post=(posterior*100)/total_AP))$prop_post)

cat("===========================================================================\n")
cat("Mean of the Posterior oriented MT in GENOTYPE cells. sim.reps resampling simulation\n")
cat("===========================================================================\n")

confint(posterior.boot, level= 0.95, method="quantile")



Acells <- tbl_Acells %>% group_by(id) %>% summarise(anterior=count(between(Angle, R2, L1)), posterior=n()-count(between(Angle, R1, L2)), total_ap = anterior + posterior, prop=(posterior*100)/total_ap) %>% mutate(position=rep("A",n()), comet=rep("posts",n()), cell_id=(1:10))

Pcells <- tbl_Pcells %>% group_by(id) %>% summarise(anterior=count(between(Angle, R2, L1)), posterior=n()-count(between(Angle, R1, L2)), total_ap = anterior + posterior, prop=(posterior*100)/total_ap) %>% mutate(position=rep("P",n()), comet=rep("posts",n()), cell_id=(11:20))

UAcells <- tbl_Acells %>% group_by(id) %>% summarise(up=count(between(Angle, R1, R2)), down=count(between(Angle, L1, L2)), total_ud = up + down, prop=(up*100)/total_ud) %>% mutate(position=rep("A",n()), comet=rep("ups",n()), cell_id=(1:10))

UPcells <- tbl_Pcells %>% group_by(id) %>% summarise(up=count(between(Angle, R1, R2)), down=count(between(Angle, L1, L2)), total_ud = up + down, prop=(up*100)/total_ud) %>% mutate(position=rep("P",n()), comet=rep("ups",n()), cell_id=(11:20))

cells <- bind_rows( mutate(Acells, id=as.character(id)), mutate(Pcells, id=as.character(id)), mutate(UAcells, id=as.character(id)), mutate(UPcells, id=as.character(id)) )

ggplot(cells, aes(x=position, y=prop_post)) + geom_jitter(width = 0.1, height = 0.1, size=5) + ylim(c(0,100)) + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width=0.3, colour="#D55E00") + stat_summary(fun.y = "mean", colour = "#D55E00", size = 2, geom = "point") + theme(text = element_text(size=20),panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + ylab("Posterior growing comets (%)") + xlab("Cell Position")

ggplot(cells, aes(x=position, y=prop_post))  + ylim(c(0,100)) + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width=0.2, colour="#D55E00") + stat_summary(fun.y = "mean", colour = "#D55E00", shape=4, size = 5, geom = "point") + theme(text = element_text(size=20),panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + ylab("Posterior growing comets (%)") + xlab("Cell Position") + geom_line(data=cells, aes(x=position, y=prop_post, group=cell_id)) + geom_point(size=3)

t.test(Acells$prop_post, Pcells$prop_post)

cells.shuffle <- do(10000) * diff(mean(prop_post ~ shuffle(position), data = cells))

cat("Mean difference <= observed, p=", nrow(filter(cells.shuffle, P <= obs))/10000)


library(grid)
library(gridtext) # devtools::install_github("clauswilke/gridtext")
library(gridExtra)
library(ggplot2)


ggplot(cells, aes(x=interaction(comet,position), y=prop, colour=comet)) + ylim(c(0,80)) + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width=0.3, colour="#999999") + stat_summary(fun.y = "mean", colour = "#999999", size = 4, geom = "point", shape=4) + theme(text = element_text(size=20),panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + ylab("Growing comets (%)") + xlab("A cells               P cells\nDirection of growth") + geom_line(data=cells, aes(x=interaction(comet,position), y=prop, group=cell_id), size=0.2, colour="black") + geom_point(size=3, position=position_jitterdodge(dodge.width=0.9, jitter.width=0)) + scale_x_discrete(labels=c("posterior", "up", "posterior",  "up")) + theme(legend.position = "none") -> gg

title <- "<span style='font-size:20pt'>Comets </span><span style='font-size:12pt'>comparison of direction of growth</span>"
tg <- richtext_grob(title, x = unit(10, "lines"), y = unit(2, "lines"))

grid.newpage()
grid.draw(
     arrangeGrob(tg, gg, heights=c(0.1, 0.8))
 )


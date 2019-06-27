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

extras <-
  c("mosaic", "dplyr")
if (length(setdiff(extras, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(extras, rownames(installed.packages())))
}

lapply(extras, require, character.only = TRUE)

# Angles

R1 <- 45
R2 <- 135
L1 <- 225
L2 <- 315

files_GENOTYPE <- list.files(path = ".", pattern = glob2rx("GENOTYPE*.csv"), full.names = T)

tbl_GENOTYPE <- sapply(files_GENOTYPE, read.csv, sep = "\t", simplify=FALSE) %>%  bind_rows(.id = "id")  %>% mutate(Angle = ifelse(Angle < 0, Angle + 36b0, Angle))

head(tbl_GENOTYPE)

Posterior_GENOTYPE<- nrownrow(tbl_GENOTYPE) - nrownrow(filter(tbl_GENOTYPE, between(Angle, R1, L2)))

Anterior_GENOTYPE <- nrownrow(filter(tbl_GENOTYPE, between(Angle, R2, L1)))

Right_GENOTYPE<- nrow(filter(tbl_GENOTYPE, between(Angle, R1, R2)))

Left_GENOTYPE <- nrow(filter(tbl_GENOTYPE, between(Angle, L1, L2)))

total_RL_GENOTYPE <- Right_GENOTYPE + Left_GENOTYPE 

total_AP_GENOTYPE <- Anterior_GENOTYPE + Posterior_GENOTYPE

x <- paste("\nAngles\n", L1, L2, R1, R2, "\n\n")

writeLines(x)

# #########################################################
# change test as wished: "less" or "greater" or "two.sided"
# #########################################################

binom.test(x = Right_GENOTYPE, n = total_RL_GENOTYPE, p = 0.5, alternative = c("less"), conf.level = 0.95)

# ###########################################
# change test as wished: "<=" or ">=" or "=="
# ###########################################

prop(~rbinom(100000, prob=0.5, size= total_RL_GENOTYPE) <= Right_GENOTYPE)

X <- select(tbl_GENOTYPE, Angle)

br <- seq(0, 360, by=5)

ranges <- paste(head(br,-1), br[-1], sep=" - ")

freq <- hist(pull(X), breaks=br, include.lowest=TRUE, plot=FALSE)

Xtable <- data.frame(range = ranges, frequency = freq$counts )

Xtable <- Xtable %>% mutate(percentage = (frequency/ sum(frequency)) *100) %>% mutate(numbers=seq(1,360,5))

Xtable$range <- factor(Xtable$range, levels =Xtable$range)

plot <- ggplot(Xtable) + geom_bar(width = 4,stat="identity", position = position_nudge(x = 1.5), aes(x = numbers, y = percentage)) + coord_polar(start = -pi/2, direction =-1)
 
plot + scale_x_continuous(limits= c(0,360),
breaks= c(0, 45, 90, 135, 180, 225, 270, 315),
labels=c("0º", "45º", "90º", "135º", "180º", "225º", "270º","315º"), name = "EB1 comet angles in GENOTYPE cells") + theme_grey(base_size = 22)

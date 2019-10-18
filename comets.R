comets <- read.csv("comets.csv")

comets <- tbl_df(comets) %>% group_by(Track.ID) %>% mutate(mean_α= round(mean(α,  na.rm = TRUE),2))

clean_comets <- bind_rows(tbl_df(comets) %>%
                            group_by(Track.ID) %>%
                            top_n(-1, Point.ID), tbl_df(comets) %>%
                            group_by(Track.ID) %>%
                            top_n(1, Point.ID))

clean_comets <- arrange(clean_comets,Track.ID)

clean_comets <- clean_comets %>%
  select(Track.ID, mean_α, -Point.ID, x, y) %>%
  gather(variable, value, -(mean_α), -(Track.ID))%>%
  mutate(Coo=rep(c("low", "high"), n()/2)) %>%
  unite(temp, variable, Coo) %>%
  group_by(Track.ID) %>%
  spread(temp, value) %>%
  select(Track.ID, x_low, y_low, x_high, y_high, mean_α) %>%
  mutate(Angle=round(ifelse((y_high-y_low)<0, rad2deg(atan((y_high-y_low)/(x_high-x_low)))-ifelse((x_high-x_low)<0, 180, 0),rad2deg(atan((y_high-y_low)/(x_high-x_low)))+ifelse((x_high-x_low)<0, 180, 0)),2)) %>%
  mutate(Diff_α=round(abs(Angle-mean_α),2))

write.csv(clean_comets, file = "clean_comets.csv")

result1 <- clean_comets %>% filter(Diff_α>10) %>% nrow()
result2 <- clean_comets %>% filter(Diff_α>10)
result4 <- "Everything is OK"

if(result1 > 0) cat("\n\nCheck the following track(s): ", result2$Track.ID) else(result4)



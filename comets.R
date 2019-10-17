comets <- read.csv("comets.csv")

clean_comets <- bind_rows(tbl_df(comets) %>%
                            group_by(Track.ID) %>%
                            top_n(-1, Point.ID), tbl_df(comets) %>%
                            group_by(Track.ID) %>%
                            top_n(1, Point.ID))

clean_comets <- arrange(clean_comets,Track.ID)

clean_comets <- clean_comets %>%
  select(Track.ID, -Point.ID, x, y) %>%
  gather(variable, value, -(Track.ID))%>%
  mutate(Coo=rep(c("low", "high"), n()/2)) %>%
  unite(temp, variable, Coo) %>%
  group_by(Track.ID) %>%
  spread(temp, value) %>%
  select(Track.ID, x_low, y_low, x_high, y_high) %>%
  mutate(total_deg=round(ifelse((y_high-y_low)<0, rad2deg(atan((y_high-y_low)/(x_high-x_low)))-ifelse((x_high-x_low)<0, 180, 0),rad2deg(atan((y_high-y_low)/(x_high-x_low)))+ifelse((x_high-x_low)<0, 180, 0)),2))

write.csv(clean_comets, file = "clean_comets.csv")

clean_comets


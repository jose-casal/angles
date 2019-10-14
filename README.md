# comets
transform comets.csv, the output of tracking EB1 comets in ImageJ:

> head(comets)
  Nr Track.ID Point.ID      x     y     t    I   Len   D2S D2R   D2P     v        α      Δα
1  1        1        1  7.614 4.330  0.00 72.0 0.000 0.000  NA    NA    NA       NA      NA
2  2        1        2  8.353 3.920  5.16 93.0 0.845 0.845  NA 0.845 0.164  -29.055      NA
3  3        1        3  8.928 3.674 10.32 37.2 1.470 1.469  NA 0.625 0.121  -23.199   5.856
4  4        1        4  9.051 3.181 15.48 73.8 1.978 1.840  NA 0.508 0.098  -75.964 -52.765
5  5        2        1 12.458 4.413  0.00 96.6 0.000 0.000  NA    NA    NA       NA      NA
6  6        2        2 12.129 3.879  5.16 56.4 0.627 0.627  NA 0.627 0.121 -121.608      NA

into a clean_comets.csv:

  > head(clean_comets)
  # A tibble: 6 x 5
  # Groups:   Track.ID [6]
    Track.ID x_low y_low x_high y_high
       <int> <dbl> <dbl>  <dbl>  <dbl>
  1        1  7.61  4.33   9.05   3.18
  2        2 12.5   4.41  10.2    2.07
  3        3  7.61  3.59   8.76   1.99
  4        4 13.9   5.48  12.1    1.74
  5        5  6.05  8.89   5.32   6.63
  6        6 13.4   8.48  12.2    5.07
    
# angles
R script to test if EB1 comet angles are distributed randomly between opposite sectors of a cell. You can change the size of the sectors by selecting different angles (R1, R2, L1, L2).

Change GENOTYPE with the actual one (substitute spaces with underlines and don't use strange characters).

csv files has to have the same number, order, and name of columns. One column has to be called "Angle"

An easy way of running the script is by using the comand line, for example:

$ cd ~/Data/tests/
$ ls -1

    angles.R
    pk_sple_UA.pk_01.csv
    pk_sple_UA.pk_02.csv
    pk_sple_UA.pk_03.csv
    pk_sple_UAS.pk_04.csv
    pk_sple_UAS.pk_05.csv
    pk_sple_UAS.pk_06.csv
    pk_sple_UAS.pk_07.csv
    pk_sple_UAS.pk_08.csv
    pk_sple_UAS.pk_09.csv
    pk_sple_UAS.pk_10.csv
    pk_sple_UAS.pk_11.csv
    pk_sple_UAS.pk_12.csv
    pk_sple_UAS.pk_13.csv
    pk_sple_UAS.pk_14.csv
    pk_sple_UAS.pk_15.csv
    pk_sple_UAS.pk_16.csv
    pk_sple_UAS.pk_17.csv
    pk_sple_UAS.pk_18.csv
    pk_sple_UAS.pk_19.csv
    pk_sple_UAS.pk_20.csv
    pk_sple_UAS.pk_21.csv
    pk_sple_UAS.pk_22.csv
    pk_sple_UAS.pk_23.csv
    pk_sple_UAS.pk_24.csv
    pk_sple_UAS.pk_25.csv
    pk_sple_UAS.pk_26.csv
    pk_sple_UAS.pk_27.csv
    pk_sple_UAS.pk_28.csv
    pk_sple_UAS.pk_29.csv
    pk_sple_UAS.pk_30.csv
    pk_sple_UAS.pk_31.csv
    pk_sple_UAS.pk_32.csv
    pk_sple_UAS.pk_33.csv
    pk_sple_UAS.pk_34.csv
    pk_sple_UAS.pk_35.csv
    pk_sple_UAS.pk_36.csv
    tests.Rproj
    
$ head pk_sple_UA.pk_01.csv

         Angle      Length
    1    -90        14
    2    -27.759    21.915
    3    102.095    14.221
    4    138.366    23.712
    5    128.660    13.509
    6    -70.017    11.705
    7     98.973    19.164
    8    105.945    14.705
    9    161.565    18.500
    
$ Rscript <(sed -e 's/GENOTYPE/pk_sple_UA.pk/g' angles.R)

Two similar tests are emplyoyed:

- binom.test from stats package. Change test as wished: "less" or "greater" or "two.sided".
- prop from mosaic package to test the proportion of trials giving a result "<=" or ">=" or "==" than the observed.

A nice rose diagram with the angles in 5 degrees bins is drawn with ggplot.

Alternatively, copy angles.R in your favourite folder and run AngleApp (an AppleScript application), to take care of all the details.

[Kaplan et al. (2019)](https://cran.r-project.org/web/packages/mosaic/vignettes/Resampling.pdf).

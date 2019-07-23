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

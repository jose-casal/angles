# angles
R script to test if EB1 comet angles are distributed randomly between opposite sectors of a cell. You can change the size of the sectors by selecting different angles (R1, R2, L1, L2).

Change GENOTYPE with the actual one (substitute spaces with underlines and don't use strange characters)

Two similar tests are emplyoyed:

- binom.test from stats package. Change test as wished: "less" or "greater" or "two.sided".
- prop from mosaic package to test the proportion of trials giving a result "<=" or ">=" or "==" than the observed.

		

A nice rose diagram with the angles in 5 degrees bins is also produced.

<a href="ftp://ftp.sam.math.ethz.ch/sfs/R-CRAN/web/packages/mosaic/vignettes/Resampling.pdf">Kaplan et al (2019)</a>
<a href="http://ftp.sam.math.ethz.ch/sfs/R-CRAN/web/packages/mosaic/vignettes/Resampling.pdf">here</a>

This site was built using [GitHub Pages](https://pages.github.com/).

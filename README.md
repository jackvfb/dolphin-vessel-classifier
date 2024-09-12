## Intro

This project is dedicated to enhancing my computational research abilities. My objective here is to reproduce the results of [Diamant et al. (2024)](https://doi.org/10.1038/s41598-024-56654-6), a study on the observed changes in dolphin vocalizations in the presence of underwater radiated noise from ships.

### Citation for original study
Diamant, R., Testolin, A., Shachar, I. et al. Observational study on the non-linear response of dolphins to the presence of vessels. Sci Rep 14, 6062 (2024). https://doi.org/10.1038/s41598-024-56654-6

The study found that a machine learning-based classifier could be trained on whistle features to discriminate between whistles emitted in the presence of URN versus those that were not.

## My strategy

Using the feature file from the original study, I will attempt to replicate the logic and methodology of their model fitting, validating, and testing.

I am implementing this using R and the tools I am most familiar with. This is in contrast to the tools used by the original authors, which were all MATLAB-based.

Along the way, I am striving to make my project as reproducible as possible, using purpose-built libraries, and GitHub flow to enhance reproducibility at every step of the way:
- `renv`: Making my environment reproducible, generates `renv/` and `renv.lockfile`
- `targets`: Used to write the script `_targets.R` that sets up the pipeline that I use to process data, fit the models, and generate results.
- Also I am trying to capture as much analysis as possible in a Quarto notebook `notebook.qmd` that I am publishing online

***Notebook with the reproduced figures is accessible [here](https://jackvfb.github.io/dolphin-vessel-classifier/notebook.html)***

## Feedback

Feedback from the public is much appreciated. Looking for more guidance from data scientists to improve my learning from this project. Thanks.

## Acknowledgements
Funded through the Association for the Sciences of Limnology and Oceanography (ASLO) / Limnology and Oceanography Research Exchange (LOREX). More information about the program [here](https://www.aslo.org/lorex/).

Thanks also to Roee and everyone at the Acoustic Navigation Laboratory in the Hatter Department of Marine Technologies, University of Haifa. [Lab website](https://sites.google.com/edu.haifa.ac.il/anl)

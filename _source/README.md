# Website source (R + Quarto)

This folder is the source of the website. The finished pages in the repository root
are built from it. GitHub ignores this folder when publishing because its name starts
with an underscore.

## How it works

- Pages are Quarto documents (`.qmd`). R reads the content files in `data/site/` and writes
  the news list, paper entries, statement list, project list and tables.
- Every chart is drawn in R with ggplot2.
- The MSc paper page re-runs the published regression in R from `data/msc/survey_responses.csv`,
  checks it against the SPSS values in `data/msc/spss_published_benchmarks.csv`, and repeats it
  in Python (NumPy, via `reticulate`).
- The Institutional Reinforcement Cycle explorer runs in the browser in Observable JavaScript.

## Everyday edits

| To change | Edit |
| --- | --- |
| News on the home page | `data/site/news.yml` (newest first) |
| Paper entries, links, SSRN | `data/site/papers.yml` |
| Statement list | `data/site/statements.yml` and the page in `research/statements/` |
| Presentations / UN conferences | `data/site/presentations.yml`, `data/site/conferences.yml` |
| Code page projects | `data/site/projects.yml` |
| SMART tables | `data/site/smart.yml` |
| Bio and links | `index.qmd` |
| CV or writing sample | replace the PDF in `assets/cv/` or `assets/papers/` (keep the file name) |
| Colours and layout | `styles/light.scss`, `styles/dark.scss`, `assets/css/site.css` |

## Rebuilding

**On your computer.** Install [R](https://www.r-project.org/) and [Quarto](https://quarto.org/), then in R:

```r
install.packages(c("knitr", "rmarkdown", "ggplot2", "yaml", "htmltools", "jsonlite", "reticulate"))
```

For the Python check: `python -m pip install numpy`. In this folder run `quarto render`
(or `quarto preview` to watch changes live), then upload the contents of `_site/` to the
repository root, replacing the old files.

**Automatically on GitHub (optional).** Follow the steps at the top of `publish-workflow.yml`.
After that, editing a file here on GitHub is enough: the site rebuilds itself.

## Data

`data/msc/` holds the anonymised MSc survey responses, codebook and SPSS benchmark values, copied
unchanged from
[multilateral-climate-finance-architecture](https://github.com/RavinduNawanjana/multilateral-climate-finance-architecture)
(commit `8988f73`). The source package states CC BY 4.0 for these materials.

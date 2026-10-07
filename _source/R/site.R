# Helpers shared by every page. Each .qmd sources this file in a setup chunk:
#   source(file.path(Sys.getenv("QUARTO_PROJECT_DIR", "."), "R", "site.R"))
# Content lives in data/site/*.yml; these functions turn it into HTML so that
# editing a YAML file is enough to update the site.

suppressPackageStartupMessages({
  library(yaml)
  library(htmltools)
  library(ggplot2)
})

project_dir <- function() Sys.getenv("QUARTO_PROJECT_DIR", ".")
site_path <- function(...) file.path(project_dir(), ...)
read_site <- function(name) yaml::read_yaml(site_path("data", "site", paste0(name, ".yml")))

# ---- small text helpers ------------------------------------------------------

# Inline markdown used in the YAML files: *italic* and **bold** only.
md <- function(x) {
  x <- htmltools::htmlEscape(x)
  x <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", x)
  x <- gsub("\\*([^*]+)\\*", "<em>\\1</em>", x)
  HTML(x)
}

# Turn a project-relative href (e.g. "research/x.qmd") into a link that works
# from the current page. `root` is "" on top-level pages, "../" one level down.
link_to <- function(href, root = "") {
  if (grepl("^(https?:|mailto:|#)", href)) return(href)
  paste0(root, sub("\\.qmd(#|$)", ".html\\1", href))
}

is_external <- function(href) grepl("^https?:", href)

# Plain bracketed links in the style of an academic CV: [SSRN] | [PDF] | [Code]
bracket_link <- function(text, href, root = "") {
  ext <- is_external(href) || grepl("\\.(pdf|txt)($|#)", href)
  tags$a(href = link_to(href, root), target = if (ext) "_blank", rel = if (ext) "noopener",
         paste0("[", text, "]"))
}

# Join tags with a plain " | " separator.
join_tags <- function(items, sep = " &nbsp;|&nbsp; ") {
  HTML(paste(vapply(items, as.character, ""), collapse = sep))
}

bracket_links <- function(links, root = "") {
  items <- lapply(links, function(l) bracket_link(l$text, l$href, root))
  tags$p(class = "paper-links", join_tags(items))
}

out <- function(x) knitr::asis_output(as.character(x))

# ---- lists -------------------------------------------------------------------

dated_list <- function(items, date_field = "date", n = Inf) {
  items <- head(items, n)
  out(tags$ul(class = "dated-list", lapply(items, function(i) {
    tags$li(tags$span(class = "dated-date", i[[date_field]]), " ", md(i$text))
  })))
}

news_list <- function(n = 6) dated_list(read_site("news"), "date", n)

# ---- papers ------------------------------------------------------------------

home_papers <- function(root = "") {
  papers <- read_site("papers")
  out(tags$ul(class = "plain-list", lapply(papers, function(p) {
    tags$li(
      tags$a(href = link_to(p$page, root), tags$em(p$title)),
      tags$br(),
      tags$span(class = "muted", p$home_status)
    )
  })))
}

paper_entries <- function(root = "") {
  papers <- read_site("papers")
  out(div(class = "research-timeline", lapply(papers, function(p) {
    div(
      class = "paper-block",
      tags$h3(tags$a(href = link_to(p$page, root), tags$em(p$title))),
      tags$p(class = "status", md(p$venue), " ", md(p$journal)),
      bracket_links(p$links, root),
      tags$p(p$summary)
    )
  })))
}

paper_links <- function(id, root = "../") {
  p <- Filter(function(x) x$id == id, read_site("papers"))[[1]]
  links <- Filter(function(l) !identical(l$href, p$page), p$links)
  out(tagList(tags$p(class = "status", md(p$venue), " ", md(p$journal)),
              bracket_links(links, root)))
}

# ---- statements --------------------------------------------------------------

statement_list <- function(root = "") {
  st <- read_site("statements")
  items <- lapply(st, function(s) {
    tags$li(HTML(paste0(as.character(tags$a(href = link_to(s$href, root), s$title)),
                        ", with reference to the work of ", s$reference)))
  })
  items <- c(items, list(tags$li(tags$a(href = link_to("research/statement-of-purpose.qmd", root), "Statement of purpose"))))
  out(tags$ul(class = "plain-list", items))
}

statement_header <- function(reference = NULL, kind = "Research statement") {
  line <- paste0(kind, " for the PhD programme in Environmental Economics, Yale School of the Environment, Fall 2027.")
  if (!is.null(reference)) line <- paste0(line, " Written with reference to the work of ", reference, ".")
  out(tags$p(class = "status", line))
}

statement_pager <- function(href, root = "../../") {
  st <- read_site("statements")
  seq_items <- c(st, list(list(title = "Statement of purpose", href = "research/statement-of-purpose.qmd")))
  hrefs <- vapply(seq_items, `[[`, "", "href")
  i <- match(href, hrefs)
  parts <- list()
  if (i > 1) parts <- c(parts, list(tags$a(href = link_to(seq_items[[i - 1]]$href, root), HTML("&larr; "), seq_items[[i - 1]]$title)))
  if (i < length(seq_items)) parts <- c(parts, list(tags$a(href = link_to(seq_items[[i + 1]]$href, root), seq_items[[i + 1]]$title, HTML(" &rarr;"))))
  parts <- c(parts, list(tags$a(href = paste0(root, "research.html#statements"), "All statements")))
  out(tags$p(class = "pager d-print-none", join_tags(parts)))
}

# ---- code page ---------------------------------------------------------------

join_words <- function(x) if (length(x) < 2) x else paste(paste(head(x, -1), collapse = ", "), "and", tail(x, 1))

project_entries <- function(group, root = "") {
  pr <- Filter(function(p) p$group == group, read_site("projects"))
  out(div(class = "project-list", lapply(pr, function(p) {
    url <- paste0("https://github.com/RavinduNawanjana/", p$repo)
    div(
      class = "project",
      tags$h3(tags$a(href = url, target = "_blank", rel = "noopener", p$name),
              if (!is.null(p$label)) tags$span(class = "muted project-label", paste0(" (", p$label, ")"))),
      tags$p(p$focus, " ", tags$span(class = "muted", paste0("Built with ", join_words(unlist(p$tools)), "."))),
      if (!is.null(p$image)) tags$figure(class = "project-figure",
        tags$img(src = link_to(p$image, root), alt = p$image_alt, loading = "lazy"),
        tags$figcaption(p$image_alt))
    )
  })))
}

# ---- plotting ----------------------------------------------------------------

site_colours <- c(leaf = "#2f6d4f", blue = "#0b3d8f", grey = "#8a938c", ink = "#17201a",
                  rule = "#d9ddd5", soft = "#e6efe7", amber = "#b5651d")

theme_site <- function(base_size = 12) {
  theme_minimal(base_size = base_size, base_family = "serif") +
    theme(
      plot.title.position = "plot",
      plot.title = element_text(face = "bold", colour = site_colours[["ink"]], size = rel(1.05)),
      plot.subtitle = element_text(colour = "#56605a", margin = margin(b = 8)),
      plot.caption = element_text(colour = "#56605a", hjust = 0, size = rel(0.8)),
      axis.text = element_text(colour = "#3a423c"),
      axis.title = element_text(colour = "#3a423c", size = rel(0.9)),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_line(colour = "#e7eae4"),
      legend.position = "top",
      legend.justification = "left",
      legend.title = element_blank(),
      plot.background = element_rect(fill = "white", colour = NA),
      plot.margin = margin(10, 14, 8, 10)
    )
}

# ---- survey analysis (shared by both paper pages) ----------------------------

cronbach_alpha <- function(items) {
  x <- as.matrix(items)
  k <- ncol(x)
  (k / (k - 1)) * (1 - sum(apply(x, 2, stats::var)) / stats::var(rowSums(x)))
}

# Standardised OLS: z-score outcome and predictors, fit, return slopes with 95% CIs.
standardised_ols <- function(scores, outcome, predictors) {
  z <- as.data.frame(scale(scores[, c(outcome, predictors)]))
  fit <- stats::lm(stats::reformulate(predictors, outcome), data = z)
  ci <- stats::confint(fit)[predictors, , drop = FALSE]
  s <- summary(fit)
  list(
    coefs = data.frame(
      construct = predictors,
      beta = unname(stats::coef(fit)[predictors]),
      lo = unname(ci[, 1]), hi = unname(ci[, 2]),
      p = unname(s$coefficients[predictors, 4]),
      stringsAsFactors = FALSE
    ),
    r2 = s$r.squared, adj_r2 = s$adj.r.squared, n = stats::nobs(fit)
  )
}

fmt3 <- function(x) sub("^(-?)0\\.", "\\1.", formatC(x, format = "f", digits = 3))
fmt_p <- function(p) ifelse(p < 0.001, "< .001", fmt3(p))

# ---- Institutional Reinforcement Cycle ----------------------------------------

# E[t+1] = (1 - delta) * E[t] + gamma * (I * P * B * T)^theta
simulate_irc <- function(I, P, B, T, delta = 0.15, gamma = 0.5, theta = 0.5,
                         E0 = 0.5, periods = 30) {
  E <- numeric(periods + 1)
  E[1] <- E0
  R <- gamma * (I * P * B * T)^theta
  for (t in seq_len(periods)) E[t + 1] <- (1 - delta) * E[t] + R
  data.frame(t = 0:periods, E = E)
}

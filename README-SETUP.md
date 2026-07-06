# Setup guide (read this, then delete it - it's already excluded from the built site)

## 1. Confirm your repo name
For a *user* site (living at `https://yourusername.github.io` with no extra
path), the repo itself must be named exactly:

    yourusername.github.io

Check this under your GitHub profile -> Repositories. If it's named
something else, edit `_config.yml` and set `baseurl: "/your-repo-name"`.

## 2. Upload the files
**Easiest way (no git needed):** go to your repo on GitHub -> "Add file" ->
"Upload files" -> drag in everything from this folder, preserving the folder
structure below (do it in a couple of batches if GitHub's uploader flattens
folders).

**Or with git:**
```bash
git clone https://github.com/RavinduNawanjana/RavinduNawanjana.github.io.git
cd RavinduNawanjana.github.io
# copy all files from this delivered folder into here, then:
git add .
git commit -m "Add site content"
git push
```

## 3. Final folder structure
```
yourusername.github.io/
├── _config.yml
├── index.md                  <- the entire site (bio, research, media)
├── .gitignore
├── favicon.ico                <- root-level fallback, fixes favicons not showing
├── robots.txt                 <- points crawlers at the sitemap for faster indexing
├── _layouts/
│   └── default.html
└── assets/
    ├── css/style.css
    ├── cv/Ravindu_Nawanjana_CV.pdf     <- your actual CV, already included
    ├── cite/stock-exchanges-citation.txt
    └── img/
        ├── headshot.jpg               <- your photo, already included
        ├── iisd-5fmap.jpg             <- IISD photo, already included
        ├── favicon-32.png
        └── favicon-180.png
```

Everything - your photo, CV, the IISD photo, and the favicon - is already in
place. Nothing left to add unless you want to change one of them.

## 4. A few things worth double-checking
- [ ] `_config.yml` -> `url:` is set to `https://ravindunawanjana.github.io`.
      Change it if your actual GitHub Pages address is different.
- [ ] The GitHub link in `index.md` points to `github.com/RavinduNawanjana` -
      confirm this is your exact username capitalization.
- [ ] The Google Scholar link is used exactly as you gave it
      (`...user=djgLs4EAAAAJ&hl`) - if it doesn't load correctly, Google
      Scholar profile links usually end in `&hl=en`, so you may want to add
      the `=en`.
- [ ] The working paper (MCF / G77 paper) has no link yet since it's not
      published - add one to `index.md` once it's available, next to the
      published paper's `[Link to publication]`.

## 5. Turn on GitHub Pages (if not already on)
Repo -> Settings -> Pages -> under "Build and deployment", Source = "Deploy
from a branch", Branch = `main`, folder = `/ (root)` -> Save.

## 6. Check it's live
Wait 1-2 minutes, then visit `https://yourusername.github.io`. GitHub
rebuilds automatically every time you push a change - no manual build step.

## 7. Getting it indexed on Google
`_config.yml` already includes the `jekyll-sitemap` plugin, so
`https://yourusername.github.io/sitemap.xml` will exist automatically.
`robots.txt` is already in place pointing at it, and the page now also
carries Open Graph tags, a canonical link, and a Person schema block for
richer indexing. To speed things up further: create a free Google Search
Console account, verify ownership (the "HTML tag" method just needs one meta
tag pasted into `_layouts/default.html`'s `<head>`), and submit the sitemap
URL there directly - this is the single biggest thing you can do to get
crawled quickly rather than waiting on Google to find it on its own.

## 8. About the favicon
If it still doesn't show after uploading: browsers cache favicons very
aggressively per-domain, more than almost anything else on a site. Before
assuming it's broken, try a hard refresh (Ctrl/Cmd+Shift+R) or open the site
in a private/incognito window. A root-level `favicon.ico` is now included
alongside the PNG versions specifically because some browsers ignore
`<link>` tags entirely and just request `/favicon.ico` directly - this
covers that case.

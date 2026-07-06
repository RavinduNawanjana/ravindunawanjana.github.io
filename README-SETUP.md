# Setup guide (read this, then delete it — it's excluded from the built site anyway)

## 1. Confirm your repo name
For a *user* site (the kind that lives at `https://yourusername.github.io` with
no extra path), the repo itself must be named exactly:

    yourusername.github.io

Check this under your GitHub profile → Repositories. If your existing Pages
repo is already named like this, skip to step 2. If it's named something
else (e.g. `my-website`), your site will instead live at
`https://yourusername.github.io/my-website` — in that case, edit `_config.yml`
and set `baseurl: "/my-website"`.

## 2. Upload the files
**Easiest way (no git needed):** go to your repo on GitHub → "Add file" →
"Upload files" → drag in everything from this folder, preserving the folder
structure shown below. Do this in a few batches if GitHub's uploader
flattens folders — or use the git method instead:

```bash
git clone https://github.com/yourusername/yourusername.github.io.git
cd yourusername.github.io
# copy all files from this delivered folder into here, then:
git add .
git commit -m "Add academic site content"
git push
```

## 3. Final folder structure in your repo
```
yourusername.github.io/
├── _config.yml
├── index.md
├── research.md
├── media.md
├── experience.md
├── .gitignore
├── _layouts/
│   └── default.html
└── assets/
    ├── css/
    │   └── style.css
    ├── img/
    │   ├── profile.jpg          ← add this yourself
    │   └── research/
    │       ├── exchanges-smart-framework.png       ← add this yourself
    │       └── institutional-reinforcement-cycle.png ← add this yourself
    └── cv/
        └── Ravindu_Nawanjana_CV.pdf  ← add this yourself
```

## 4. Things you need to personalize before it's "done"
- [ ] `assets/img/profile.jpg` — your headshot photo
- [ ] `assets/cv/Ravindu_Nawanjana_CV.pdf` — your actual CV
- [ ] `assets/img/research/*.png` — your two figures (see the README.txt in that folder for which ones)
- [ ] `media.md` — replace `VIDEO_ID` in the YouTube embed with your real video's ID
- [ ] `media.md` — replace the `#` link with the actual Earth Negotiations Bulletin photo page URL
- [ ] `research.md` — replace the two `#` links with real links to your published paper and working paper PDF
- [ ] `_config.yml` — set `url:` to your actual GitHub Pages address if different from the default
- [ ] `experience.md` — fill in the one-line CuteFela description
- [ ] Delete the three `README.txt` placeholder files once their images/PDF are in place
- [ ] Delete this file (`README-SETUP.md`) once you're done — it's already excluded from the built site either way

## 5. Turn on GitHub Pages (if not already on)
Repo → Settings → Pages → under "Build and deployment", Source = "Deploy from
a branch", Branch = `main`, folder = `/ (root)` → Save.

## 6. Check it's live
Wait 1–2 minutes, then visit `https://yourusername.github.io`. GitHub rebuilds
automatically every time you push a change — no manual build step.

## 7. Getting it indexed on Google
It'll usually get crawled and indexed within days to a couple of weeks on its
own. `_config.yml` already includes the `jekyll-sitemap` plugin, so
`https://yourusername.github.io/sitemap.xml` will exist automatically —
to speed up indexing, create a free Google Search Console account, verify
ownership (the "HTML tag" method just needs one meta tag pasted into
`_layouts/default.html`'s `<head>`), and submit that sitemap URL.

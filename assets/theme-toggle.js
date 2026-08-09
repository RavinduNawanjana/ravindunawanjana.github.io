/* Dark / light mode toggle.
   Pairs with the inline anti-flash script in <head> (see _layouts/default.html),
   which sets data-theme="dark" on <html> before first paint if that was the
   visitor's last choice, or their OS preference if they haven't chosen yet. */
(function () {
  function currentTheme() {
    return document.documentElement.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
  }

  function applyThemeColor(theme) {
    var meta = document.querySelector('meta[name="theme-color"]');
    if (meta) meta.setAttribute('content', theme === 'dark' ? '#12160f' : '#eef3ec');
  }

  function syncButton(button, theme) {
    var isDark = theme === 'dark';
    button.setAttribute('aria-pressed', String(isDark));
    button.setAttribute('aria-label', isDark ? 'Switch to light mode' : 'Switch to dark mode');
    var icon = button.querySelector('i');
    if (icon) icon.className = isDark ? 'fa-solid fa-sun' : 'fa-solid fa-moon';
  }

  document.addEventListener('DOMContentLoaded', function () {
    var button = document.getElementById('theme-toggle');
    if (!button) return;

    var theme = currentTheme();
    syncButton(button, theme);
    applyThemeColor(theme);

    button.addEventListener('click', function () {
      theme = currentTheme() === 'dark' ? 'light' : 'dark';
      if (theme === 'dark') {
        document.documentElement.setAttribute('data-theme', 'dark');
      } else {
        document.documentElement.removeAttribute('data-theme');
      }
      try { localStorage.setItem('theme', theme); } catch (e) { /* private mode etc. - ignore */ }
      syncButton(button, theme);
      applyThemeColor(theme);
    });

    // If the visitor hasn't made an explicit choice yet, keep following the OS.
    if (!localStorage.getItem('theme') && window.matchMedia) {
      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (e) {
        if (localStorage.getItem('theme')) return; // they've since chosen manually
        theme = e.matches ? 'dark' : 'light';
        if (theme === 'dark') {
          document.documentElement.setAttribute('data-theme', 'dark');
        } else {
          document.documentElement.removeAttribute('data-theme');
        }
        syncButton(button, theme);
        applyThemeColor(theme);
      });
    }
  });
})();

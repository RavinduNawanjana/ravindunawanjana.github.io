/* Dark / light mode toggle.
   Pairs with the inline anti-flash script in <head> (see _layouts/default.html),
   which sets data-theme="dark" on <html> before first paint only if that was
   the visitor's last explicit choice. Otherwise the site always starts light. */
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
  });
})();

const supported = ['en', 'ja', 'ko', 'zh-Hans', 'zh-Hant'];

export function resolveLanguage(preferences = []) {
  for (const preference of preferences) {
    if (typeof preference !== 'string') continue;
    const tag = preference.toLowerCase().replaceAll('_', '-');
    if (tag === 'zh' || tag.startsWith('zh-')) {
      if (tag.includes('-hant')) return 'zh-Hant';
      if (tag.includes('-hans')) return 'zh-Hans';
      return /-(tw|hk|mo)(-|$)/.test(tag) ? 'zh-Hant' : 'zh-Hans';
    }
    const base = tag.split('-')[0];
    if (supported.includes(base)) return base;
  }
  return 'en';
}

if (typeof document !== 'undefined') {
  const key = 'conjure-board-lang';
  function setLanguage(language) {
    const selected = resolveLanguage([language]);
    document.documentElement.lang = selected;
    document.querySelectorAll('[data-l]').forEach((element) => {
      element.classList.toggle('on', element.dataset.l === selected);
    });
    document.querySelectorAll('[data-language-select]').forEach((select) => {
      select.value = selected;
    });
    try { localStorage.setItem(key, selected); } catch { /* Storage is optional. */ }
  }
  let saved;
  try { saved = localStorage.getItem(key); } catch { /* Fall back to browser preferences. */ }
  const preferences = navigator.languages?.length ? navigator.languages : [navigator.language];
  setLanguage(resolveLanguage(supported.includes(saved) ? [saved] : preferences));
  document.querySelectorAll('[data-language-select]').forEach((select) => {
    select.addEventListener('change', () => setLanguage(select.value));
  });
}

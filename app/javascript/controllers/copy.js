document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.copy-button').forEach(button => {
    button.addEventListener('click', () => {
      const url = button.getAttribute('data-url');
      if (!url) return;

      navigator.clipboard.writeText(url)
        .then(() => {
          const originalText = button.querySelector('.copy-text');
          originalText.textContent = 'コピーしました';
          setTimeout(() => {
            originalText.textContent = 'コピー';
          }, 2000);
        })
        .catch(error => {
          console.error('コピー失敗:', error);
        });
    });
  });
});

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.copy-button').forEach(button => {
    button.addEventListener('click', () => {
      const url = button.getAttribute('data-url');
      if (!url) return;

      const copiedText = button.dataset.copiedText;
      const originalText = button.dataset.copyText;

      navigator.clipboard.writeText(url)
        .then(() => {
          const textElement = button.querySelector('.copy-text');
          if (!textElement) return;
          
          textElement.textContent = copiedText;

          setTimeout(() => {
            textElement.textContent = originalText;
          }, 2000);
        })
        .catch(error => {
          console.error('Failed to copy:', error);
        });
    });
  });
});

// Auto-resize textarea height
function autoResize() {
  this.style.height = 'auto';
  this.style.height = this.scrollHeight + 'px';
}
document.getElementById('set-llm').addEventListener('input', autoResize);

s.name.addEventListener('input', () => {
  clearTimeout(window.nameTimer);
  window.nameTimer = setTimeout(saveSettings, 600);
});

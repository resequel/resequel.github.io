// // Auto-resize textarea height
// function autoResize() {
//   this.style.height = 'auto';
//   this.style.height = this.scrollHeight + 'px';
// }
// document.getElementById('set-llm').addEventListener('input', autoResize);
//
// s.name.addEventListener('input', () => {
//   clearTimeout(window.nameTimer);
//   window.nameTimer = setTimeout(saveSettings, 600);
// });


//  /* SQL Keywords */
// function highlightSQL(editor) {
//    const keywords = /\b(SELECT|FROM|WHERE|AND|OR|INSERT|INTO|VALUES|UPDATE|SET|DELETE|JOIN|LEFT|RIGHT|INNER|OUTER|GROUP|BY|ORDER|LIMIT|OFFSET|CREATE|TABLE|PRIMARY|KEY|FOREIGN|REFERENCES|DROP|ALTER|AS|DISTINCT)\b/gi;
//
//   /* Aggregation & SQL Functions */
//   const functions = /\b(COUNT|SUM|AVG|MIN|MAX|STRING_AGG|ARRAY_AGG|BOOL_AND|BOOL_OR|COALESCE|NULLIF)\b(?=\s*\()/gi;
//
//   const strings  = /'([^']*)'/g;
//   const numbers  = /\b\d+(\.\d+)?\b/g;
//   const comments = /--.*$/gm;
//   const text = editor.innerText;
//
//     let html = text
//       .replace(/&/g, "&amp;")
//       .replace(/</g, "&lt;")
//       .replace(/>/g, "&gt;")
//       .replace(comments, `<span class="comment">$&</span>`)
//       .replace(strings, `<span class="string">$&</span>`)
//       .replace(numbers, `<span class="number">$&</span>`)
//       .replace(functions, `<span class="function">$&</span>`)
//       .replace(keywords, `<span class="keyword">$&</span>`);
//
//     editor.innerHTML = html;
//     moveCursorToEnd(editor);
//
//   }
//
//   function moveCursorToEnd(el) {
//     const range = document.createRange();
//     const sel = window.getSelection();
//     range.selectNodeContents(el);
//     range.collapse(false);
//     sel.removeAllRanges();
//     sel.addRange(range);
//   }

function escapeHTML(text = "") {
  return String(text)
    // .replace(/&/g, "&amp;")
    // .replace(/</g, "&lt;")
    // .replace(/>/g, "&gt;");
}

function highlightSQL(editor) {
  if (!editor) return;

  const keywords = /\b(SELECT|FROM|WHERE|AND|OR|INSERT|INTO|VALUES|UPDATE|SET|DELETE|JOIN|LEFT|RIGHT|INNER|OUTER|GROUP|BY|ORDER|LIMIT|OFFSET|CREATE|TABLE|PRIMARY|KEY|FOREIGN|REFERENCES|DROP|ALTER|AS|DISTINCT)\b/gi;
  const functions = /\b(COUNT|SUM|AVG|MIN|MAX|STRING_AGG|ARRAY_AGG|BOOL_AND|BOOL_OR|COALESCE|NULLIF)\b(?=\s*\()/gi;
  const strings = /'([^']*)'/g;
  const numbers = /\b\d+(\.\d+)?\b/g;
  const comments = /--.*$/gm;

  /* 1️⃣ Capture existing PARAM spans */
  const paramSpans = [];
  let html = editor.innerHTML.replace(
    /<span\s+class=["']params["']>(.*?)<\/span>/gi,
    (_, content) => {
      const key = `@@PARAM_${paramSpans.length}@@`;
      paramSpans.push(content);
      return key;
    }
  );

  /* 2️⃣ Escape everything else safely */
  html = escapeHTML(html);

  /* 3️⃣ Apply SQL highlighting */
  html = html
    .replace(comments, `<span class="comment">$&</span>`)
    .replace(strings, `<span class="string">$&</span>`)
    .replace(numbers, `<span class="number">$&</span>`)
    .replace(functions, `<span class="function">$&</span>`)
    .replace(keywords, `<span class="keyword">$&</span>`);

  /* 4️⃣ Restore PARAM spans untouched */
  paramSpans.forEach((value, i) => {
    const token = `@@PARAM_${i}@@`;
    html = html.replace(
      token,
      `<span class="params">${value}</span>`
    );
  });

  editor.innerHTML = html;
}



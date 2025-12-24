async function callGetCatalogAPI() {
            const dataset_name = document.getElementById('workload-dataset').value.trim();
            if (!dataset_name) {
                document.getElementById('result').textContent = 'Please Select a Workload!';
                return;
            }
            const payload = { dataset_name: dataset_name};
            try {
                 const response = await fetch("http://127.0.0.1:9000/get_catalog", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });

                if (response.ok) {
                    const figs = await response.json();
                    Object.entries(figs.figures).forEach(([key, fig]) => {
                        const targetDiv = document.getElementById(key);
                        if (!targetDiv) {
                            console.warn(`Div with id="${key}" not found`);
                            return;
                        }
                    targetDiv.innerHTML = "";
                    Plotly.newPlot(targetDiv, fig.data, fig.layout, { responsive: true, displayModeBar: false });
                    const resizeObserver = new ResizeObserver(() => {Plotly.Plots.resize(targetDiv);});
                    resizeObserver.observe(targetDiv);

                    callGetWorkloadAPI();
                });
                } else {
                    document.getElementById('result').textContent = 'Error: ' + JSON.stringify(data, null, 2);
                }
            } catch (error) {
                document.getElementById('fig_table_cardinality').textContent = 'Network error: ' + error.message;
            }
        }

async function callGetWorkloadAPI() {
            const dataset_name = document.getElementById('workload-dataset').value.trim();
            if (!dataset_name) {
                document.getElementById('result').textContent = 'Please Select a Workload!';
                return;
            }

            const payload = { dataset_name: dataset_name};

            try {
                const response = await fetch('http://127.0.0.1:9000/get_workload', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });

                if (response.ok) {
                    const figs = await response.json();
                    Object.entries(figs.figures).forEach(([key, fig]) => {
                        const targetDiv = document.getElementById(key);
                        if (!targetDiv) {
                            console.warn(`Div with id="${key}" not found`);
                            return;
                        }
                    targetDiv.innerHTML = "";
                    Plotly.newPlot(targetDiv, fig.data, fig.layout, { responsive: true, displayModeBar: false });
                    const resizeObserver = new ResizeObserver(() => {Plotly.Plots.resize(targetDiv);});
                    resizeObserver.observe(targetDiv);

                    // callGetTreemapAPI();

                });
                } else {
                    document.getElementById('result').textContent = 'Error: ' + JSON.stringify(data, null, 2);
                }
            } catch (error) {
                document.getElementById('result').textContent = 'Network error: ' + error.message;
            }
        }


async function callGetTemplateAPI() {
            const orig_query = ace.edit('orig_query').getValue()//document.getElementById('orig_query').innerText.trim();
            if (!orig_query) {
                document.getElementById('result').textContent = 'Please Select a Workload!';
                return;
            }
            const payload = { orig_query: orig_query};
            try {
                const response = await fetch('http://127.0.0.1:9000/get_template', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(payload)
                });

                if (response.ok) {
                    const template = await response.json();
                    Object.entries(template.data).forEach(([key, value]) => {
                        if (key === 'query_template'){
                            var editor = ace.edit("query_template");
                            editor.setValue(value, -1);
                            editor.setTheme("ace/theme/chrome");
                            editor.session.setMode("ace/mode/sql");
                            editor.setOptions({
                                enableBasicAutocompletion: true,
                                enableSnippets: true,
                                enableLiveAutocompletion: true,
                                fontSize: "16px",
                                showLineNumbers: true,    // Enable automatic line numbers
                                showGutter: true,
                                showPrintMargin: false
                            });
                            editor.setReadOnly(true);
                        }
                        else if (key === 'query_params'){
                            const targetDiv = document.getElementById("query_params");
                            targetDiv.innerHTML = value;
                        }
                        else if (key === 'query_analysis'){
                           drawTree(value);
                        }

                        // const targetDiv = document.getElementById(key);
                        // if (!targetDiv) {
                        //     console.warn(`Div with id="${key}" not found`);
                        //     return;
                        // }
                        // targetDiv.innerHTML = value;
                        // if (key === 'query_template'){
                        //     highlightSQL(targetDiv);
                        // }
                });

                } else {
                    document.getElementById('result').textContent = 'Error: ' + JSON.stringify(data, null, 2);
                }
            } catch (error) {
                document.getElementById('query_template').textContent = 'Network error: ' + error.message;
            }
        }


// function drawTree(data) {
//   const container = d3.select("#query_ast");
//
//   // Clear previous render
//   container.selectAll("*").remove();
//
//   const width = 1500;
//   const height = 600;
//
//   const svg = container.append("svg")
//     .attr("width", width)
//     .attr("height", height);
//
//   // Root group (top padding)
//   const g = svg.append("g")
//     .attr("transform", "translate(40,40)");
//
//   const root = d3.hierarchy(data, d => d.children);
//
//   // 🔽 TOP → DOWN layout
//   const treeLayout = d3.tree()
//     .size([width - 80, height - 120]);
//
//   treeLayout(root);
//
//   // 🔗 Vertical links
//   g.selectAll(".link")
//     .data(root.links())
//     .enter()
//     .append("path")
//     .attr("class", "link")
//     .attr("d", d3.linkVertical()
//       .x(d => d.x)
//       .y(d => d.y)
//     );
//
//   // 🌳 Nodes
//   const node = g.selectAll(".node")
//     .data(root.descendants())
//     .enter()
//     .append("g")
//     .attr("class", "node")
//     .attr("transform", d => `translate(${d.x},${d.y})`);
//
//   node.append("circle")
//     .attr("r", 5);
//
//   node.append("text")
//     .attr("dy", d => d.children ? -10 : 14)
//     .attr("text-anchor", "middle")
//     .text(d => d.data.label);
// }

function drawTree(data) {
  const container = d3.select("#query_ast");
  container.selectAll("*").remove();

  const width = container.node().clientWidth || 1600;
  const height = container.node().clientHeight || 600;

  // ---------- SVG + ZOOM ----------
  const svg = container.append("svg")
    .attr("width", width)
    .attr("height", height)
    .call(
      d3.zoom()
        .scaleExtent([0.5, 2])
        .on("zoom", (event) => {
          g.attr("transform", event.transform);
        })
    );

  const g = svg.append("g");

  let i = 0;
  const duration = 400;

  // ---------- ROOT ----------
  const root = d3.hierarchy(data, d => d.children);
  root.x0 = 0;
  root.y0 = 0;

  // Compact layout
  const treeLayout = d3.tree()
    .nodeSize([50, 80]);

  update(root);

  // ---------- UPDATE ----------
  function update(source) {
    treeLayout(root);

    const nodes = root.descendants();
    const links = root.links();

    // ---------- CENTER TREE ----------
    const xExtent = d3.extent(nodes, d => d.x);
    const treeWidth = xExtent[1] - xExtent[0];
    const offsetX = (width - treeWidth) / 2 - xExtent[0];

    g.transition()
      .duration(duration)
      .attr("transform", `translate(${offsetX},40)`);

    // ---------- LINKS ----------
    const link = g.selectAll("path.link")
      .data(links, d => d.target.id);

    link.enter()
      .append("path")
      .attr("class", "link")
      .attr("stroke", "#000")
      .attr("fill", "none")
      .attr("stroke-width", 1.2)
      .attr("d", () => diagonal(source, source))
      .merge(link)
      .transition()
      .duration(duration)
      .attr("d", d => diagonal(d.source, d.target));

    link.exit().remove();

    // ---------- NODES ----------
    const node = g.selectAll("g.node")
      .data(nodes, d => d.id || (d.id = ++i));

    const nodeEnter = node.enter()
      .append("g")
      .attr("class", "node")
      .attr("transform", `translate(${source.x0},${source.y0})`)
      .on("click", (e, d) => toggle(d));

    // Circle
    nodeEnter.append("circle")
      .attr("r", 1e-6)
      .attr("stroke", "#333")
      .attr("fill", d => colorByLabel(d.data.label));

nodeEnter.append("text")
  .attr("text-anchor", "middle")
  .attr("y", d => (!d.children && !d._children ? 16 : -10)) // 👈 key logic
  .style("font-size", "11px")
  .style("font-weight", "500")
  .style("pointer-events", "none")
  .text(d => d.data.label)
  .call(wrap, 80);



    // Tooltip
    nodeEnter.append("title")
      .text(d => d.data.label);

    const nodeUpdate = nodeEnter.merge(node);

    nodeUpdate.transition()
      .duration(duration)
      .attr("transform", d => `translate(${d.x},${d.y})`);

    nodeUpdate.select("circle")
      .attr("r", 6);

    node.exit().remove();

    nodes.forEach(d => {
      d.x0 = d.x;
      d.y0 = d.y;
    });
  }

  // ---------- TOGGLE ----------
  function toggle(d) {
    if (d.children) {
      d._children = d.children;
      d.children = null;
    } else if (d._children) {
      d.children = d._children;
      d._children = null;
    }
    update(d);
  }

  // ---------- LINK PATH ----------
  function diagonal(s, t) {
    return `
      M ${s.x} ${s.y}
      V ${(s.y + t.y) / 2}
      H ${t.x}
      V ${t.y}
    `;
  }

  // ---------- TEXT WRAP ----------
  function wrap(text, width) {
    text.each(function () {
      const textSel = d3.select(this);
      const words = textSel.text().split(/\s+/).reverse();
      let word;
      let line = [];
      let lineNumber = 0;
      const lineHeight = 1.0;
      let tspan = textSel.text(null)
        .append("tspan")
        .attr("x", 0)
        .attr("dy", "0em");

      while (word = words.pop()) {
        line.push(word);
        tspan.text(line.join(" "));
        if (tspan.node().getComputedTextLength() > width) {
          line.pop();
          tspan.text(line.join(" "));
          line = [word];
          tspan = textSel.append("tspan")
            .attr("x", 0)
            .attr("dy", ++lineNumber * lineHeight + "em")
            .text(word);
        }
      }
    });
  }

  // ---------- COLORS ----------
  function colorByLabel(label = "") {
    const l = label.toUpperCase();
    if (l === "SELECT") return "#bfdbfe";
    if (l === "FROM") return "#fde68a";
    if (l === "WHERE") return "#fecaca";
    if (l.includes("JOIN")) return "#ddd6fe";
    return "#dcfce7";
  }
}






// function drawTree(data) {
//   const container = d3.select("#query_ast");
//   container.selectAll("*").remove();
//
//   const width = 1600;
//   const height = 900;
//
//   const svg = container.append("svg")
//     .attr("width", width)
//     .attr("height", height)
//     .append("g")
//     .attr("transform", "translate(80,40)");
//
//   let i = 0; // unique id for nodes
//
//   const root = d3.hierarchy(data, d => d.children);
//   root.x0 = width / 2;
//   root.y0 = 0;
//
//   // Collapse all children initially
//   root.children?.forEach(collapse);
//
//   update(root);
//
//   // Collapse function
//   function collapse(d) {
//     if (d.children) {
//       d._children = d.children;
//       d._children.forEach(collapse);
//       d.children = null;
//     }
//   }
//
//   function update(source) {
//     const treeLayout = d3.tree().size([width - 160, height - 100]);
//     treeLayout(root);
//
//     // Nodes
//     const nodes = root.descendants();
//     const node = svg.selectAll("g.node")
//       .data(nodes, d => d.id || (d.id = ++i));
//
//     const nodeEnter = node.enter().append("g")
//       .attr("class", "node")
//       .attr("transform", d => `translate(${source.x0},${source.y0})`)
//       .on("click", (event, d) => {
//         if (d.children) {
//           d._children = d.children;
//           d.children = null;
//         } else {
//           d.children = d._children;
//           d._children = null;
//         }
//         update(d);
//       });
//
//     nodeEnter.append("circle")
//       .attr("r", 1e-6)
//       .attr("fill", d => d._children ? "lightsteelblue" : (d.data.status || "lightgreen"))
//       .attr("stroke", "#333")
//       .attr("stroke-width", 1.5);
//
//     nodeEnter.append("text")
//       .attr("dy", d => d.children || d._children ? -16 : 20)
//       .attr("text-anchor", "middle")
//       .style("font-family", "sans-serif")
//       .style("font-size", "12px")
//       .text(d => d.data.label || d.data.name);
//
//     // Transition nodes to new position
//     const nodeUpdate = nodeEnter.merge(node);
//     nodeUpdate.transition()
//       .duration(750)
//       .attr("transform", d => `translate(${d.x},${d.y})`);
//
//     nodeUpdate.select("circle")
//       .attr("r", 12)
//       .attr("fill", d => d._children ? "lightsteelblue" : (d.data.status || "lightgreen"));
//
//     // Links
//     const links = root.links();
//     const link = svg.selectAll("path.link")
//       .data(links, d => d.target.id);
//
//     const linkEnter = link.enter().insert("path", "g")
//       .attr("class", "link")
//       .attr("fill", "none")
//       .attr("stroke", "#000") // black links
//       .attr("stroke-width", 2)
//       .attr("d", d => {
//         const o = {x: source.x0, y: source.y0};
//         return diagonal(o, o);
//       });
//
//     const linkUpdate = linkEnter.merge(link);
//     linkUpdate.transition()
//       .duration(750)
//       .attr("d", d => diagonal(d.source, d.target))
//       .attr("stroke", "#000"); // ensure black during transition
//
//     link.exit().remove();
//
//     nodes.forEach(d => {
//       d.x0 = d.x;
//       d.y0 = d.y;
//     });
//   }
//
//   // Custom diagonal path (top-down)
//   function diagonal(s, t) {
//     return `M ${s.x} ${s.y}
//             V ${(s.y + t.y) / 2}
//             H ${t.x}
//             V ${t.y}`;
//   }
// }

// function drawTree(data) {
//   const container = d3.select("#query_ast");
//   container.selectAll("*").remove();
//
//   const width = 1600;
//   const height = 900;
//
//   const svg = container.append("svg")
//     .attr("width", width)
//     .attr("height", height)
//     .append("g")
//     .attr("transform", "translate(80,40)");
//
//   let i = 0; // unique id for nodes
//
//   const root = d3.hierarchy(data, d => d.children);
//   root.x0 = width / 2;
//   root.y0 = 0;
//
//   // Do NOT collapse nodes; show all by default
//   // root.children?.forEach(collapse);
//
//   update(root);
//
//   function update(source) {
//     const treeLayout = d3.tree().size([width - 160, height - 100]);
//     treeLayout(root);
//
//     // Nodes
//     const nodes = root.descendants();
//     const node = svg.selectAll("g.node")
//       .data(nodes, d => d.id || (d.id = ++i));
//
//     const nodeEnter = node.enter().append("g")
//       .attr("class", "node")
//       .attr("transform", d => `translate(${source.x0},${source.y0})`)
//       .on("click", (event, d) => {
//         if (d.children) {
//           d._children = d.children;
//           d.children = null;
//         } else {
//           d.children = d._children;
//           d._children = null;
//         }
//         update(d);
//       });
//
//     nodeEnter.append("circle")
//       .attr("r", 1e-6)
//       .attr("fill", d => d._children ? "lightsteelblue" : (d.data.status || "lightgreen"))
//       .attr("stroke", "#333")
//       .attr("stroke-width", 1.5);
//
//     nodeEnter.append("text")
//       .attr("dy", d => d.children || d._children ? -16 : 20)
//       .attr("text-anchor", "middle")
//       .style("font-family", "sans-serif")
//       .style("font-size", "12px")
//       .text(d => d.data.label || d.data.name);
//
//     // Transition nodes to new position
//     const nodeUpdate = nodeEnter.merge(node);
//     nodeUpdate.transition()
//       .duration(750)
//       .attr("transform", d => `translate(${d.x},${d.y})`);
//
//     nodeUpdate.select("circle")
//       .attr("r", 12)
//       .attr("fill", d => d._children ? "lightsteelblue" : (d.data.status || "lightgreen"));
//
//     // Links
//     const links = root.links();
//     const link = svg.selectAll("path.link")
//       .data(links, d => d.target.id);
//
//     const linkEnter = link.enter().insert("path", "g")
//       .attr("class", "link")
//       .attr("fill", "none")
//       .attr("stroke", "#000") // black links
//       .attr("stroke-width", 2)
//       .attr("d", d => {
//         const o = {x: source.x0, y: source.y0};
//         return diagonal(o, o);
//       });
//
//     const linkUpdate = linkEnter.merge(link);
//     linkUpdate.transition()
//       .duration(750)
//       .attr("d", d => diagonal(d.source, d.target))
//       .attr("stroke", "#000");
//
//     link.exit().remove();
//
//     nodes.forEach(d => {
//       d.x0 = d.x;
//       d.y0 = d.y;
//     });
//   }
//
//   // Custom diagonal path (top-down)
//   function diagonal(s, t) {
//     return `M ${s.x} ${s.y}
//             V ${(s.y + t.y) / 2}
//             H ${t.x}
//             V ${t.y}`;
//   }
// }





// async function callGetTreemapAPI() {
//     const dataset_name = document.getElementById('workload-dataset').value.trim();
//
//     if (!dataset_name) {
//         document.getElementById('result').textContent = 'Please Select a Dataset!';
//         return;
//     }
//
//     const payload = { dataset_name: dataset_name };
//
//     try {
//         const response = await fetch('http://127.0.0.1:9000/get_schema', {
//             method: 'POST',   // change to GET if your API is GET-only
//             headers: {
//                 'Content-Type': 'application/json'
//             },
//             body: JSON.stringify(payload)
//         });
//
//         if (!response.ok) {
//             document.getElementById('result').textContent =
//                 'Error: ' + response.status + ' ' + response.statusText;
//             return;
//         }
//
//         const treemapData = await response.json();
//
//         // Clear old chart
//         const chartDiv = document.getElementById('chart');
//         chartDiv.innerHTML = "";
//
//         renderTreemap(treemapData, chartDiv);
//
//     } catch (error) {
//         document.getElementById('result').textContent =
//             'Network error: ' + error.message;
//     }
// }
//
// function renderTreemap(data, container) {
//     const width = container.clientWidth;
//     const height = container.clientHeight || 600;
//
//     const root = d3.hierarchy(data)
//         .sum(d => d.value || d.record_count || 0)
//         .sort((a, b) => b.value - a.value);
//
//     d3.treemap()
//         .size([width, height])
//         .padding(2)
//         (root);
//
//     const tooltip = d3.select("body")
//         .append("div")
//         .attr("class", "tooltip")
//         .style("opacity", 0);
//
//     const nodes = d3.select(container)
//         .selectAll(".node")
//         .data(root.leaves())
//         .enter()
//         .append("div")
//         .attr("class", "node")
//         .style("position", "absolute")
//         .style("left", d => d.x0 + "px")
//         .style("top", d => d.y0 + "px")
//         .style("width", d => (d.x1 - d.x0) + "px")
//         .style("height", d => (d.y1 - d.y0) + "px")
//         .style("background", d => d3.interpolateBlues(d.depth / 4))
//         .on("mousemove", (event, d) => {
//             const table = d.parent.data;
//             tooltip
//                 .style("opacity", 1)
//                 .html(`
//                     <b>Table:</b> ${table.name}<br>
//                     <b>Column:</b> ${d.data.name}<br>
//                     <b>Records:</b> ${table.record_count}<br>
//                     <b>Owner:</b> ${table.metadata?.owner || "N/A"}
//                 `)
//                 .style("left", event.pageX + 10 + "px")
//                 .style("top", event.pageY + 10 + "px");
//         })
//         .on("mouseout", () => tooltip.style("opacity", 0));
//
//     nodes.append("div")
//         .style("font-size", "11px")
//         .style("padding", "4px")
//         .style("pointer-events", "none")
//         .html(d => `
//             <div><b>${d.parent.data.name}</b></div>
//             <div>${d.data.name}</div>
//         `);
//
//     // Auto-resize support
//     const resizeObserver = new ResizeObserver(() => {
//         d3.select(container).selectAll("*").remove();
//         renderTreemap(data, container);
//     });
//     resizeObserver.observe(container);
// }
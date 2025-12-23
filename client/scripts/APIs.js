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
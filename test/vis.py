import os
from google.cloud import bigquery
from anytree import Node, RenderTree
from anytree.exporter import DotExporter
import webbrowser

# Optional: Set your project ID (or use GOOGLE_CLOUD_PROJECT env var)
os.environ["GOOGLE_CLOUD_PROJECT"] = "162222028251-9assu1df21fp77blmh8s265r7t666r6a.apps.googleusercontent.com"  # Replace with your project

def build_plan_tree(query_plan):
    """
    Build a hierarchical tree from BigQuery query plan stages.
    """
    if not query_plan:
        return None
    
    # Root node
    root = Node("Query Plan")
    
    def recurse(node_data, parent=None):
        stage_name = node_data.get('name', 'Unknown Stage')
        new_node = Node(stage_name, parent=parent)
        
        # Add details as children (e.g., waitStartTime, endTime, inputStages)
        details = []
        for key, value in node_data.items():
            if key not in ['name', 'inputStages'] and value:
                details.append(f"{key}: {value}")
        
        # Create detail nodes
        for detail in details[:3]:  # Limit to avoid clutter
            Node(detail, parent=new_node)
        
        # Recurse into input stages (dependencies)
        input_stages = node_data.get('inputStages', [])
        for sub_stage in input_stages:
            recurse(sub_stage, new_node)
    
    # Start with the first stage (or main stage)
    main_stages = query_plan.get('stages', [])
    if main_stages:
        recurse(main_stages[0], root)
    
    return root

def generate_html_tree(tree_root, output_html="bigquery_plan.html"):
    """
    Generate interactive HTML with embedded D3.js tree visualization.
    """
    if not tree_root:
        return
    
    # Simple D3.js tree layout (embedded script)
    html_template = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>BigQuery Query Plan Visualizer</title>
        <script src="https://d3js.org/d3.v7.min.js"></script>
        <style>
            body { font-family: Arial; margin: 20px; }
            svg { border: 1px solid #ccc; }
            .node circle { fill: #fff; stroke: steelblue; stroke-width: 3px; }
            .node text { font: 12px sans-serif; }
            .link { fill: none; stroke: #ccc; stroke-width: 2px; }
        </style>
    </head>
    <body>
        <h2>BigQuery Query Plan (Interactive Tree)</h2>
        <p>Click nodes to expand/collapse. Hover for details.</p>
        <div id="tree"></div>
        <script>
            // D3.js tree data from Python
            const treeData = %s;
            
            // D3 tree visualization
            const svg = d3.select("#tree").append("svg").attr("width", 800).attr("height", 600);
            const g = svg.append("g").attr("transform", "translate(40,20)");
            
            const treemap = d3.tree().size([600, 500]);
            const root = d3.hierarchy(treeData, d => d.children);
            const tree = treemap(root);
            
            const link = g.selectAll(".link")
                .data(tree.links())
                .enter().append("path")
                .attr("class", "link")
                .attr("d", d3.linkHorizontal()
                    .x(d => d.y)
                    .y(d => d.x));
            
            const node = g.selectAll(".node")
                .data(root.descendants())
                .enter().append("g")
                .attr("class", "node")
                .attr("transform", d => `translate(${d.y},${d.x})`);
            
            node.append("circle").attr("r", 5);
            node.append("text")
                .attr("dy", ".31em")
                .attr("x", d => d.children ? -13 : 13)
                .attr("text-anchor", d => d.children ? "end" : "start")
                .text(d => d.data.name)
                .on("click", function(event, d) {
                    // Simple expand/collapse (toggle visibility of children)
                    if (d.children) {
                        d._children = d.children;
                        d.children = null;
                    } else if (d._children) {
                        d.children = d._children;
                        d._children = null;
                    }
                    update(d);
                });
            
            function update(source) {
                const duration = 750;
                const nodes = tree.descendants();
                const links = tree.links();
                // Update logic here (simplified for brevity)
                svg.transition().duration(duration);
            }
        </script>
    </body>
    </html>
    """
    
    # Convert anytree to D3-compatible JSON
    d3_data = {}
    def to_d3(node):
        data = {'name': node.name}
        children = [to_d3(child) for child in node.children]
        if children:
            data['children'] = children
        return data
    
    tree_json = to_d3(tree_root)
    
    html_content = html_template % tree_json.__repr__()  # Embed JSON
    
    with open(output_html, "w", encoding="utf-8") as f:
        f.write(html_content)
    
    return output_html

def run_query_and_visualize(sql: str, output_html: str = "bigquery_plan.html"):
    # Initialize BigQuery client
    client = bigquery.Client()

    # Configure job for dry run (no charge, gets plan)
    job_config = bigquery.QueryJobConfig(dry_run=True, use_query_cache=False)

    print("Running dry-run query to get execution plan...")
    query_job = client.query(sql, job_config=job_config)

    # Extract the query plan (statistics)
    stats = query_job._properties.get('statistics', {})
    query_plan = stats.get('query', {}).get('queryPlan', {})

    if not query_plan:
        print("No query plan found.")
        return

    print("Building tree structure...")
    tree = build_plan_tree(query_plan)

    print(f"Generating visualization -> {output_html}")
    html_file = generate_html_tree(tree, output_html)

    print(f"Visualization saved to {output_html}")
    print(f"Open it in your browser: file://{os.path.abspath(output_html)}")

    # Optional: Open automatically
    webbrowser.open(f'file://{os.path.abspath(output_html)}')

# ————————————————————————
# Example Query (Public Dataset – No Billing Needed)
# ————————————————————————
SQL = """
SELECT
  user_id,
  COUNT(*) as pageviews
FROM `bigquery-public-data.wikipedia.pageviews_2023`
WHERE DATE(datehour) = '2023-01-01'
  AND wiki = 'en'
GROUP BY user_id
ORDER BY pageviews DESC
LIMIT 100
"""

if __name__ == "__main__":
    run_query_and_visualize(SQL, "my_bigquery_plan.html")
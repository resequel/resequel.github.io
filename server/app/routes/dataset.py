from flask import Blueprint, jsonify, request, make_response, Response
from resequel.catalog.Catalog import load_catalog
from resequel.catalog.Catalog import CatalogInfo
from resequel.util.Config import load_query_params
import json
import plotly.express as px
from plotly.utils import PlotlyJSONEncoder
import plotly.graph_objects as go

catalog_bp = Blueprint("get_catalog", __name__)
workload_bp = Blueprint("get_workload", __name__)


@catalog_bp.route('/get_catalog', methods=['POST'])
def get_catalog():
    from ..config import _catalog_path
    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400

    data = request.get_json()

    dataset_name = data.get('dataset_name', '').strip()
    if not dataset_name:
        return jsonify({"error": "Datasetname are required"}), 400
    ds_name = dataset_name
    if ds_name in ["IMDB-JOB", "IMDB-Full"]:
        ds_name = "imdb"
    elif ds_name in ["DSB-SF10", "DSB-SF10-S100"]:
        ds_name = "dsb"
    elif ds_name in ["TPCH-SF10"]:
        ds_name = "tpch"
    else:
        ds_name = ds_name.lower()

    catalog_path = f"{_catalog_path}/{ds_name}"
    catalog = load_catalog(catalog_path=catalog_path)

    # ----------------------------------------------------
    sort_tables = dict()
    for tbl in catalog.get_table_names():
        table_fname = f"{catalog_path}/{tbl}.json"

        with open(table_fname, 'r') as file:
            raw_data = file.read().replace('\n', '')
            json_data = json.loads(raw_data)
            sort_tables[tbl] = json_data["rows"]

    sorted_dict = dict(sorted(sort_tables.items(), key=lambda item: item[1], reverse=True))

    data = dict()
    for table_name in sorted_dict.keys():
        data[table_name] = sorted_dict[table_name]

    x_labels = list(data.keys())
    y_values = list(data.values())
    # ----------------------------------------------------
    data_types = []
    data_type_tables = dict()
    for tbl in catalog.get_table_names():
        columns = catalog.schema[tbl]
        dt_dict = dict()
        for col in columns:
            type_ = col.get('type', 'Unknown')
            if type_ != "Unknown":
                data_types.append(type_)
                if type_ in dt_dict:
                    dt_dict[type_] += 1
                else:
                    dt_dict[type_] = 1
        data_type_tables[tbl] = dt_dict

    data_types = list(set(data_types))

    dt_data = []
    for dt in data_types:
        dt_y = []
        for tbl in catalog.get_table_names():
            if dt in data_type_tables[tbl]:
                dt_y.append(data_type_tables[tbl][dt])
            else:
                dt_y.append(0)
        dt_data.append(go.Bar(name=dt, x=catalog.get_table_names(), y=dt_y))

    fig_cols = go.Figure(data=dt_data)

    fig_cols.update_xaxes(categoryorder="array", categoryarray=x_labels, tickangle=-45)
    fig_cols.update_layout(barmode='stack', autosize=True, margin=dict(t=50, b=150, l=80, r=50),
                           legend=dict(orientation="h", yanchor="bottom", y=1.05, xanchor="center", x=0.5))

    fig = px.bar(
        x=x_labels,
        y=y_values,
        title=f"Dataset: {dataset_name}",
        labels={"x": "Table", "y": "Cardinality"},
        text_auto='.2s',
        color_discrete_sequence=["crimson"],  # <-- set all bars color
    )

    fig.update_traces(textposition='outside')

    fig.update_yaxes(
        range=[0, max(y_values) * 1.1],
        tickformat="~s"  # 133,110,000 → 133M
    )
    fig.update_xaxes(categoryorder="array", categoryarray=x_labels, tickangle=-45)

    # Set chart background to white
    fig.update_layout(autosize=True, margin=dict(t=50, b=150, l=80, r=50)
                      )

    payload = {"figures": {
        "fig_table_cardinality": fig,
        "fig_tables_dtype": fig_cols}
    }

    return Response(
        json.dumps(payload, cls=PlotlyJSONEncoder),
        mimetype="application/json"
    )

@workload_bp.route('/get_workload', methods=['POST'])
def get_workload():
    from ..config import _workload_path
    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400

    data = request.get_json()

    dataset_name = data.get('dataset_name', '').strip()
    if not dataset_name:
        return jsonify({"error": "Datasetname are required"}), 400
    ds_name = dataset_name
    if ds_name == "IMDB-Full":
        ds_name = "imdb_13k"
    elif ds_name  == "IMDB-JOB":
        ds_name = "imdb"
    elif ds_name  == "DSB-SF10":
        ds_name = "dsb"
    elif ds_name  == "DSB-SF10-S100":
        ds_name = "dsb_s100"
    elif ds_name  == "TPCH-SF10":
        ds_name = "tpch"
    else:
        ds_name = ds_name.lower()

    # _workload_path
    template_path = f"{_workload_path}/PostgreSQL/{ds_name}-template/"
    query_params = load_query_params(template_path=template_path)
    template_cardinality = dict()
    for qp in query_params:
        (tid, params) = query_params[qp]
        template_id = f"Template-{tid}"
        if template_id in template_cardinality:
            template_cardinality[template_id] = template_cardinality[template_id] + 1
        else:
            template_cardinality[template_id] = 1

    #------------------------------------------------
    TOP_N = 15
    WARM_COLORS = [
        "#E60000",  # Vibrant Red (kept as first)
        "#1f77b4",  # Deep Blue
        "#ff7f0e",  # Bright Orange
        "#2ca02c",  # Rich Green
        "#9467bd",  # Purple
        "#17becf",  # Cyan/Teal
        "#8c564b",  # Brown
        "#e377c2",  # Pink
        "#FDAC07",  # Web Orange
        "#bcbd22",  # Olive Green/Yellow
        "#47B39C",  # Muted Teal-Green (requested)
        "#FFC154",  # Bright Golden Yellow (requested)
        "#9552ea",  # Vibrant Purple (requested)
        "#64C2A6",  # Fresh Mint Green (requested)
        "#FB761F"  # Pumpkin Orange
    ]

    sorted_items = sorted(template_cardinality.items(), key=lambda x: x[1], reverse=True)

    labels_all = [k for k, _ in sorted_items]
    values_all = [v for _, v in sorted_items]
    labels_top = labels_all[:TOP_N]

    total = sum(values_all)
    percentages = [(v / total) * 100 for v in values_all]

    text = [
        f"{p:.1f}%" if p >= 3 else ""
        for p in percentages
    ]

    color_map = {
        label: WARM_COLORS[i % len(WARM_COLORS)]
        for i, label in enumerate(labels_all)
    }

    colors_all = [color_map[l] for l in labels_all]

    pie = go.Pie(
        labels=labels_all,
        values=values_all,
        hole=0.45,
        text=text,
        textinfo="text",
        textposition="inside",
        hoverinfo="label+percent+value",
        showlegend=False,
        sort=False,
        marker=dict(
            colors=colors_all,
            line=dict(color="white", width=1)
        ),
    )
    legend_traces = [
        go.Scatter(
            x=[None], y=[None],
            mode="markers",
            marker=dict(
                size=14,
                color=color_map[label],
                symbol="square"
            ),
            showlegend=True,
            name=label
        )
        for label in labels_top
    ]

    layout = go.Layout(
        title=f"Workload Templates and Cardinality (Dataset: {dataset_name})",

        # --- remove backgrounds ---
        paper_bgcolor="rgba(0,0,0,0)",
        plot_bgcolor="rgba(0,0,0,0)",

        # --- remove axes completely ---
        xaxis=dict(
            visible=False,
            showgrid=False,
            zeroline=False
        ),
        yaxis=dict(
            visible=False,
            showgrid=False,
            zeroline=False
        ),

        # --- legend ---
        showlegend=True,
        legend=dict(
            orientation="v",
            x=1.02,
            y=1
        ),

        margin=dict(l=40, r=220, t=60, b=40),

        annotations=[
            dict(
                text="Workload",
                x=0.5,
                y=0.5,
                font_size=18,
                showarrow=False
            )
        ]
    )

    fig = go.Figure( data=[pie] + legend_traces, layout=layout )

    # ===================
    x_labels = ["Workload Size", "Template Size"]
    y_values = [len(query_params), len(sorted_items)]
    colors = ["crimson", "#1f77b4"]  # one color per bar

    # Create the bar plot
    fig_ratio = px.bar(
        x=x_labels,
        y=y_values,
        title=f"Dataset: {dataset_name}",
        labels={"x": "", "y": "Count"},
        text_auto='.2s',
        color=x_labels,  # each x label is treated as a category
        color_discrete_sequence=colors
    )

    fig_ratio.update_traces(textposition='outside')

    fig_ratio.update_yaxes(
        range=[0, max([len(query_params), len(sorted_items)]) * 1.1],
        tickformat="~s"  # 133,110,000 → 133M
    )
    # fig.update_xaxes(categoryorder="array", categoryarray=x_labels, tickangle=-45)

    # Set chart background to white
    # fig_ratio.update_layout(autosize=True, margin=dict(t=50, b=150, l=80, r=50)
    fig_ratio.update_layout(
        showlegend=False,
        title_text=""  # remove title
    )


    payload = {"figures": {
        "fig_template_cardinality": fig, "fig_template_ratio": fig_ratio,
        }
    }

    return Response(
        json.dumps(payload, cls=PlotlyJSONEncoder),
        mimetype="application/json"
    )

# @catalog_bp.route('/get_catalog', methods=['POST'])
# def get_catalog():
#     from ..config import _catalog_path
#     if not request.is_json:
#         return jsonify({"error": "Request must be JSON"}), 400
#
#     data = request.get_json()
#
#     dataset_name = data.get('dataset_name', '').strip()
#     if not dataset_name:
#         return jsonify({"error": "Datasetname are required"}), 400
#     ds_name = dataset_name
#     if ds_name in ["IMDB-JOB", "IMDB-Full"]:
#         ds_name = "imdb"
#     elif ds_name in ["DSB-SF10", "DSB-SF10-S100"]:
#         ds_name = "dsb"
#     elif ds_name in ["TPCH-SF10"]:
#         ds_name = "tpch"
#     else:
#         ds_name = ds_name.lower()
#
#     catalog_path = f"{_catalog_path}/{ds_name}"
#     catalog =  load_catalog(catalog_path=catalog_path)
#     html_content = generate_html_from_catalog(catalog)
#     # return html_content, 200, {'Content-Type': 'text/html; charset=utf-8'}
#
#     # Example plot (replace with real data)
#     x = [1, 2, 3, 4, 5]
#     y = [10, 7, 12, 6, 9]
#
#     fig = go.Figure(
#         data=[
#             go.Scatter(
#                 x=x,
#                 y=y,
#                 mode="lines+markers",
#                 name=dataset_name
#             )
#         ],
#         layout=go.Layout(
#             title=f"Dataset: {dataset_name}",
#             xaxis_title="X",
#             yaxis_title="Y",
#             height=450
#         )
#     )
#
#     # Return JSON spec
#     return jsonify(fig.to_dict())


def generate_html_from_catalog(catalog_data: CatalogInfo):
    html_parts = []
    sort_tables = dict()
    for table_name in catalog_data.schema.keys():
        columns = catalog_data.schema[table_name]
        col_count = len(columns)
        sort_tables[table_name] = col_count

    sorted_dict = dict(sorted(sort_tables.items(), key=lambda item: item[1], reverse=True))

    for table_name in sorted_dict.keys():
        columns = catalog_data.schema[table_name]
        col_count = len(columns)

        card = f'<div class="table-card">'
        card += f'<div class="table-header">{table_name} [columns: <span class="columns-count">{col_count}</span>]</div>'
        card += '<table><tr><th></th><th>Column</th><th>Type</th><th>distinct</th><th>min</th><th>max</th><th>avg</th><th>std</th></tr>'

        pks = catalog_data.dependency[table_name]
        profile = catalog_data.profile[table_name]
        fk_icon = f'<span class="fk-icon">🔗</span>'
        pk_icon = '<span class="pk-icon">🔑</span>'

        for col in columns:
            name = col.get('name', 'Unknown')
            type_ = col.get('type', 'Unknown')
            distinct_count = profile[name].get('distinct_count', 0)
            min_value = profile[name].get('min', '')
            max_value = profile[name].get('max', '')
            avg_value = profile[name].get('avg', '')
            std_value = profile[name].get('stddev', '')

            if name in pks["primary_key"]:
                card += f'<tr><td style="padding=0px">{pk_icon}</td><td>{name}</td><td>{type_}</td><td>{distinct_count}</td><td>{min_value}</td><td>{max_value}</td><td>{avg_value}</td> <td>{std_value}</td> </tr>'

        for col in columns:
            name = col.get('name', 'Unknown')
            if name in pks["primary_key"]:
                continue
            type_ = col.get('type', 'Unknown')
            min_value = profile[name].get('min', '')
            max_value = profile[name].get('max', '')
            avg_value = profile[name].get('avg', '')
            std_value = profile[name].get('stddev', '')
            distinct_count = profile[name].get('distinct_count', 0)
            if name in pks["foreign_key"]:
                card += f'<tr><td>{fk_icon}</td><td>{name}</td><td>{type_}</td><td>{distinct_count}</td> <td>{min_value}</td><td>{max_value}</td><td>{avg_value}</td> <td>{std_value}</td></tr>'
            else:
                card += f'<tr><td></td><td>{name}</td><td>{type_}</td><td>{distinct_count}</td><td>{min_value}</td><td>{max_value}</td><td>{avg_value}</td> <td>{std_value}</td></tr>'

        card += '</table></div>'
        html_parts.append(card)

    # Join all cards with NO extra newlines
    return ''.join(html_parts)

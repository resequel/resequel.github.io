from flask import Blueprint, jsonify, request, make_response, Response
from resequel.catalog.Catalog import load_catalog
from resequel.catalog.Catalog import CatalogInfo
import json
import plotly.express as px
from plotly.utils import PlotlyJSONEncoder
import plotly.graph_objects as go


catalog_bp = Blueprint("get_catalog", __name__)

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
    catalog =  load_catalog(catalog_path=catalog_path)

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
                    dt_dict[type_] +=1
                else:
                    dt_dict[type_] = 1
        data_type_tables[tbl] = dt_dict

    data_types = list(set(data_types))
    print(data_type_tables)

    dt_data = []
    for dt in data_types:
        dt_y = []
        for tbl in catalog.get_table_names():
            if dt in data_type_tables[tbl]:
                dt_y.append(data_type_tables[tbl][dt])
            else:
                dt_y.append(0)
        dt_data.append(go.Bar(name=dt, x=catalog.get_table_names(), y=dt_y))
        print(f"{dt}  -> {dt_y}")


    fig_cols = go.Figure(data=dt_data)
    # Change the bar mode
    fig_cols.update_layout(barmode='stack',
                           width=700,
                           height=400,
                           margin=dict(t=50, b=150, l=80, r=50),
                        legend = dict(
                            orientation="h",  # <-- horizontal
                            yanchor="bottom",
                            y=1.05,  # <-- place above plot
                            xanchor="center",
                            x=0.5
                        )
    )




    fig_cols.write_html(f"/home/saeed/Documents//{dataset_name}.html", include_plotlyjs='cdn')
    # ---------------------


    x_labels = list(data.keys())
    y_values = list(data.values())

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
    fig.update_layout(
        width=700,
        height=400,
        margin=dict(t=50, b=150, l=80, r=50)
    )
    return Response(
        json.dumps(fig_cols, cls=PlotlyJSONEncoder),
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


def generate_html_from_catalog(catalog_data:CatalogInfo):
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

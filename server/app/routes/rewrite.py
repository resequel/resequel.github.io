from flask import Blueprint, jsonify, request, make_response, Response
from resequel.runquery.Templatizer_compile_v2 import SQLTemplateManager as SQLTemplateManager_V2
import json
from plotly.utils import PlotlyJSONEncoder
from sql_metadata import Parser

template_bp = Blueprint("get_template", __name__)

@template_bp.route('/get_template', methods=['POST'])
def get_template():
    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400

    data = request.get_json()

    input_query = data.get('orig_query', '').strip()
    manager = SQLTemplateManager_V2()
    query_id = "a.sql"
    template_index, template, params = manager.find_or_add_template(query=input_query, qid=query_id)
    query_tables = get_query_tables(input_query)

    # for key in params.keys():
    #     # <span class="string">$&</span>
    #     template = template.replace(key, f'<span class="params">{key}</span>')
    #
    # print(template)
    payload = {"data": {
        "query_template": template,
        "query_params": get_query_params_html_table(params)
        }
    }

    return Response(
        json.dumps(payload, cls=PlotlyJSONEncoder),
        mimetype="application/json"
    )


def get_query_tables(sql: str):
        tables = []
        parser = Parser(sql)
        tables.extend(parser.tables)
        return set(tables)

def get_query_params_html_table(params):
    html_tables = []
    index = 1
    for param in params.keys():
        html_tr = f"<tr><td>{index}</td><td>{param}</td><td>{params[param]}</td></tr>"
        html_tables.append(html_tr)
        index += 1

    return "\n".join(html_tables)



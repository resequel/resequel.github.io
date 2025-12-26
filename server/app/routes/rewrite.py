from flask import Blueprint, jsonify, request, make_response, Response
from resequel.runquery.Templatizer_compile_v2 import SQLTemplateManager as SQLTemplateManager_V2
from resequel.util.FileHandler import read_text_file_line_by_line
import json
from plotly.utils import PlotlyJSONEncoder
from sql_metadata import Parser
from sqlglot import parse_one, exp
import re
from typing import Dict, Any, List
import os
import sqlparse
import plotly.express as px


template_bp = Blueprint("get_template", __name__)
rewrite_bp = Blueprint("re_write", __name__)

_workload_queries = dict()
_template_rewrites = dict()
_query_params = dict()
_templates = dict()


@template_bp.route('/get_template', methods=['POST'])
def get_template():
    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400

    data = request.get_json()

    input_query = data.get('orig_query', '').strip()
    dbms = data.get('dbms', '').strip()
    manager = SQLTemplateManager_V2()
    query_id = "a.sql"
    template_index, template, params = manager.find_or_add_template(query=input_query, qid=query_id)
    query_tables = get_query_tables(input_query)

    query_ast = extract_semantic_dst(input_query)
    payload = {"data": {
        "query_template": template,
        "query_params": get_query_params_html_table(params),
        "query_analysis": query_ast
        }
    }

    return Response(
        json.dumps(payload, cls=PlotlyJSONEncoder),
        mimetype="application/json"
    )


@rewrite_bp.route('/re_write', methods=['POST'])
def re_write():
    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400

    data = request.get_json()

    input_query = data.get('orig_query', '').strip()
    dbms = data.get('dbms', '').strip()
    dataset_name = data.get('dataset_name', '').strip()
    number_of_versions = int(data.get('number_of_versions', '').strip())
    llm = data.get('llm', '').strip()
    version = get_versions(dataset_name=dataset_name,query=input_query, dbms=dbms, number_of_versions=number_of_versions, llm=llm)
    payload = {"data": version }
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


def strip_sql_comments(sql: str) -> str:
    """
    Remove SQL comments (-- and /* */).
    """
    sql = re.sub(r"/\*.*?\*/", "", sql, flags=re.DOTALL)
    sql = re.sub(r"--.*?$", "", sql, flags=re.MULTILINE)
    return sql.strip()


def parse_sql(sql: str) -> exp.Expression:
    clean_sql = strip_sql_comments(sql)
    return parse_one(clean_sql, dialect="postgres")


# def ast_to_raw_tree(node: exp.Expression) -> Dict[str, Any]:
#     """
#     Convert sqlglot AST to a raw JSON tree.
#     """
#     tree = {
#         "type": node.__class__.__name__,
#         "sql": node.sql(),
#         "children": []
#     }
#
#     for arg_name, arg_value in node.args.items():
#         if isinstance(arg_value, exp.Expression):
#             tree["children"].append({
#                 "type": arg_name,
#                 "children": [ast_to_raw_tree(arg_value)]
#             })
#
#         elif isinstance(arg_value, list):
#             children = [
#                 ast_to_raw_tree(v)
#                 for v in arg_value
#                 if isinstance(v, exp.Expression)
#             ]
#             if children:
#                 tree["children"].append({
#                     "type": arg_name,
#                     "children": children
#                 })
#
#     return tree

def ast_to_raw_tree(node: exp.Expression) -> dict:
    """
    Convert sqlglot AST to a raw JSON tree, without redundant intermediate nodes.
    """
    children = []

    for arg_name, arg_value in node.args.items():
        if isinstance(arg_value, exp.Expression):
            child_tree = ast_to_raw_tree(arg_value)
            if child_tree:
                children.append(child_tree)
        elif isinstance(arg_value, list):
            child_list = [ast_to_raw_tree(v) for v in arg_value if isinstance(v, exp.Expression)]
            children.extend(child_list)

    return {
        "type": node.__class__.__name__,
        "sql": node.sql(),
        "children": children
    }



# DROP_NODE_TYPES = {"this", "expression", "Identifier"}
# OPERATOR_LABELS = {
#     "GT": ">",
#     "LT": "<",
#     "GTE": ">=",
#     "LTE": "<=",
#     "EQ": "=",
#     "NEQ": "!=",
#     "And": "AND",
#     "Or": "OR",
# }
#
# KEYWORD_LABELS = {
#     "Select": "SELECT",
#     "From": "FROM",
#     "Where": "WHERE",
#     "SelectList": "SELECT LIST",
# }
#
# def normalize_tree(node: dict) -> dict | None:
#     if not node:
#         return None
#
#     children = []
#     for child in node.get("children", []):
#         norm = normalize_tree(child)
#         if norm:
#             children.append(norm)
#
#     node_type = node["type"]
#
#     # Drop parser noise
#     if node_type in {"this", "expression", "Identifier"}:
#         return children[0] if len(children) == 1 else None
#
#     # Table
#     if node_type == "Table":
#         return {
#             "type": "Table",
#             "label": node["sql"],
#             "children": []
#         }
#
#     # Column
#     if node_type == "Column":
#         return {
#             "type": "Column",
#             "label": node["sql"],
#             "children": []
#         }
#
#     # Literal
#     if node_type == "Literal":
#         return {
#             "type": "Literal",
#             "label": node["sql"],
#             "children": []
#         }
#
#     # Operators
#     if node_type in OPERATOR_LABELS:
#         return {
#             "type": node_type,
#             "label": OPERATOR_LABELS[node_type],
#             "children": children
#         }
#
#     # Expression list
#     if node_type == "expressions":
#         return {
#             "type": "SelectList",
#             "label": "SELECT LIST",
#             "children": children
#         }
#
#     # SQL keywords
#     label = KEYWORD_LABELS.get(node_type, node_type)
#
#     return {
#         "type": node_type,
#         "label": label,
#         "children": children
#     }

DROP_NODE_TYPES = {"this", "expression", "Identifier"}
OPERATOR_LABELS = {
    "GT": ">",
    "LT": "<",
    "GTE": ">=",
    "LTE": "<=",
    "EQ": "=",
    "NEQ": "!=",
    "And": "AND",
    "Or": "OR",
}
KEYWORD_LABELS = {
    "Select": "SELECT",
    "From": "FROM",
    "Where": "WHERE",
    "SelectList": "SELECT LIST",
}


def normalize_tree(node: dict) -> dict | None:
    if not node:
        return None

    normalized_children = []
    for child in node.get("children", []):
        norm_child = normalize_tree(child)
        if norm_child:
            normalized_children.append(norm_child)

    node_type = node["type"]

    # Drop noise nodes
    if node_type in DROP_NODE_TYPES:
        if len(normalized_children) == 1:
            return normalized_children[0]
        elif len(normalized_children) > 1:
            return {"type": "expressions", "label": "EXPRESSIONS", "children": normalized_children}
        else:
            return None

    # Map table/column/literal nodes
    if node_type in {"Table", "Column", "Literal"}:
        return {
            "type": node_type,
            "label": node["sql"],
            "children": []
        }

    # Map operators
    if node_type in OPERATOR_LABELS:
        return {
            "type": node_type,
            "label": OPERATOR_LABELS[node_type],
            "children": normalized_children
        }

    # Flatten expression lists
    if node_type in {"expressions", "SelectList"}:
        return {
            "type": "SelectList",
            "label": "SELECT LIST",
            "children": normalized_children
        }

    # Map SQL keywords
    label = KEYWORD_LABELS.get(node_type, node_type)

    return {
        "type": node_type,
        "label": label,
        "children": normalized_children
    }


def extract_semantic_dst(sql: str) -> Dict[str, Any]:
    ast = parse_sql(sql)
    raw_tree = ast_to_raw_tree(ast)
    semantic_tree = normalize_tree(raw_tree)
    return semantic_tree

def get_key(dbms: str, dataset_name):
    ds_name = dataset_name
    if ds_name == "IMDB-JOB":
        ds_name = "imdb"
    elif ds_name == "IMDB-Full":
        ds_name = "imdb_13k"
    elif ds_name == "DSB-SF10":
        ds_name = "dsb"
    elif ds_name == "DSB-SF10-S100":
        ds_name = "dsb_s100"
    elif ds_name == "TPCH-SF10":
        ds_name = "tpch"
    else:
        ds_name = ds_name.lower()

    key = f"{ds_name}-{dbms}"
    return key, ds_name

def cache_data(dbms: str, dataset_name):
    from ..config import _workload_path, _template_path, _rewrite_path

    key, ds_name = get_key(dbms, dataset_name)
    global _workload_queries
    global _template_rewrites
    global _query_params
    global _templates

    if key not in _workload_queries.keys():
        _workload_queries[key] = load_workload_queries(f"{_workload_path}/{dbms}/{ds_name}")
        _template_rewrites[key] = load_template_rewrites(f"{_template_path}/{dbms}/{ds_name}",f"{_template_rewrites}/{dbms}/{ds_name}")
        _query_params[key] = load_query_params(f"{_template_path}/{dbms}/{ds_name}-template")
        _template_rewrites[key], _, _, _templates[key] = load_template_rewrites(f"{_template_path}/{dbms}/{ds_name}",f"{_template_rewrites}/{dbms}/{ds_name}")

def load_workload_queries(workload_path: str):
    queries = dict()
    for path, subdirs, files in os.walk(workload_path):
        for name in files:
            if name.endswith(".sql"):
                head, tail = os.path.split(name)
                fname = os.path.join(path, name)
                query = read_text_file_line_by_line(fname)
                if "SELECT" in query or "select" in query:
                    query = format_sql(query)
                    queries[query] = tail
    return queries

def load_template_rewrites(template_path, rewrite_path: str):
    _templates_versions = dict()
    _templates_versions_IDS = dict()
    implement_funcs = dict()
    implement_funcs_str = dict()
    templates = dict()
    rewrite_names = []

    for path, subdirs, files in os.walk(template_path):
        for name in files:
            if name.endswith(".sql"):
                head, tail = os.path.split(name)
                fname = os.path.join(path, name)
                template = read_text_file_line_by_line(fname)
                template_name = tail.replace(".sql",'')
                templates[template_name] = template
                _templates_versions_IDS[template_name] = []

    for path, subdirs, files in os.walk(rewrite_path):
        for name in files:
            if  name.endswith(".sql") and not name.endswith("-list.sql") and not name.endswith("-0.sql"):
                head, tail = os.path.split(name)
                rewrite_names.append(tail.replace(".sql",''))
            elif name.endswith("-0.sql"):
                implement_funcs[name.replace("-0.sql",'')] = ""

    for tk in templates.keys():
        _templates_versions[templates[tk]] = []
        for rname in rewrite_names:
            if f"{tk}-" in rname:
                fname = os.path.join(rewrite_path, f"{rname}.sql")
                version = read_text_file_line_by_line(fname, ignore_comments=True, comment_tag='--')
                version = version.replace("'&&&'","&&&")
                _templates_versions[templates[tk]].append(version)

                version_id = rname.replace(f"{tk}-","")
                _templates_versions_IDS[tk].append((version_id,version))
        if tk in implement_funcs.keys():
            fname = os.path.join(rewrite_path, f"{tk}-0.sql")
            funcs = read_text_file_line_by_line(fname, ignore_comments=False, comment_tag='')
            implement_funcs_str[templates[tk]] = funcs
    return _templates_versions, _templates_versions_IDS, implement_funcs_str, templates

def load_query_params(template_path: str):
    from pathlib import Path
    import pandas as pd
    import json
    _query_params = dict()
    file_path = Path(f"{template_path}/query_params.csv")
    if file_path.exists():
        df = pd.read_csv(file_path, low_memory=False, encoding='utf-8')
        for index, row in df.iterrows():
            params_dict = json.loads(row['params'])
            _query_params[row['query_id']] = (row['template_id'], params_dict)

    return _query_params

def get_versions(dataset_name, query: str, dbms: str, number_of_versions:int, llm:str):
    from ..config import _workload_path, _rewrite_path
    import pandas as pd
    versions = {
        "verified_queries": [],
        "verified_sql": [],
        "verified_queries_exe":dict(),
        "error_queries": [],
        "error_sql": [],
        "failed_queries": [],
        "failed_sql": [],
        "selected_query": "",
        "verified_queries_plot": None
    }
    cache_data(dbms=dbms, dataset_name=dataset_name)
    key,ds_name = get_key(dbms, dataset_name)
    query = format_sql(query)

    verified_fname = f"{_rewrite_path}/{llm}/{dbms}/{ds_name}/Verify.dat"
    df_verify = None
    if os.path.exists(verified_fname):
        df_verify = pd.read_csv(verified_fname, low_memory=False, encoding='utf-8')

    if query in _workload_queries[key].keys():
        query_id = _workload_queries[key][query].replace(".sql", "")

        if df_verify is not None:
            tdf = df_verify[df_verify['query_id'] == query_id].reset_index()
            verified_queries = tdf["query_elapsed_time"].reset_index().iat[0, 1].split(";")
            verified_queries_exe = dict()
            verified_queries_ids = tdf["verified_queries"].reset_index().iat[0, 1].split(";")
            verified_queries_sqls = []
            if tdf["error_count"].reset_index().iat[0, 1] > 0:
                error_query_ids =  tdf["error_queries"].reset_index().iat[0, 1].split(";")
            else:
                error_query_ids = []
            error_queries_sqls = []

            if tdf["failed_count"].reset_index().iat[0, 1] > 0:
                failed_queries_ids = tdf["failed_queries"].reset_index().iat[0, 1].split(";")
            else:
                failed_queries_ids = []

            selected_query_id = f'{tdf["selected_query"].reset_index().iat[0, 1]}'

            failed_queries_sqls = []

            all_ids = []
            all_ids.extend(verified_queries_ids)
            all_ids.extend(error_query_ids)
            all_ids.extend(failed_queries_ids)

            for ids in all_ids:
                query_rewrite_fname = f"{_workload_path}/{dbms}/{ds_name}-{llm}/{query_id}-{ids}.sql"
                if os.path.exists(query_rewrite_fname):
                    new_query = read_text_file_line_by_line(query_rewrite_fname, ignore_comments=False)
                    if ids in verified_queries_ids:
                        verified_queries_sqls.append(new_query)
                    elif ids in error_query_ids:
                        error_queries_sqls.append(new_query)
                    elif ids in failed_queries_ids:
                        failed_queries_sqls.append(new_query)

            for vids in verified_queries:
                qt = vids.split(":")
                verified_queries_exe[qt[0]] = float(qt[1])

            versions["verified_queries"] = verified_queries_ids
            versions["verified_queries_sql"] = verified_queries_sqls
            versions["verified_queries_exe"] = verified_queries_exe
            versions["failed_queries"] = failed_queries_ids
            versions["failed_queries_sql"] = failed_queries_sqls
            versions["error_queries"] = error_query_ids
            versions["error_queries_sql"] = error_queries_sqls

            query_select_fname = f"{_workload_path}/{dbms}/{ds_name}-{llm}-select/{query_id}.sql"
            if os.path.exists(query_select_fname):
                versions["selected_query"] = read_text_file_line_by_line(query_select_fname, ignore_comments=False, comment_tag='--')

            versions["verified_queries_plot"] = plot_verified_performance_exe(verified_queries_exe=verified_queries_exe,selected_query_id=selected_query_id, orig_query_id="21")


    else:
        print("NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN")
        pass

    return versions


def plot_verified_performance_exe(verified_queries_exe: dict(), selected_query_id: str, orig_query_id:str):
    verified_queries_exe = dict(sorted(verified_queries_exe.items(), key=lambda item: item[1]))

    x_labels = []
    y_values = []
    colors = []
    label_map = {}
    for k in verified_queries_exe.keys():
        x_labels.append(k)
        y_values.append(verified_queries_exe[k])
        if k == selected_query_id:
            colors.append("crimson")
            label_map[k] = f'Selected Version'
        elif k == orig_query_id:
            colors.append("#1f77b4")
            label_map[k] = f'Orig Query'
        else:
            colors.append("#ffc107")
            label_map[k] = f'V {k}'


    # Create the bar plot
    fig = px.bar(
        x=x_labels,
        y=y_values,
        #title=f"Dataset: {dataset_name}",
        labels={"x": "", "y": "Execution Time [ms]"},
        text_auto='.2s',
        color=x_labels,  # each x label is treated as a category
        color_discrete_sequence=colors,

    )

    fig.update_traces(textposition='outside')
    fig.for_each_trace(
        lambda t: t.update(name=label_map.get(t.name, t.name))
    )

    fig.update_layout(
        autosize=True, margin=dict(t=10, b=3, l=3, r=3),
        showlegend=True,
        title_text=""  # remove title
    )

    return fig

def normalize_sql(query: str) -> str:
        # Remove leading/trailing whitespace and collapse all whitespace to a single space
        normalized = re.sub(r'\s+', ' ', query.strip())
        return normalized

def format_sql(query: str) -> str:
        query = normalize_sql(query)
        try:
            formatted = sqlparse.format(
                query,
                reindent=True,
                keyword_case='upper'  # Options: 'upper', 'lower', 'capitalize'
            )
            return formatted
        except Exception:
            return query
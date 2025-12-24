from flask import Blueprint, jsonify, request, make_response, Response
from resequel.runquery.Templatizer_compile_v2 import SQLTemplateManager as SQLTemplateManager_V2
import json
from plotly.utils import PlotlyJSONEncoder
from sql_metadata import Parser
from sqlglot import parse_one, exp
import re
from typing import Dict, Any, List

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
    query_ast = extract_semantic_dst(input_query)
    print(query_ast)
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
    """
    Normalize the raw AST tree to a clean JSON tree for visualization.
    Removes redundant wrapper nodes and maps operators/keywords to labels.
    """
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


# -------------------------------------------------
# 5. Public API
# -------------------------------------------------

def extract_semantic_dst(sql: str) -> Dict[str, Any]:
    """
    SQL → semantic DST (ready for visualization)
    """
    ast = parse_sql(sql)
    raw_tree = ast_to_raw_tree(ast)
    semantic_tree = normalize_tree(raw_tree)
    return semantic_tree





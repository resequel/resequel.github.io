# from flask import Flask, request, jsonify
# from flask_cors import CORS  # Needed because client and server may run on different ports
#
# app = Flask(__name__)
# CORS(app)  # Allow cross-origin requests from the client (important during development)
#
#
# @app.route('/api/greet', methods=['POST'])
# def greet():
#     if not request.is_json:
#         return jsonify({"error": "Request must be JSON"}), 400
#
#     data = request.get_json()
#
#     param1 = data.get('name', '').strip()
#     param2 = data.get('age', '').strip()
#     param3 = data.get('city', '').strip()
#
#     if not all([param1, param2, param3]):
#         return jsonify({"error": "All three parameters (name, age, city) are required"}), 400
#
#     # Simple processing
#     result = {
#         "message": f"Hello {param1}, you are {param2} years old and live in {param3}.",
#         "received": {
#             "name": param1,
#             "age": param2,
#             "city": param3
#         }
#     }
#
#     return jsonify(result)
#
#
# if __name__ == '__main__':
#     print("Flask server running on http://127.0.0.1:5000")
#     app.run(port=5000, debug=True)
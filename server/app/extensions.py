from flask_cors import CORS

def register_extensions(app):
    """
    Initialize Flask extensions here.
    Example:
        db.init_app(app)
        jwt.init_app(app)
    """
    CORS(app)

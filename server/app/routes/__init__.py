from .dataset import catalog_bp
from .dataset import workload_bp


def register_blueprints(app):
    app.register_blueprint(catalog_bp)
    app.register_blueprint(workload_bp)

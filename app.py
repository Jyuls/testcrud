from flask import Flask, request, jsonify, render_template
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

# Conexión a tu base de datos en Render
def get_db_connection():
    return psycopg2.connect(
        "postgresql://root:7mgTqqo94F85Rv2akV9QcpqAL5Uwk9KS@dpg-d39nbjumcj7s739g2v2g-a.oregon-postgres.render.com/minkglobal",
        sslmode='require'
    )

# Ruta principal: login
@app.route("/")
def index():
    return render_template("index.html")

# Ruta dashboard: vista CRUD
@app.route("/dashboard")
def dashboard():
    return render_template("dashboard.html")

# ===== LOGIN =====
@app.route("/login", methods=["POST"])
def login():
    try:
        data = request.json
        if not data or "username" not in data or "password" not in data:
            return jsonify({"success": False, "error": "Datos incompletos"})

        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute('SELECT * FROM "Usuarios" WHERE "Nombre(s)" = %s', (data["username"],))
        user = cur.fetchone()
        cur.close()
        conn.close()

        if user and user["Contraseña"] == data["password"]:
            user_data = {k: v for k, v in user.items() if k != "Contraseña"}
            return jsonify({"success": True, "user": user_data})
        return jsonify({"success": False, "error": "Credenciales inválidas"})
    except Exception as e:
        print("Error en login:", str(e))
        return jsonify({"success": False, "error": "Error del servidor"}), 500

# ===== CRUD GENERAL =====
TABLAS_PERMITIDAS = [
    "TipoUsuario", "Compañia", "Usuarios", "DocumentosPFisicos", "Domicilio",
    "PersonasFisicas", "DocumentosPMoral", "CapitalSocial", "FormaAdmin",
    "Apoderados", "DomicilioLegal", "DomicilioOperativo", "PersonaMoral"
]

@app.route("/<tabla>", methods=["GET"])
def get_tabla(tabla):
    tabla = tabla.strip().replace('"', '')
    if tabla not in TABLAS_PERMITIDAS:
        return jsonify({"error": "Tabla no permitida"}), 404
    try:
        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)
        # Obtener nombre de la primera columna
        cur.execute(f'SELECT * FROM "{tabla}" LIMIT 1')
        colnames = [desc[0] for desc in cur.description]
        idcol = colnames[0]
        cur.execute(f'SELECT * FROM "{tabla}" ORDER BY "{idcol}"')
        rows = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify(rows)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/<tabla>", methods=["POST"])
def agregar(tabla):
    tabla = tabla.strip().replace('"', '')
    if tabla not in TABLAS_PERMITIDAS:
        return jsonify({"error": "Tabla no permitida"}), 404
    try:
        data = request.json
        conn = get_db_connection()
        cur = conn.cursor()
        cols = ", ".join([f'"{k}"' for k in data.keys()])
        vals = ", ".join(["%s"] * len(data))
        cur.execute(f'INSERT INTO "{tabla}" ({cols}) VALUES ({vals})', list(data.values()))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/<tabla>/<idcol>/<idval>", methods=["GET"])
def obtener(tabla, idcol, idval):
    tabla = tabla.strip().replace('"', '')
    if tabla not in TABLAS_PERMITIDAS:
        return jsonify({"error": "Tabla no permitida"}), 404
    try:
        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute(f'SELECT * FROM "{tabla}" WHERE "{idcol}" = %s', (idval,))
        row = cur.fetchone()
        cur.close()
        conn.close()
        return jsonify(row if row else {"error": "No encontrado"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/<tabla>/<idcol>/<idval>", methods=["PUT"])
def actualizar(tabla, idcol, idval):
    tabla = tabla.strip().replace('"', '')
    if tabla not in TABLAS_PERMITIDAS:
        return jsonify({"error": "Tabla no permitida"}), 404
    try:
        data = request.json
        conn = get_db_connection()
        cur = conn.cursor()
        set_clause = ", ".join([f'"{k}" = %s' for k in data.keys()])
        values = list(data.values()) + [idval]
        cur.execute(f'UPDATE "{tabla}" SET {set_clause} WHERE "{idcol}" = %s', values)
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/<tabla>/<idcol>/<idval>", methods=["DELETE"])
def eliminar(tabla, idcol, idval):
    tabla = tabla.strip().replace('"', '')
    if tabla not in TABLAS_PERMITIDAS:
        return jsonify({"error": "Tabla no permitida"}), 404
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(f'DELETE FROM "{tabla}" WHERE "{idcol}" = %s', (idval,))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=True)
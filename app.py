from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg2
import os

app = Flask(__name__)
CORS(app)

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://root:7mgTqqo94F85Rv2akV9QcpqAL5Uwk9KS@dpg-d39nbjumcj7s739g2v2g-a.oregon-postgres.render.com/minkglobal")

conn = psycopg2.connect(DATABASE_URL)

@app.route("/")
def home():
    return "API funcionando 🚀"

# ===== LOGIN =====
@app.route("/login", methods=["POST"])
def login():
    data = request.json
    cur = conn.cursor()
    cur.execute('SELECT * FROM "Usuarios" WHERE "Nombre(s)"=%s AND "Contraseña"=%s',
                (data["username"], data["password"]))
    row = cur.fetchone()
    colnames = [desc[0] for desc in cur.description] if row else []
    cur.close()
    if row:
        return jsonify({"success": True, "user": dict(zip(colnames, row))})
    return jsonify({"success": False})

# ===== CRUD GENÉRICO =====
@app.route("/<tabla>", methods=["GET"])
def get_all(tabla):
    cur = conn.cursor()
    cur.execute(f'SELECT * FROM "{tabla}"')
    rows = cur.fetchall()
    colnames = [desc[0] for desc in cur.description]
    cur.close()
    return jsonify([dict(zip(colnames, r)) for r in rows])

@app.route("/<tabla>/<idcol>/<idval>", methods=["GET"])
def get_one(tabla, idcol, idval):
    cur = conn.cursor()
    cur.execute(f'SELECT * FROM "{tabla}" WHERE "{idcol}"=%s', (idval,))
    row = cur.fetchone()
    colnames = [desc[0] for desc in cur.description] if row else []
    cur.close()
    if row:
        return jsonify(dict(zip(colnames, row)))
    return jsonify({})

@app.route("/<tabla>", methods=["POST"])
def create(tabla):
    data = request.json
    cols = ",".join([f'"{k}"' for k in data.keys()])
    vals = ",".join(["%s"] * len(data))
    cur = conn.cursor()
    cur.execute(f'INSERT INTO "{tabla}" ({cols}) VALUES ({vals}) RETURNING *', tuple(data.values()))
    row = cur.fetchone()
    colnames = [desc[0] for desc in cur.description]
    conn.commit()
    cur.close()
    return jsonify(dict(zip(colnames, row)))

@app.route("/<tabla>/<idcol>/<idval>", methods=["PUT"])
def update(tabla, idcol, idval):
    data = request.json
    set_clause = ",".join([f'"{k}"=%s' for k in data.keys()])
    cur = conn.cursor()
    cur.execute(f'UPDATE "{tabla}" SET {set_clause} WHERE "{idcol}"=%s RETURNING *',
                tuple(data.values())+(idval,))
    row = cur.fetchone()
    colnames = [desc[0] for desc in cur.description] if row else []
    conn.commit()
    cur.close()
    return jsonify(dict(zip(colnames, row)))

@app.route("/<tabla>/<idcol>/<idval>", methods=["DELETE"])
def delete(tabla, idcol, idval):
    cur = conn.cursor()
    cur.execute(f'DELETE FROM "{tabla}" WHERE "{idcol}"=%s RETURNING *', (idval,))
    row = cur.fetchone()
    colnames = [desc[0] for desc in cur.description] if row else []
    conn.commit()
    cur.close()
    return jsonify(dict(zip(colnames, row)) if row else {})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
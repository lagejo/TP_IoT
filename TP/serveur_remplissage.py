import sqlite3
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import List

#Curl ajouter une mesure : curl -i -X POST -H "Content-Type:application/json" -d "{  "valeur" : "0",  "date_insert" : "test", "id_capteur": 12"}" http://127.0.0.1:8000/mesures
#http://127.0.0.1:8000/docs#/

app = FastAPI()

# Modèle de données pour la mesure (utilisé pour la validation des entrées via POST)
class Mesure(BaseModel):
    valeur: float
    date_insert: str
    id_capteur: int

# Modèle de données pour la facture (utilisé pour la validation des entrées via POST)
class Facture(BaseModel):
    type_facture: str
    montant: float
    valeur_conso: float
    date_fact: str
    id_loge: int

# Fonction pour obtenir une connexion à la base de données
def get_db_connection():
    conn = sqlite3.connect('logement.db')
    conn.row_factory = sqlite3.Row
    return conn

# Route GET pour récupérer toutes les mesures
@app.get("/mesures", response_model=List[Mesure])
async def get_mesures():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Mesure")
    mesures = cursor.fetchall()
    conn.close()

    # Convertir les résultats en une liste de dictionnaires

    return [Mesure(**dict(row)) for row in mesures]

# Route POST pour ajouter une nouvelle mesure
@app.post("/mesures")
async def add_mesure(mesure: Mesure):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = '''INSERT INTO Mesure (valeur, date_insert, id_capteur) 
               VALUES (?, ?, ?)'''
    cursor.execute(query, (mesure.valeur, mesure.date_insert, mesure.id_capteur))
    conn.commit()
    conn.close()

    return {"message": "Mesure added successfully"}

# Route GET pour récupérer toutes les factures
@app.get("/factures", response_model=List[Facture])
async def get_factures():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Facture")
    factures = cursor.fetchall()
    conn.close()

    # Convertir les résultats en une liste de dictionnaires
    return [Facture(**dict(row)) for row in factures]

# Route POST pour ajouter une nouvelle facture
@app.post("/factures")
async def add_facture(facture: Facture):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = '''INSERT INTO Facture (type_facture, montant, valeur_conso, date_fact, id_loge)
               VALUES (?, ?, ?, ?, ?)'''
    cursor.execute(query, (facture.type_facture, facture.montant, facture.valeur_conso, facture.date_fact, facture.id_loge))
    conn.commit()
    conn.close()

    return {"message": "Facture added successfully"}

# Point d'entrée pour exécuter l'application avec Uvicorn
# Pour l'exécuter via la commande : uvicorn app:app --reload


#ajout exo 2
def get_factures():
    conn = sqlite3.connect('logement.db')
    conn.row_factory = sqlite3.Row
    c = conn.cursor()

    # Récupérer toutes les factures de la base de données
    c.execute("SELECT type_facture, montant FROM Facture")
    factures = c.fetchall()
    conn.close()

    return factures

# Route GET qui renvoie une page HTML avec le graphique

    
# Générer la page HTML avec Google Charts
@app.get("/graphique", response_class=HTMLResponse)
async def afficher_graphique():
    # Récupérer les données des factures
    factures = get_factures()
    
    # Préparer les données pour le graphique
    labels = []
    data = []
    
    for facture in factures:
        labels.append(facture['type_facture'])
        data.append(facture['montant'])
    
    # Générer la page HTML avec Google Charts
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Graphique des Factures</title>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript">
            google.charts.load('current', {{packages: ['corechart', 'pie']}});  
            google.charts.setOnLoadCallback(drawChart);

            function drawChart() {{
                var data = google.visualization.arrayToDataTable([
                    ['Type de Facture', 'Montant'],
                    {', '.join([f"['{label}', {amount}]" for label, amount in zip(labels, data)])}
                ]);
                
                var options = {{
                    title: 'Répartition des Factures',
                    pieSliceText: 'percentage',
                    slices: {{
                        0: {{offset: 0.1}},
                        1: {{offset: 0.1}},
                        2: {{offset: 0.1}},
                        3: {{offset: 0.1}}
                    }},
                }};
                
                var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
                chart.draw(data, options);
            }}
        </script>
    </head>
    <body>
        <h1>Graphique des Factures</h1>
        <div id="piechart_3d" style="width: 900px; height: 500px;"></div>
    </body>
    </html>
    """

    return HTMLResponse(content=html_content)
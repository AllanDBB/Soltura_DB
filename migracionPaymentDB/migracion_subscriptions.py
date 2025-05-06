import pandas as pd
import pymysql
import pyodbc
from datetime import datetime

#Se conecta a las dos bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    #Extrae los datos de la tabla subscriptions
    address_df = pd.read_sql("SELECT subscriptionid, description, logourl FROM payment_subscriptions", mysql_conn)
    
    #Migra los datos a SQL Server iterando columna por columna
    with sqlserver_conn.cursor() as cursor:
        for _, row in address_df.iterrows():
            cursor.execute("""
                INSERT INTO solturadb.soltura_subscriptions (description, logourl)
                VALUES (?, ?)
            """, row['description'], row['logourl'])
        
        sqlserver_conn.commit()
    
    print(f"Migración exitosa. {len(address_df)} subscripciones migradas")

except Exception as e:
    print(f"Error: {e}")
finally:
    mysql_conn.close()
    sqlserver_conn.close()
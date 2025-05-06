import pandas as pd
import pymysql
import pyodbc
from datetime import datetime

#Se conecta a las dos bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    #Extrae los datos de la tabla modules
    module_df = pd.read_sql("SELECT moduleid, name FROM payment_modules", mysql_conn)
    

    #Migra los datos a SQL Server iterando columna por columna
    with sqlserver_conn.cursor() as cursor:
        for _, row in module_df.iterrows():
            cursor.execute("""
                INSERT INTO solturadb.soltura_modules (moduleid, name)
                VALUES (?, ?)
            """, row['moduleid'], row['name'])
        
        sqlserver_conn.commit()
    
    print(f" Migración exitosa. {len(module_df)} módulos migrados")

except Exception as e:
    print(f" Error: {e}")
finally:
    mysql_conn.close()
    sqlserver_conn.close()

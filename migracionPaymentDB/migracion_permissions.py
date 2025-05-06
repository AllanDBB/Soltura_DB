import pandas as pd
import pymysql
import pyodbc
from datetime import datetime

#Se conecta a las dos bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    #Extrae los datos de la tabla permissiones
    permission_df = pd.read_sql("SELECT permissionid, description, code, moduleid FROM payment_permissions", mysql_conn)
    
    #Aumentamos el tamaño de la columna 'code'
    with sqlserver_conn.cursor() as cursor:
        cursor.execute("""
            ALTER TABLE solturadb.soltura_permissions 
            ALTER COLUMN code NVARCHAR(50)
        """)
        sqlserver_conn.commit()
        print("Columna code ampliada ")
    
    #Migra los datos a SQL Server iterando columna por columna
    with sqlserver_conn.cursor() as cursor:
        for _, row in permission_df.iterrows():
            cursor.execute("""
                INSERT INTO solturadb.soltura_permissions (description, code, moduleid)
                VALUES (?, ?, ?)
            """, row['description'], row['code'], row['moduleid'])
        
        sqlserver_conn.commit()
    
    print(f"Migración exitosa. {len(permission_df)} permisos migrados")

except Exception as e:
    print(f"Error: {e}")
finally:
    mysql_conn.close()
    sqlserver_conn.close()
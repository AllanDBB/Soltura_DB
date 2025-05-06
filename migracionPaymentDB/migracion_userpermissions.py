import pandas as pd
import pymysql
import pyodbc

# Conexión a las bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    # Renombrar la columna rolepermissionid a userpermissionid
    with sqlserver_conn.cursor() as cursor:
        try:
            cursor.execute("""
                EXEC sp_rename 'solturadb.soltura_userpermissions.rolepermissionid', 'userpermissionid', 'COLUMN'
            """)
            sqlserver_conn.commit()
        except Exception as rename_error:
            print(f"Nota: No se pudo renombrar la columna: {rename_error}")

    # Extraer los datos de userpermissions desde MySQL
    userpermissions_df = pd.read_sql("SELECT * FROM payment_userpermissions", mysql_conn)
    print(f"Columnas en el origen: {userpermissions_df.columns.tolist()}")

    # Migrar los datos a SQL Server de la tabla soltura_userpermissions
    with sqlserver_conn.cursor() as cursor:
        for _, row in userpermissions_df.iterrows():
            #Se verifica si el username existe en la tabla soltura_users
            cursor.execute("""
                SELECT userid FROM solturadb.soltura_users WHERE email = ?
            """, (row['username'],))

            #Si existe una coincidencia, se obtiene el userid correspondiente
            user_row = cursor.fetchone()  
            if user_row:  
                userid_correcto = user_row[0]
            else:
                userid_correcto = row['userid']  

            # Se inserta los datos migrados y con el userid correcto por si ya existia el usuario en users
            cursor.execute("""
                INSERT INTO solturadb.soltura_userpermissions (enabled, deleted, lastupdate, username, checksum, userid, permissionid)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (row['enabled'], row['deleted'], row['lastupdate'], row['username'], row['checksum'], userid_correcto, row['permissionid']))

        sqlserver_conn.commit()

    print(f"Migración exitosa. {len(userpermissions_df)} permisos de usuario migrados")

except Exception as e:
    print(f"Error: {e}")

finally:
    mysql_conn.close()
    sqlserver_conn.close()
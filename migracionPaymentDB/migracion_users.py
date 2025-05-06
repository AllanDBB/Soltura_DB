import pandas as pd
import pymysql
import pyodbc
import hashlib

# Conexión a las bases de datos
mysql_conn = pymysql.connect(
    host='localhost', user='root', password='123', database='paymentdb'
)
sqlserver_conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;'
)

try:
    #Se cren las tablas de usuarios migrados y los de cambio de contraseña
    with sqlserver_conn.cursor() as cursor:
        cursor.execute("""
            IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='soltura_migrated_users' AND xtype='U')
            CREATE TABLE solturadb.soltura_migrated_users (
                migratedid INT IDENTITY PRIMARY KEY,
                email NVARCHAR(255) UNIQUE NOT NULL,
                firstname NVARCHAR(100),
                lastname NVARCHAR(100),
                birthdate DATE,
                companyid INT NULL,
                fecha_registro DATETIME DEFAULT '2025-12-15', -- Fecha en la que se hará la migración
                password VARBINARY(32) NOT NULL
            )
        """)
        cursor.execute("""
            IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='soltura_passwordchange' AND xtype='U')
            CREATE TABLE solturadb.soltura_passwordchange (
                passwordchangeid INT IDENTITY PRIMARY KEY,
                changerequired BIT DEFAULT 1,
                userid INT NOT NULL,
                FOREIGN KEY (userid) REFERENCES solturadb.soltura_users(userid)
            )
        """)
        sqlserver_conn.commit()

    #Extraer los datos de users desde MySQL
    payment_users = pd.read_sql(
        "SELECT userid, email, firstname, lastname, birthday, NULL AS companyid FROM payment_users",
        mysql_conn
    )

    #Se generan contraseñas nuevas para los usuarios migrados
    def generate_hashed_password(index):
        texto = f"Contraseña{index}"
        return hashlib.sha256(texto.encode('utf-8')).digest()
    payment_users['hashed_password'] = [generate_hashed_password(i) for i in range(len(payment_users))]

    #Se insertan los usuarios en soltura_users y soltura_migrated_users
    with sqlserver_conn.cursor() as cursor:
        for _, row in payment_users.iterrows():
            cursor.execute("""
                INSERT INTO solturadb.soltura_users (email, firstname, lastname, birthday, password, companyid)
                VALUES (?, ?, ?, ?, ?, ?)
            """, row['email'], row['firstname'], row['lastname'], row['birthday'], row['hashed_password'], row['companyid'])

            cursor.execute("""
                INSERT INTO solturadb.soltura_migrated_users (email, firstname, lastname, birthdate, companyid, password)
                VALUES (?, ?, ?, ?, ?, ?)
            """, row['email'], row['firstname'], row['lastname'], row['birthday'], row['companyid'], row['hashed_password'])

        sqlserver_conn.commit()

    print("Usuarios migrados insertados correctamente.")

    #Se insertan los usuarios en la tabla de cambio de contraseña
    #Se insertan buscandolos por su correo electrónico en la tabla de usuarios migrados con su nuevo user id
    with sqlserver_conn.cursor() as cursor:
        cursor.execute("""
            INSERT INTO solturadb.soltura_passwordchange (userid, changerequired)
            SELECT u.userid, 1
            FROM solturadb.soltura_users u
            WHERE email IN (SELECT email FROM solturadb.soltura_migrated_users)
            ORDER BY u.userid
        """)
        sqlserver_conn.commit()

    print("Estado de cambio de contraseña registrado correctamente.")

except Exception as e:
    print(f"Error: {e}")

finally:
    mysql_conn.close()
    sqlserver_conn.close()

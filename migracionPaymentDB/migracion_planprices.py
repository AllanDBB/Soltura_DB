import pandas as pd
import pymysql
import pyodbc
from datetime import datetime

#Se conecta a las dos bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    # Consulta para extraer los datos de la tabla prices de Payment
    #Se realiza un join con la tabla subscriptions para obtener el nombre de la suscripción para no perder la referencia
    planprices_df = pd.read_sql("""
        SELECT pp.planpricesid, pp.amount, pp.recurrencytype, pp.posttime, pp.endate, 
               pp.current, pp.currencyid, pp.subscriptionid, s.description as subscription_name
        FROM payment_planprices pp
        JOIN payment_subscriptions s ON pp.subscriptionid = s.subscriptionid
    """, mysql_conn)
    
    
    #Se extraen el id y description de las suscripciones en Soltura
    soltura_subscriptions = pd.read_sql("""
        SELECT subscriptionid, description 
        FROM solturadb.soltura_subscriptions
    """, sqlserver_conn)
    
    #Con diccionarois se relacionan los nombres de las suscripciones con sus IDs
    #Para poder asociar los datos migrados con los de Soltura
    subscription_map = {}
    for _, row in soltura_subscriptions.iterrows():
        if row['description']:  # Verificar que la descripción no sea None
            subscription_map[row['description'].lower()] = row['subscriptionid']
    
    

    with sqlserver_conn.cursor() as cursor:
        for _, row in planprices_df.iterrows():
            #Busca el ID de la suscripción en el diccionario usando el nombre 
            subscription_name = row['subscription_name'].lower() if row['subscription_name'] else ''
            soltura_subscription_id = subscription_map.get(subscription_name)
            
            if not soltura_subscription_id:
                continue
            
            try:
                #Inserta los datos migrados con el ID de la suscripción de Soltura
                cursor.execute("""
                    INSERT INTO solturadb.soltura_planprices 
                    (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                """, 
                row['amount'],
                row['recurrencytype'],
                row['posttime'],
                row['endate'],
                row['current'],
                row['currencyid'],
                soltura_subscription_id)  #Usa el ID correspondiente
                
            except Exception as insert_error:
                print(f"Error al insertar precio de plan: {insert_error}")
        
        sqlserver_conn.commit()
    
    print(f"Migración exitosa")

except Exception as e:
    print(f"Error durante la migración: {e}")
finally:
    mysql_conn.close()
    sqlserver_conn.close()
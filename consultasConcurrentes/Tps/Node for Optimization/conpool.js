const express = require('express');
const sql = require('mssql');
const app = express();
const PORT = 3000;

const config = { //Parametros a configurar (un usuario, password, servido, puerto)
  user: 'nombre_usuario',
  password: 'password',
  server: 'localhost',
  port: 1433,
  database: 'soltura',
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
  pool: {
    max: 35,
    min: 30,
    idleTimeoutMillis: 30000,
  },
};

// Crear pool de conexiones para reutilizarlas una vez inicializadas.
const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then(pool => {
    console.log("Conectado a la base de datos");
    return pool;
  })
  .catch(err => {
    console.error("Error de conexión a la base de datos:", err);
    process.exit(1);
  });


app.get('/redemption', async (req, res) => {
  try {
    const pool = await poolPromise; // Esperar a dar un pool de conexiones inicializado.

    // Obtener datos aleatorios para enviar a la transaccion
    const randomResult = await pool.request()
      .execute('solturadb.sp_getRandomUserPlanBenefit');

    if (!randomResult.recordset || randomResult.recordset.length === 0)  //  Verifica si hay alguna combinacion valida.
      {
      return res.status(404).send('No se encontró combinación válida.');
    }

    const { userid, planpersonid, benefitsid } = randomResult.recordset[0];// Extraer los datos necesarios de la respuesta

    // Ejecuta la redencion pero mandando un usuario, el plan asociado al usuario y que beneficio quiere redimir.
    await pool.request()
      .input('userId', sql.Int, userid)
      .input('planpersonId', sql.Int, planpersonid)
      .input('benefitId', sql.Int, benefitsid)
      .execute('solturadb.sp_insertRedemptionPorParametros');

    res.json({
      mensaje: 'Redención realizada correctamente.',
      datos: {
        userId: userid,
        planpersonId: planpersonid,
        benefitId: benefitsid
      }
    });

  } catch (err) {
    console.error('Error en redención:', err);
    res.status(500).send('Error al procesar la redención.');
  }
});

app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
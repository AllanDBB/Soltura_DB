const express = require('express');
const sql = require('mssql');
const app = express();
const PORT = 3000;

const config = {
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

// Crear pool de conexiones
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

// Endpoint de redención
app.get('/redemption', async (req, res) => {
  try {
    const pool = await poolPromise;

    // Paso 1: obtener usuario aleatorio, plan y beneficio
    const randomResult = await pool.request()
      .execute('solturadb.sp_getRandomUserPlanBenefit');

    if (!randomResult.recordset || randomResult.recordset.length === 0) {
      return res.status(404).send('No se encontró combinación válida.');
    }

    const { userid, planpersonid, benefitsid } = randomResult.recordset[0];

    // Paso 2: redimir con esos valores
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
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
    }
};

app.get('/redemption', async (req, res) => {
    // Crear pool manualmente y cerrarlo después
    const pool = new sql.ConnectionPool(config);
    try {
        await pool.connect();

        // Obtener datos aleatorios
        const randomResult = await pool.request()
            .execute('solturadb.sp_getRandomUserPlanBenefit');

        if (!randomResult.recordset || randomResult.recordset.length === 0) {
            return res.status(404).send('No se encontró combinación válida.');
        }

        const { userid, planpersonid, benefitsid } = randomResult.recordset[0];

        // Ejecutar redención
        await pool.request()
            .input('userId', sql.Int, userid)
            .input('planpersonId', sql.Int, planpersonid)
            .input('benefitId', sql.Int, benefitsid)
            .execute('solturadb.sp_insertRedemptionPorParametros');

        res.json({
            mensaje: 'Redención realizada correctamente (sin reutilizar pool).',
            datos: { userid, planpersonid, benefitsid }
        });
    } catch (err) {
        console.error('Error al ejecutar la redención sin pool:', err);
        res.status(500).send('Error en redención.');
    } finally {
        pool.close(); // Cerrar el pool después de cada solicitud
    }
});

app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
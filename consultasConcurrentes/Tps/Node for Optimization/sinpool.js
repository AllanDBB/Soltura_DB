const express = require('express');
const sql = require('mssql');
const app = express();
const PORT = 3000;

const config = { //Parametros a configurar (un usuario, password, servido, puerto)
    user: 'nombre_usuario',
    password: 'password',
    server: 'ALLANDBB',
    port: 1433,
    database: 'soltura',
    options: {
        encrypt: true,
        trustServerCertificate: true,
    }
};

app.get('/redemption', async (req, res) => {
    // se Crea un pool manualmente y cerrarlo después (esto hace que solo se use una vez por solicitud)
    const pool = new sql.ConnectionPool(config);
    try {
        await pool.connect();

        // Obtener datos aleatorios para enviar a la transaccion
        const randomResult = await pool.request()
            .execute('solturadb.sp_getRandomUserPlanBenefit');

        if (!randomResult.recordset || randomResult.recordset.length === 0) //  Verifica si hay alguna combinacion valida.
            {
            return res.status(404).send('No se encontró combinación válida.');
        }

        // Extraer los datos necesarios de la respuesta
        const { userid, planpersonid, benefitsid } = randomResult.recordset[0];

        // Ejecuta la redencion pero mandando un usuario, el plan asociado al usuario y que beneficio quiere redimir.
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
        pool.close(); // Cerrar el pool después de cada solicitud (para asegurarse de que no se mantenga usando)
    }
});

app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
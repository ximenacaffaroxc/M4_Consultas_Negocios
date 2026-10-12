/* ========================================================
           Consulta de Negocio: 
===========================================================*/
  
  USE VentasTechDB;

-- Consulta 1: Resumen ejecutivo mensual
SELECT
  MONTH(FechaVenta) AS Mes,
    SUM(Cantidad * PrecioUnitario) AS Total_Facturado,
    COUNT(VentaID) AS Cantidad_Pedidos,
    SUM(Cantidad * PrecioUnitario) * 1.0
        / COUNT(VentaID) AS Ticket_Promedio
FROM dbo.Ventas
GROUP BY MONTH(FechaVenta)
ORDER BY MONTH(FechaVenta);

-- Consulta 2: Ranking de productos - Top 5
SELECT TOP 5
    ProductID AS ID_Producto,
    SUM(Cantidad) AS Unidades_Vendidas,
    SUM(Cantidad * PrecioUnitario) AS Total_Generado
FROM Ventas
GROUP BY ProductID
ORDER BY SUM(Cantidad * PrecioUnitario) DESC;

--Consulta 3: Clientes Recurrentes
SELECT
    ClienteID AS ID_Cliente,
    COUNT(*) AS Cantidad_Pedidos,
    SUM(Cantidad * PrecioUnitario) AS Total_Gastado
FROM Ventas
GROUP BY ClienteID
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Consulta 4: Meses por encima y debajo del promedio
WITH FacturacionMensual AS (
    SELECT
        MONTH(FechaVenta) AS Mes,
        SUM(Cantidad * PrecioUnitario) AS Total_Facturado
    FROM Ventas
    GROUP BY MONTH(FechaVenta)
)
SELECT
    Mes,
    Total_Facturado,
    CASE
        WHEN Total_Facturado > (
            SELECT AVG(Total_Facturado)
            FROM FacturacionMensual
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS Comparacion_Promedio
FROM FacturacionMensual
ORDER BY Mes;

  /* ========================================================
           Bloque de cierre: enumerar 3 hallazgos encontrados al revisar los resultados
1- De las 10 ventas realizadas, todos los clientes realizaron 2 compras. Siendo el cliente 5 el que mas gastó y el 4 el que menos gastó.
2- El mouse inalámbrico es el producto mas vendido.
3- El total facturado muestra que está por debado de la comparación promedio con la facturación mensual.
===========================================================*/
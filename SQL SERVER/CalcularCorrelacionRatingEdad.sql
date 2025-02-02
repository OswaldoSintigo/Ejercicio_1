USE [Ejercicio1]
GO
/****** Object:  StoredProcedure [dbo].[CalcularCorrelacionRatingEdad]    Script Date: 9/14/2024 2:26:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CalcularCorrelacionRatingEdad]
AS
BEGIN
    -- Obtener la media de rating y age
    WITH AvgValues AS (
        SELECT 
            AVG(CAST(Rating AS FLOAT)) AS PromedioRating,
            AVG(CAST(Age AS FLOAT)) AS PromedioEdad
        FROM 
            dbo.PlayerName
    ),
    -- Obtener la suma de las diferencias
    Covariance AS (
        SELECT 
            SUM((CAST(Rating AS FLOAT) - AvgValues.PromedioRating) * (CAST(Age AS FLOAT) - AvgValues.PromedioEdad)) AS Covarianza,
            COUNT(*) AS NumeroFilas
        FROM 
            dbo.PlayerName, AvgValues
    ),
    -- Obtener la desviación estándar
    StdDevs AS (
        SELECT 
            STDEV(CAST(Rating AS FLOAT)) AS DesvEstRating,
            STDEV(CAST(Age AS FLOAT)) AS DesvEstEdad
        FROM 
            dbo.PlayerName
    )
    -- Calcular la correlación
    SELECT 
        ROUND((Covariance.Covarianza / (Covariance.NumeroFilas - 1)) / 
        (StdDevs.DesvEstRating * StdDevs.DesvEstEdad), 4) AS Correlacion_Rating_Edad
    FROM 
        Covariance, StdDevs;
END;

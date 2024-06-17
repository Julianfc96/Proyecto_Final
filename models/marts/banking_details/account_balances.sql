{% set valores = ["RETIRO", "GASTO", "CREDITO"] %}
{% set casos_sum = obtener_casos_sum(valores) %}

WITH
trans AS (
    SELECT * FROM {{ ref('fct_financiera__trans') }}
),

operation_data AS (
    SELECT * FROM {{ ref('dim_financiera__operation') }}
),

latest_trans_dates AS (
    SELECT
        account_id,
        MAX(trans_date) AS last_trans_date
    FROM trans 
    GROUP BY account_id
),

-- Calcular la suma total de operaciones por cuenta y tipo de transacción
total_operations AS (
    SELECT
        t.account_id,
        {{ casos_sum }}
    FROM trans t
    JOIN operation_data o ON t.operation_id = o.operation_id
    GROUP BY t.account_id
),

-- Unir con la tabla de las últimas fechas de operación por cuenta
renamed_casted AS (
    SELECT
        t.account_id,
        lod.last_trans_date,
        t.balance_EUR AS current_balance
    FROM trans t
    JOIN latest_trans_dates lod ON t.account_id = lod.account_id
    WHERE t.trans_date = lod.last_trans_date
),

-- Unir los resultados calculados con renamed_casted y finalizar la consulta
final as (
    SELECT
        rc.account_id,
        rc.last_trans_date,
        t.retiro,
        t.gasto,
        t.credito,
        rc.current_balance
    FROM renamed_casted rc
    LEFT JOIN total_operations t ON rc.account_id = t.account_id
)

SELECT * FROM final

{{ config(
    materialized='incremental',
    unique_key='account_id'
) }}
with 

source as (

    select * from {{ ref('base_financiera__account') }}

),

renamed as (

    select
        account_id,
        district_id,
        CASE
            WHEN statement_frequency LIKE 'POPLATEK MESICNE' then 'EMISION MENSUAL'
            WHEN statement_frequency LIKE 'POPLATEK PO OBRATU' then 'EMISION POR TRANSACCION'
            WHEN statement_frequency LIKE 'POPLATEK TYDNE' then 'EMISION SEMANAL'
        END as statement_frequency,
        -- Esto representa la frecuencia de la cuenta para los pagos//sacar de aquí
        {{ convert_date_format('created_at') }} as created_at,
        data_deleted,
        date_load
    from source
    {% if is_incremental() %}
    where date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from renamed

{{ config(
    materialized='incremental',
    unique_key='trans_id'
) }}
with 

source as (

    select * from {{ ref('base_financiera__trans') }}

),

renamed as (



    select
        trans_id,
        account_id,
        {{convert_date_format('trans_date') }} as trans_date,
        {{dbt_utils.generate_surrogate_key(['operation','operation_type'])}} as operation_id,
        CASE operation_type
            WHEN 'PRIJEM' then 'CREDITO'
            WHEN 'VYDAJ' then 'GASTO'
            WHEN 'VYBER' then 'RETIRO'
            ELSE operation_type
        END as operation_type,
        CASE operation
            WHEN 'VYBER KARTOU' THEN 'RETIRO DE TARJETA DE CREDITO'
            WHEN 'VKLAD' THEN 'CREDITO EN EFECTIVO'
            WHEN 'PREVOD Z UCTU' THEN 'COBRO DE OTRO BANCO'
            WHEN 'VYBER' THEN 'RETIRO EN EFECTIVO'
            WHEN 'PREVOD NA UCET' THEN 'TRANSFERENCIA A OTRO BANCO'
            ELSE 'OPERACION DESCONOCIDA'
        END as operation,
        {{convert_to_eur('amount')}},
        {{convert_to_eur('balance')}},
        CASE trans_desc
            WHEN 'POJISTNE' then 'PAGO DE SEGURO'
            WHEN 'SLUZBY' then 'PAGO POR ESTADO DE CUENTA'
            WHEN 'UROK' then 'INTERES ACREDITADO'
            WHEN 'SANKC. UROK' then 'INTERES DE SANCION POR SALDO NEGATIVO'
            WHEN 'SIPO' then 'GASTOS DEL HOGAR'
            WHEN 'DUCHOD' then 'PENSION POR VEJEZ'
            WHEN 'UVER' then 'PAGO DE PRESTAMO'
            ELSE NULLIF(TRIM(trans_desc), '')
        END as trans_desc,
        nullif(bank, '') as partner_bank,
        nullif(account_to, 0) as partner_account,
        data_deleted,
        date_load

    from source
    {% if is_incremental() %}
    where date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from renamed

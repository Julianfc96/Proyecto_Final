with 

source as (

    select * from {{ ref('base_financiera__trans') }}

),

renamed as (



    select
        trans_id,
        account_id,
        {{convert_date_format('operation_date') }} as operation_date,
        {{dbt_utils.generate_surrogate_key(['operation','trans_type'])}} as operation_id,
        CASE trans_type
            WHEN 'PRIJEM' then 'CRÉDITO'
            WHEN 'VYDAJ' then 'GASTO'
            WHEN 'VYBER' then 'RETIRO'
            ELSE trans_type
        END as trans_type,
        CASE operation
            WHEN 'VYBER KARTOU' THEN 'RETIRO DE TARJETA DE CRÉDITO'
            WHEN 'VKLAD' THEN 'CRÉDITO EN EFECTIVO'
            WHEN 'PREVOD Z UCTU' THEN 'COBRO DE OTRO BANCO'
            WHEN 'VYBER' THEN 'RETIRO EN EFECTIVO'
            WHEN 'PREVOD NA UCET' THEN 'TRANSFERENCIA A OTRO BANCO'
            ELSE 'OPERACIÓN DESCONOCIDA'
        END as operation,
        {{convert_to_eur('amount')}},
        {{convert_to_eur('balance')}},
        CASE trans_desc
            WHEN 'POJISTNE' then 'PAGO DE SEGURO'
            WHEN 'SLUZBY' then 'PAGO POR ESTADO DE CUENTA'
            WHEN 'UROK' then 'INTERÉS ACREDITADO'
            WHEN 'SANKC. UROK' then 'INTERÉS DE SANCIÓN POR SALDO NEGATIVO'
            WHEN 'SIPO' then 'GASTOS DEL HOGAR'
            WHEN 'DUCHOD' then 'PENSIÓN POR VEJEZ'
            WHEN 'UVER' then 'PAGO DE PRÉSTAMO'
            ELSE NULLIF(TRIM(trans_desc), '')
        END as trans_desc,
        CASE 
            WHEN bank is not null THEN {{dbt_utils.generate_surrogate_key(['bank','account_to'])}}
            ELSE null
        END as partner_bank_id,
        bank as partner_bank,
        account_to as partner_account,
        data_deleted,
        date_load

    from source

)

select * from renamed

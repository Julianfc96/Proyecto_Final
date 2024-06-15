with 

source as (

    select * from {{ ref('base_financiera__account') }}

),

renamed as (

    select
        account_id,
        district_id,
        CASE
            WHEN payment_frequency LIKE 'POPLATEK MESICNE' then 'EMISIÓN MENSUAL'
            WHEN payment_frequency LIKE 'POPLATEK PO OBRATU' then 'EMISIÓN POR TRANSACCIÓN'
            WHEN payment_frequency LIKE 'POPLATEK TYDNE' then 'EMISIÓN SEMANAL'
        END as payment_frequency,
        -- Esto representa la frecuencia de la cuenta para los pagos//sacar de aquí
        {{ convert_date_format('created_at') }} as created_at,
        data_deleted,
        date_load
    from source

)

select * from renamed

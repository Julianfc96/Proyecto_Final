with 

source as (

    select * from {{ source('financiera', 'account') }}

),

renamed as (

    select
        account_id,
        district_id,
        CASE
            WHEN frequency LIKE 'POPLATEK MESICNE' then 'EMISIÓN MENSUAL'
            WHEN frequency LIKE 'POPLATEK PO OBRATU' then 'EMISIÓN POR TRANSACCIÓN'
            WHEN frequency LIKE 'POPLATEK TYDNE' then 'EMISIÓN SEMANAL'
        END as frequency,
        -- Esto representa la frecuencia de la cuenta para los pagos//sacar de aquí
        to_date(concat('19', to_char(date)), 'YYYYMMDD') as created_at,
       _fivetran_deleted as data_deleted,
        _fivetran_synced as date_load
    from source

)

select * from renamed

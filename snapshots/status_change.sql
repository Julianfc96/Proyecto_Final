{% snapshot loan_snapshot %}

{{
config(
    target_schema='snapshots',
    unique_key='loan_id',
    strategy='timestamp',
    updated_at='date_load'
)
}}


with 

source as (
    select * from {{ source('financiera', 'loan') }}
),

renamed as (
    select
        loan_id,
        account_id,
        {{convert_date_format('date') }} as loan_create_at,
        {{convert_to_eur('amount')}},
        duration,
        {{convert_to_eur('payments')}},
        CASE 
            WHEN status is not null then {{dbt_utils.generate_surrogate_key(['status'])}}
            else null 
        END AS status_id,
        CASE 
            WHEN status like 'A' then 'Contrato terminado, sin problemas'
            WHEN status like 'B' then 'Contrato terminado, préstamo no pagado'
            WHEN status like 'C' then 'Contrato en ejecución, pagos correctos'
            WHEN status like 'D' then 'Contrato en ejecución, cliente endeudado'
        END as status,
        _fivetran_deleted as data_deleted,
        _fivetran_synced as date_load
    from source
)

select * from renamed

{% endsnapshot %}

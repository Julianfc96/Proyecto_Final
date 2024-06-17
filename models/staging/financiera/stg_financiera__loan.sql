{{ config(
    materialized='incremental',
    unique_key='loan_id'
) }}
with 

source as (

    select * from {{ ref('base_financiera__loan') }}

),

renamed as (

    select
        loan_id,
        account_id,
        {{convert_date_format('loan_create_at') }} as loan_create_at,
        {{convert_to_eur('amount')}},
        duration as estimated_end_date,
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
        data_deleted,
        date_load
    from source
     {% if is_incremental() %}
    where date_load > (select max(date_load) from {{ this }})
    {% endif %}   
)

select * from renamed

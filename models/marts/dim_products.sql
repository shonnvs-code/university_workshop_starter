with source as (

    select * from {{ ref('stg_products') }}

),

final as (

    select
        sku,
        name,
        type,
        price,
        description

    from source

)

select * from final

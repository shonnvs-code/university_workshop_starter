with items as (

    select * from {{ ref('stg_items') }}

),

products as (

    select * from {{ ref('dim_products') }}

),

final as (

    select
        products.sku,
        products.name,
        products.type,
        products.price,
        count(items.id)             as units_sold,
        count(items.id) * products.price as total_revenue

    from items

    left join products
        on items.sku = products.sku

    group by
        products.sku,
        products.name,
        products.type,
        products.price

)

select * from final
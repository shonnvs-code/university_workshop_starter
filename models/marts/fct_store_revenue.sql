with orders as (

    select * from {{ ref('stg_orders') }}

),

stores as (

    select * from {{ ref('stg_stores') }}

),

final as (

    select
        stores.id                       as store_id,
        stores.name                     as store_name,
        stores.tax_rate,
        count(orders.id)                as total_orders,
        sum(orders.subtotal)            as total_subtotal,
        sum(orders.tax_paid)            as total_tax_paid,
        sum(orders.order_total)         as total_revenue

    from orders

    left join stores
        on orders.store_id = stores.id

    group by
        stores.id,
        stores.name,
        stores.tax_rate

)

select * from final
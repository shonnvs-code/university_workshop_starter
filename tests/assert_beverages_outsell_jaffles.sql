-- Business logic test: assert_beverages_outsell_jaffles
--
-- Beverages are lower priced and quicker to serve, so we expect them
-- to outsell jaffles in unit volume. If jaffles ever outsell beverages
-- it likely signals a data pipeline issue (missing beverage records)
-- rather than a genuine sales shift.
--
-- PASSES (0 rows) when beverages outsell jaffles in total units.
-- FAILS  (1 row)  when jaffles have equal or more units than beverages.

with sales_by_type as (

    select
        type,
        sum(units_sold) as total_units

    from {{ ref('fct_product_sales') }}

    group by type

),

beverage_units as (
    select total_units from sales_by_type where type = 'beverage'
),

jaffle_units as (
    select total_units from sales_by_type where type = 'jaffle'
)

select
    bev.total_units as beverage_units,
    jaf.total_units as jaffle_units

from beverage_units bev, jaffle_units jaf

-- test fails if beverages do NOT outsell jaffles
where bev.total_units <= jaf.total_units

with
    sales as (
        select *
        from {{ ref('int_order__header') }}
    )

    , customer as (
        select *
        from {{ ref('stg_erp__customer') }}
    )

    , joined_orders as (
        select
            sales.id_salesorder
            , sales.id_customer
            , customer.id_person
            , sales.id_territory
            , sales.id_shipmethod
            , sales.id_creditcard
            , sales.id_product
            , sales.order_date
            , sales.orderflag
            , sales.status_st
            , sales.order_qty
            , sales.unit_price
            , sales.price_discount
            , sales.freight_fg                  
        from sales
        left join customer on sales.id_customer = customer.id_customer
    )

    , transformations as (
        select
            {{ dbt_utils.generate_surrogate_key(['id_salesorder', 'id_product' ]) }} as fk_sales
            , *
            , order_qty * unit_price as total_bruto
            , (1-price_discount) * order_qty * unit_price as total_liquido
        from joined_orders
    )

select *
from transformations
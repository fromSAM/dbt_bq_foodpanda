-- common table expression for successful orders
with successful_orders as (
    select
         rdbms_id,
        date_local as order_date,
        customer_id,
        product_id,
        vendor_id
    from Original_fp.Orders
    where is_successful_order = TRUE
    
),

-- customers with successful orders
customers_with_successful_orders as (
    select distinct customer_id
    from successful_orders
),

-- total successful orders by date
total_successful_orders_by_date as (
    select
        order_date, customer_id,
        count(*) as total_successful_orders
    from successful_orders
    group by order_date, customer_id
),

-- total customers with successful orders
total_customers_with_successful_orders as (
    select count(distinct customer_id) as total_customers_with_successful_orders
    from successful_orders
),

-- total successful orders by vendor and date
total_successful_orders_by_vendor_and_date as (
    select
        V.vendor_name,
        O.order_date,
        count(*) as total_successful_orders
    from successful_orders O
    join Original_fp.Vendors V on O.vendor_id = V.id
    group by V.vendor_name, O.order_date
),

-- average products per order by date and rdbms_id
average_products_per_order_by_date_and_rdbms as (
    select
        order_date,
        rdbms_id,
        avg(products_count) as average_products_per_order
    from (
        select
            order_date,
            rdbms_id,
            count(distinct product_id) as products_count
        from successful_orders
        group by order_date, rdbms_id
    ) as Subquery
    group by order_date, rdbms_id
),

-- customers with reorders in the last 7 days
customers_with_reorders_last_7_days as (
    select count(distinct customer_id) as customers_with_reorders
    from Original_fp.Orders
    where date_local >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
)

-- Final query combining
select
    customers_with_successful_orders.customer_id,
    total_successful_orders_by_date.order_date,
    total_successful_orders_by_date.total_successful_orders,
    total_customers_with_successful_orders.total_customers_with_successful_orders,
    total_successful_orders_by_vendor_and_date.vendor_name,
    total_successful_orders_by_vendor_and_date.total_successful_orders as vendor_successful_orders,
    average_products_per_order_by_date_and_rdbms.average_products_per_order,
    customers_with_reorders_last_7_days.customers_with_reorders
from customers_with_successful_orders
left join total_successful_orders_by_date on customers_with_successful_orders.customer_id = total_successful_orders_by_date.customer_id
left join total_customers_with_successful_orders on 1=1
left join total_successful_orders_by_vendor_and_date on total_successful_orders_by_date.order_date = total_successful_orders_by_vendor_and_date.order_date
left join average_products_per_order_by_date_and_rdbms on total_successful_orders_by_date.order_date = average_products_per_order_by_date_and_rdbms.order_date
left join customers_with_reorders_last_7_days on 1=1

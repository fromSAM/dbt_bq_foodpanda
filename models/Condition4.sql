{{

    config(
        materialized='table'
    )
}}

SELECT
    date_local AS order_date, rdbms_id,
    AVG(products_count) AS average_products_per_order
FROM (
    SELECT
        date_local,
        rdbms_id,
        COUNT(DISTINCT product_id) AS products_count
    FROM
        Original_fp.Orders
    WHERE
        is_successful_order = TRUE
    GROUP BY
        date_local, rdbms_id
) AS Subquery
GROUP BY
    order_date, rdbms_id
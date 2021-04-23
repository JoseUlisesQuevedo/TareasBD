--- FORMA 1: Para cada cliente, calculamos el total de las ordenes de un mes, y luego calculamos la diferencia entre meses (contando solo meses donde hubieron órdenes
--- Luego, promediamos los meses para obtener el delta promedio 
--- Asi, nos queda
--- 	Cliente 1, Promedio entre pagos
---		Cliente 2, Promedio entre pagos 
---		Cliente 3, Promedio entre pagos
--- ... Etc. 

--- Consideramos este approach útil: Clientes con una Diferencia Mensual Promedio positiva, historicamente y en general aumentan sus ordenes pedido con pedido

with monto_por_orden as (
select o.customer_id,o.order_id ,extract(month from o.order_date) as mes,  extract(year from o.order_date) as anio, sum((od.quantity * od.unit_price)) as pago_total
from order_details od 
join orders o on (o.order_id = od.order_id)
group by o.customer_id, o.order_id, mes,anio
order by o.customer_id,anio,mes

)

,total_por_mes as (
select mpo.customer_id,  mpo.anio,mpo.mes, sum(pago_total) as pago_total_mensual
from monto_por_orden mpo
group by mpo.customer_id, mpo.mes, mpo.anio
order by  mpo.customer_id,mpo.anio asc, mpo.mes
)



, delta_entre_meses as (
select *, pago_total_mensual - lag(pago_total_mensual) over w as diferencia_entre_meses
from total_por_mes

window w as(partition by customer_id)
)

select dm.customer_id, avg(dm.diferencia_entre_meses) as "Diferencia Mensual Promedio"
from delta_entre_meses dm
group by dm.customer_id












--FORMA 2: Para cada cliente, calculamos la diferencia entre pagos promedio por mes
-- Asi, tenemos 
--	Cliente 1, Mes 1, Promedio entre pagos para ese mes
---	Cliente 1, Mes 2, Promedio entre pagos para ese mes 
---	Cliente 1, Mes 3, .....
--- Cliente 2, Mes 1, Promedio entre pagos para esee mes....
--- 
--- Debido a que hay clientes que tienen una sola orden en algunos meses, no hay una diferencia entre pagos promedio de ese mes
--- Por esto, consideramos que este approach no es tan util


with pagos_totales_por_orden as (
select o.customer_id,o.order_id ,extract(month from o.order_date) as mes,  extract(year from o.order_date) as anio, sum((od.quantity * od.unit_price)) as pago_total
from order_details od 
join orders o on (o.order_id = od.order_id)
group by o.customer_id, o.order_id, mes,anio
order by o.customer_id,anio,mes

)

,delta_entre_pagos as (
select *, 
pt.pago_total-lag(pt.pago_total) over (partition by pt.customer_id,pt.anio,pt.mes) as delta
from pagos_totales_por_orden pt
)
 


select dp.customer_id, dp.anio ,dp.mes,avg(dp.delta) as "Diferencia Promedio Entre Pagos para ese mes"
from delta_entre_pagos dp
group by dp.customer_id, dp.anio,dp.mes



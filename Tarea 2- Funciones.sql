

--Contamos el numero de pelicuals en inventario por tienda --
with total_peliculas as(
select store_id, count(*) as num_peliculas from inventory i 
join store s using (store_id)
group by store_id
),

--A cada cilindro, por peso, le caben máximo 100 peliculas (100 * 500g = 50,000 g = 50 kg)--
-- Suponemos que el arnes pesa, por lo que para estar seguros metemos máximo 70 peliculas

cilindros_por_tienda as(
select tp.store_id, ceil((tp.num_peliculas::numeric/70::numeric)) as grupos_de_50kg
from total_peliculas tp
)

--Ahora, sabemos cuantos cilindros necesitamos por tienda, y sabemos que cada cilindro tendrá 70 peliculas dentro. 
--Con esta información calculamos las medidas de los cilindros

-- CÁLCULO DE LA ALTURA NECESARIA

--Volumen del arnes (que contiene a las peliculas) 30 cm x 21 cm x 8 cm = 5040 cm. Suponemos que esta medida es largo x ancho x altura
-- Suponemos además que la parte más baja del arnes debe poder tocar todas las peliculas, 
--asi, la altura del cilindro es la altura de todas las peliculas + la altura del arnes 
-- el alto de la cajita es de 1.5 cm, y damos 2 cm entre cada pelicula

,altura_peliculas as (
select tp.store_id, (70 * 3.5) as alto_peliculas
from total_peliculas tp
)
,
--tomamos el máximo de ambas alturas (dado que será estandar) de entre las dos tiendas
-- Le sumamos 10 cm por la altura del arnes
altura_cilindro as(
	select max(ap.alto_peliculas) + 10 as altura_necesaria
	from altura_peliculas ap
),

-- CÁLCULO RADIO NECESARIO
-- El radio debe ser simplemente suficiente para que el arnes pueda rotar
-- Si el radio es igual al lado más larga de la caja, puede rotar sin problema (suponiendo que está centrado)

radio_cilindro as(
	select 31 as radio_necesario
)

-- Calculamos, finalmente, las medidas necesarias para nuestros cilindros
select altura_necesaria as "Altura", radio_necesario as "Radio", round((pi()*pow(radio_necesario,2)*altura_necesaria)::numeric/1000000,2) as "Volumen total"
from altura_cilindro, radio_cilindro




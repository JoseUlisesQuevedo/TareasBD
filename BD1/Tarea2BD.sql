-- Jose Ulises Quevedo 189442 --
-- Bases de Datos --
-- Tarea 2: Agrupación y agregación --



-- 1.  Nombres y correos de clientes canadienses --

select c2.country ,concat(c.first_name, ' ', c.last_name) full_name, c.email
from customer c 
join address a2 on (c.address_id = a2.address_id)
join city c1 on (a2.city_id = c1.city_id)
join country c2 on (c1.country_id = c2.country_id)
where c2.country  = 'Canada'
order by full_name


-- 2. Qué cliente ha rentado más de nuestra sección de adultos --
-- Consideramos NC-17 como la sección de adultos --

select c.customer_id, concat(c.first_name, ' ', c.last_name) full_Name, count(r.rental_id) rentas
from customer c 
join rental r on (c.customer_id = r.customer_id)
join inventory i on (r.inventory_id = i.inventory_id)
join film f on (i.film_id = f.film_id)
where rating = 'NC-17'
group by c.customer_id 
order by rentas desc
--Permitimos 5 por si hay varios con el número máximo de rentas. Como están ordenados no hay problema para responder --
limit 5

-- 3. ¿Qué peliculas son las más rentadas en todas nuestras stores --
-- La pregunta se interpreta de dos formas: --

-- 3a) Considerando las rentas de todas las tiendas, cuáles son las películas más rentadas --

select f.film_id, f.title, count(r.rental_id) num_rentas
from rental r 
join inventory i using (inventory_id)
join film f using (film_id)
group by f.film_id 
order by num_rentas desc
limit 10

-- 3b) En cada tieda, qué película es la más rentada en esa tienda --
select distinct on(i.store_id) i.store_id , film_id, f.title ,count(r.rental_id) num_rentas
from rental r
join inventory i  using (inventory_id)
join film f using (film_id)
group by store_id, film_id
order by i.store_id, count(r.rental_id) desc


-- 4. Revenue por store --
-- Consideramos el revenue como la suma de los pagos de las rentas
select i.store_id as tienda, sum(p.amount) revenue
from payment p 
join rental r on (p.rental_id = r.rental_id)
join inventory i on (r.inventory_id = i.inventory_id)
group by i.store_id 
order by revenue


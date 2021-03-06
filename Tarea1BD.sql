create table heroes(
	id_heroe numeric(4,0) constraint pk_heroe primary key,
	nombre varchar(50) not null,
	email varchar(100) not null
);



create sequence heroe_id_heroes_seq start 1 increment 1;

alter table heroes alter column id_heroe set default nextval('heroe_id_heroes_seq'); 

insert into heroes
(nombre,email)
values
('Wanda Maximoff', 'wanda.maximoff@avengers.org'),
('Pietro Maximoff', 'pietro@mail.sokovia.ru'),
('Erik Lensherr', 'fuck_you_charles@brotherhood.of.evil.mutants.space'),
('Charles Xavier', 'i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.'),
('Anthony Edward Start', 'iamironman@avengers.gov'),
('Steve Rogers', 'americas_ass@anti_avengers'),
('The Vision', 'vis@westview.sword.gov'),
('Clint Barton','bul@lse.ye'),
('Natasja Romanov','blackwidow@kgb.ru'),
('Thor','god_of_thunder-^_^@royalty.asgard.gov'
),
('Logan','wolverine@cyclops_is_a_jerk.com'),
('Ororo Monroe', 'ororo@weather.co'),
('Scott Summers', 'o@x'),
('Nathan Summers', 'cable@xfact.or'),
('Groot', 'iamgroot@asgardiansofthegalaxyledbythor.quillsux'),
('Nebula','idonthaveelektras@complex.thanos'),
('Gamora','thefiercestwomaninthegalaxy@thanos.'),
('Rocket','shhhhhhhh@darknet.ru');

insert into heroes 
(nombre,email)
values
('ES ESTE INCORRECTO?','buenmail@gmail.com.')

--CORRECTA: --
-- Seleccionamos correos de la fomra a@b.c donde a,b y c pueden ser cualquier cadena---
-- %_ nos garantiza que antes del @ haya al menos un caracter --
-- @__% garantiza al menos dos caracteres tras el @ --
-- .__% garantiza al menos dos caracteres tras el punto, y nos asegura también que no terminen en punto

select * from heroes h where email not like '%_@__%.__%' or email like '%.'

-- Original: regresaba correctos, pero consideraba algo como .@. como corecto
select * from heroes where email  like '%@%.%' and email not like '%.'

select * from heroes

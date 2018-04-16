use sakila;
##1a
select first_name,last_name from actor;

##1b
select concat(first_name," ",last_name) actor_name from actor;

##2a
select actor_id, first_name,last_name 
from actor
where first_name = upper('Joe');

##2b
select * from actor
where last_name like '%GEN%';

##2c
select * from actor
where last_name like '%LI%'
order by last_name ,first_name;

##2d
select country_id, country from country
where country in ('Afghanistan', 'Bangladesh','China');

##3a
alter table actor
add column middle_name Varchar(10) after first_name;

##3b
alter table actor
modify column middle_name blob;

##3c
alter table actor
drop column middle_name;

##4a
select last_name, count(*) from actor
group by last_name;

##4b

select last_name, count(*) from actor
group by last_name
having count(*) > 1;

##4c
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO'
and last_name ='WILLIAMS';

##4d
update actor
set first_name = CASE
when first_name = 'HARPO' then 'GROUCHO'
else 'MUCHO GROUCHO'
end
where actor_id = 172;

##5a
create table address_1(
address_id smallint(5) AUTO_INCREMENT NOT NULL PRIMARY KEY UNIQUE,
address varchar(50), 
address2 varchar(50), 
district varchar(20), 
city_id smallint(5) UNIQUE,
postal_code varchar(10), 
phone varchar(20), 
location geometry, 
last_update timestamp
);

##6a
select s.first_name,s.last_name,address from staff s
join address a
on s.address_id = a.address_id;

##6b
select p.staff_id,sum(amount) from staff s
join payment p
on s.staff_id = p.staff_id
where date_format(payment_date, '%m')='08'
group by p.staff_id;

##6c
select f.film_id, count(fa.actor_id) from film f
inner join film_actor fa
on f.film_id = fa.film_id
group by f.film_id;

#6d

select f.title,count(*) Number_of_copies from film f
join inventory i
on f.film_id = i.film_id
where f.title = 'Hunchback Impossible';

 #6e
select c.first_name,c.last_name,sum(p.amount) from customer c
join payment p
on c.customer_id = p.customer_id
group by c.customer_id
order by c.last_name;


##7a
select * from film
where (title like 'K%' OR title like 'Q%')
and language_id in(select language_id from language
where name = 'English');

##7b
select first_name,last_name from actor
where actor_id in(select actor_id from film_actor
where film_id in (select film_id from film 
where title = 'Alone Trip'));

##7c
select c.first_name,c.last_name,c.email,a.address,cy.city,ct.country from customer c
join address a
on c.address_id = a.address_id
join city cy
on a.city_id = cy.city_id
join country ct
on ct.country_id = cy.country_id
where ct.country = 'Canada';

##7d
select f.title from film f
join film_category fc
on f.film_id = fc.film_id
join category c
on fc.category_id = c.category_id
where c.name = 'Family';

##7e
select f.title,count(rental_id) rental_count from film f
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
group by f.film_id
order by rental_count desc;

##7f
select s.store_id, concat('$',format(sum(p.amount),"currency","en_us")) Total_Amount 
from store s
join customer c
on s.store_id = c.store_id
join payment p
on p.customer_id = c.customer_id
group by s.store_id

##7g
select s.store_id,a.address,c.city,ct.country from store s
left join address a
on s.address_id = a.address_id
join city c
on c.city_id = a.city_id
join country ct
on c.country_id = ct.country_id;

##7h
select  fc.category_id,c.name,sum(p.amount) gross_revenue
from category c
join film_category fc
on c.category_id = fc.category_id
join inventory i
on fc.film_id = i.film_id
join rental r
on r.inventory_id = i.inventory_id
join payment p
on p.rental_id = r.rental_id
group by fc.category_id
order by gross_revenue desc
limit 5
;

#8a
create view top_grossing_v AS
select  fc.category_id,c.name,sum(p.amount) gross_revenue
from category c
join film_category fc
on c.category_id = fc.category_id
join inventory i
on fc.film_id = i.film_id
join rental r
on r.inventory_id = i.inventory_id
join payment p
on p.rental_id = r.rental_id
group by fc.category_id
order by gross_revenue desc
limit 5
;


#8b

select * from top_grossing_v;

drop view if exists top_grossing_v;

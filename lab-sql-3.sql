use sakila;

# 1. How many distinct (different) actors' last names are there?

select count(distinct last_name) as distinct_last_names from actor;

# 121 different actors' last names

# 2. In how many different languages where the films originally produced? (Use the column language_id from the film table)

select count(distinct language_id) as n_languages from film;

# originally, they were produced in only one language 1

# 3. How many movies were released with "PG-13" rating?

select count(film_id) as n_pg_13 from film
where rating = "PG-13";

# 223 movies

# 4. Get the 10 longest movies from 2006.

select title, length from film
order by length desc
limit 10;

# 5. How many days has the company been operating (check DATEDIFF() function)?

select min(rental_date), max(rental_date), min(payment_date), max(payment_date) from rental, payment;

# First I wanted to take a look at whether there have been payments before the first rentals, as it could be possible that the company offered more products. The dates coincide.

select datediff(max(rental_date), min(rental_date)) from rental;

# The company has been operating for 226 days.

# 6. Show rental info with additional columns month and weekday. Get 20.

# solution 1 --> substring()
select *, substring(rental_date, 6, 2) as month, substring(rental_date, 9, 2) as weekday from rental
limit 20;

#solution 2 --> extract()
select *, extract(month from rental_date) as month, extract(day from rental_date) as weekday from rental
limit 20;

# 7. Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.

select *, substring(rental_date, 6, 2) as month, substring(rental_date, 9, 2) as weekday,
case
	when (dayname(rental_date) = "Saturday" or dayname(rental_date) = "Sunday") then "weekend"
    else "workday"
    end as day_type
from rental;

# I used a case expression with conditionals nested in it to separate between weekends and workdays

# 8. How many rentals were there in the last month of activity?

select count(rental_id) as last_month_rentals from rental
where to_days(rental_date) >= (
	select (max(to_days(rental_date)) - 30)
    from rental
    );

# I created a correlated subquery to circumvent using the max() function along with to_days() or any other function in calculations in a where statement, where
# it would cause me errors
## last month rentals = 182
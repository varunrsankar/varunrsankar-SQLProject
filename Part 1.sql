/* Q1: Who is the senior most employee based on job title? */
select * from employee
order by levels desc
limit 1

/* Q2: Which countries have the most Invoices? */
select count (invoice_id) as inv_count,billing_country 
from invoice
group by billing_country
order by inv_count DESC

/* Q3: What are top 3 values of total invoice? */

select total from invoice
order by total desc
limit 3

/* Q4: Which city has the best customers? 
We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city,SUM(total) as sum_of_invoices 
from invoice
group by billing_city
order by sum_of_invoices desc
limit 1

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select customer.first_name,customer.last_name,
customer.customer_id,SUM(invoice.total) as sum_of_invoices 
from customer join invoice On 
customer.customer_id = invoice.customer_id 
group by customer.customer_id
order by sum_of_invoices desc
limit 1

/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select * from customer
select * from invoice
select * from track
select * from invoice_line
select * from genre

select DISTINCT email,first_name,last_name from
customer join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in
(select track_id from track 
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock')
order by email

/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.name, count (artist.artist_id) as num_of_songs
from track
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by num_of_songs DESC
limit 10

/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name,milliseconds from track
where milliseconds >
(select avg(milliseconds) as avg_length from track)
order by milliseconds DESC
/*OR*/
select name,milliseconds from track where
milliseconds > 393599.212103910933
order by milliseconds DESC

/* Q9: Find how much amount spent by each customer on the best selling artists? 
Write a query to return customer name, artist name and total spent */

with best_selling_artist as
(
select artist.artist_id,artist.name,sum(invoice_line.unit_price *invoice_line.quantity)
from invoice_line
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
group by 1
order by 3 DESC
limit 1
)
select customer.customer_id,customer.first_name,customer.last_name,best_selling_artist.name,
sum(invoice_line.unit_price *invoice_line.quantity) as amount_spent
from invoice
join customer on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join best_selling_artist on best_selling_artist.artist_id = album.artist_id
group by 1,2,3,4
order by 5 DESC


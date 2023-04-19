--1- Selezionare tutte le software house americane (3)
SELECT *
FROM software_houses
WHERE country LIKE 'United States'

--2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
SELECT *
FROM players 
WHERE city LIKE 'Rogahnland'

--3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
SELECT *
FROM players
WHERE name LIKE '%A'

--4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
SELECT *
FROM reviews
WHERE player_id LIKE '800'

--5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
SELECT COUNT (*)
FROM tournaments
WHERE year = 2015

--6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
SELECT *
FROM awards
WHERE description like '%facere%'

--7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
SELECT DISTINCT videogame_id
FROM category_videogame
WHERE category_id = 2 OR category_id = 6

--8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
SELECT *
FROM reviews
WHERE rating >=2 AND rating <=4

--9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
SELECT *
FROM videogames
WHERE YEAR(release_date) = 2020

--10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT DISTINCT videogame_id
FROM reviews
WHERE rating = 5

--*********** BONUS ***********
--11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3)
SELECT COUNT(*) AS quantity, AVG(rating) AS average
FROM reviews
WHERE videogame_id = 412

--12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)
SELECT COUNT(*) AS quantity
FROM videogames
WHERE software_house_id = 1 AND YEAR(release_date) = 2018


--------------------------------------------------------------------------------------------------------------------------

--1- Contare quante software house ci sono per ogni paese (3)
SELECT country, COUNT(country) AS quantity
FROM software_houses
GROUP BY country 

--2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
SELECT COUNT(videogame_id) AS quantity
FROM reviews
GROUP BY videogame_id 

--3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
SELECT pegi_label_id, COUNT(*) AS quantity
FROM pegi_label_videogame 
GROUP BY pegi_label_id 

--4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT YEAR(release_date), COUNT(*) AS quantity
FROM videogames
GROUP BY year(release_date) 

--5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT device_id, COUNT(*) AS quantity
FROM device_videogame
GROUP BY  device_id

--6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT videogame_id, AVG(rating) AS average
FROM reviews
GROUP BY videogame_id ORDER BY average DESC


--------------------------------------------------------------------------------------------------------------------------

--1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
SELECT DISTINCT players.* 
FROM players
JOIN reviews
	ON reviews.player_id = players.id

--2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
SELECT DISTINCT videogames.name
FROM tournaments
JOIN tournament_videogame
	ON tournament_videogame.tournament_id = tournaments.id
JOIN videogames
	ON videogames.id = tournament_videogame.videogame_id
WHERE tournaments.year = 2016

--3- Mostrare le categorie di ogni videogioco (1718)
SELECT videogames.name, categories.name
FROM videogames
JOIN category_videogame
	ON category_videogame.videogame_id = videogames.id
JOIN categories
	ON category_videogame.category_id = categories.id

--4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT software_houses.*
FROM videogames
JOIN software_houses
	ON videogames.software_house_id = software_houses.id
WHERE YEAR(videogames.release_date) >= 2020

--5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT software_houses.name, awards.name
FROM software_houses
JOIN videogames
	ON videogames.software_house_id = software_houses.id
JOIN award_videogame
	ON award_videogame.videogame_id = videogames.id
JOIN awards
	ON award_videogame.award_id = awards.id

--6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
SELECT DISTINCT videogames.name, categories.name, pegi_labels.name 
FROM videogames
JOIN category_videogame
	ON category_videogame.videogame_id  = videogames.id
JOIN categories
	ON category_videogame.category_id = categories.id
JOIN pegi_label_videogame
	ON pegi_label_videogame.videogame_id  = videogames.id
JOIN pegi_labels
	ON pegi_label_videogame.pegi_label_id = pegi_labels.id
JOIN reviews
	ON reviews.videogame_id = videogames.id
WHERE reviews.rating >= 4

--7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT DISTINCT v.id, v.name
FROM videogames v
JOIN tournament_videogame tv ON v.id = tv.videogame_id
JOIN tournaments t ON tv.tournament_id = t.id
JOIN player_tournament pt ON t.id = pt.tournament_id
JOIN players p ON pt.player_id = p.id
WHERE p.name LIKE 'S%';

--8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
SELECT DISTINCT tournaments.city
FROM tournaments
JOIN tournament_videogame
	ON tournament_videogame.tournament_id  = tournaments.id
JOIN videogames
	ON tournament_videogame.videogame_id  = videogames.id
JOIN award_videogame
	ON award_videogame.videogame_id  = videogames.id
JOIN awards
	ON award_videogame.award_id = awards.id
WHERE award_videogame.year = 2018 AND awards.name LIKE 'Gioco dell''anno'

--9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
SELECT players.name 
FROM tournaments
JOIN tournament_videogame
	ON tournament_videogame.tournament_id  = tournaments.id
JOIN player_tournament
	ON player_tournament.tournament_id  = tournaments.id
JOIN players
	ON player_tournament.player_id = players.id
JOIN videogames
	ON tournament_videogame.videogame_id  = videogames.id
JOIN award_videogame
	ON award_videogame.videogame_id  = videogames.id
JOIN awards
	ON award_videogame.award_id = awards.id
WHERE award_videogame.year = 2018 AND awards.name LIKE 'Gioco più atteso' AND tournaments.year  = 2019

--*********** BONUS ***********
--10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)
SELECT software_houses.*, videogames.* 
FROM software_houses
JOIN videogames
	ON videogames.software_house_id = software_houses.id 
WHERE videogames.release_date = (SELECT MIN(videogames.release_date) FROM videogames)

--11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : 398)
SELECT TOP 1 v.id, v.name, COUNT(r.id) as total_reviews
FROM videogames v
JOIN reviews r ON v.id = r.videogame_id
GROUP BY v.id, v.name
ORDER BY total_reviews DESC;

--12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : 1)
SELECT TOP 1 software_houses.id, software_houses.name, COUNT(*) AS quantity
FROM software_houses
INNER JOIN videogames ON software_houses.id = videogames.software_house_id
INNER JOIN award_videogame ON videogames.id = award_videogame.videogame_id
INNER JOIN awards ON award_videogame.award_id = awards.id
WHERE award_videogame.year BETWEEN 2015 AND 2016
GROUP BY software_houses.id, software_houses.name
ORDER BY num_awards DESC;

--13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 2 (10)
SELECT DISTINCT c.id AS category_id, c.name AS category_name
FROM videogames v
INNER JOIN reviews r ON v.id = r.videogame_id
INNER JOIN category_videogame cv ON v.id = cv.videogame_id
INNER JOIN categories c ON cv.category_id = c.id
GROUP BY v.id, c.id, c.name
HAVING AVG(r.rating) < 2
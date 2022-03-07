/*Q1*/
/*1. On each Country, Which Playlist is the Most Popular?*/
WITH tableall AS
(
	SELECT c.Country Country, p.Name PlaylistName, COUNT(il.Quantity) SalesCount
	FROM Playlist p
	JOIN PlaylistTrack pt
	ON p.PlaylistId = pt.PlaylistId
	JOIN Track t
	ON t.TrackId = pt.TrackId
	JOIN InvoiceLine il
	ON il.TrackId=t.TrackId
	JOIN Invoice i
	ON i.InvoiceId=il.InvoiceId
	JOIN Customer c
	ON c.CustomerId=i.CustomerId
	GROUP BY 1,2
),
countrylist AS
(
	SELECT Country, MAX(SalesCount) SalesCount
	FROM tableall
	GROUP BY 1
)
SELECT tableall.PlaylistName, countrylist.*
FROM countrylist
JOIN tableall
ON tableall.Country = countrylist.Country
AND tableall.SalesCount = countrylist.SalesCount

/*Q2-Granted*/
/*4. Find the Most orderd MediaType, In which Country does it have the Highest sales?*/
WITH most AS
(
	SELECT MediaTypeName
	FROM (
			SELECT mt.Name MediaTypeName, COUNT(Il.InvoiceLineId), SUM(Il.Quantity*Il.UnitPrice) Total
			FROM MediaType mt
			JOIN Track t
			ON t.MediaTypeId=mt.MediaTypeId
			JOIN InvoiceLine Il
			ON Il.TrackId=t.TrackId
			GROUP BY mt.Name
			ORDER BY 2 DESC
			LIMIT 1 ) t
)
SELECT I.BillingCountry Country, COUNT(*) OrderCount, SUM(Il.Quantity*Il.UnitPrice) Total
FROM Invoice I
JOIN InvoiceLine Il
ON Il.InvoiceId= I.InvoiceId
JOIN Track t
ON t.TrackId=Il.TrackId
JOIN MediaType mt
ON mt.MediaTypeId= t.MediaTypeId
JOIN most
ON mt.Name = most.MediaTypeName
GROUP BY 1
ORDER BY 2 DESC


/*Q3*/
/*5. Which genre has the Highest sale?*/
SELECT g.Name GenreName, SUM(Il.Quantity*Il.UnitPrice) Total
FROM Genre g
JOIN Track t
ON t.GenreId=g.GenreId
JOIN InvoiceLine Il
ON Il.TrackId=t.TrackId
JOIN Invoice I
ON I.InvoiceId=Il.InvoiceId
GROUP BY 1
ORDER BY 2

/*Q4*/
/*6. On Each Country , Which genre has the highest sale (Display the Total sale)?*/
WITH alllist AS
(
	SELECT I.BillingCountry Country, g.Name Genre, SUM(Il.Quantity*Il.UnitPrice) Total
	FROM Genre g
	JOIN Track t
	ON g.GenreId=t.GenreId
	JOIN InvoiceLine Il
	ON Il.TrackId=t.TrackId
	JOIN Invoice I
	ON I.InvoiceId=Il.InvoiceId
	Group BY 1, 2
	ORDER BY 1
),
maxlist AS
(
	SELECT Country, MAX(Total) Total
	FROM alllist
	GROUP BY 1
)
SELECT maxlist.Country, alllist.Genre, maxlist.Total HighestSale
FROM maxlist
JOIN alllist
ON alllist.Country = maxlist.Country
AND alllist.Total = maxlist.Total
ORDER BY 3 DESC

/*Q1*/
/*9. Which Employee has the Highest sales?*/
SELECT E.EmployeeId, E.LastName, E.FirstName, SUM(I.Total) TotalSales
FROM Employee E
JOIN Customer C
ON E.EmployeeId=C.SupportRepId
JOIN Invoice I
ON I.CustomerId=C.CustomerId
GROUP BY 1,2,3
ORDER BY 4 DESC

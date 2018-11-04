use NORTHWND 
/*1*/
SELECT OrderID,CustomerID,OrderDate,ShippedDate,
DATEDIFF(DAY,OrderDate,ShippedDate) as Dias,
DATEDIFF(WEEK,OrderDate,ShippedDate) as Semanas,
DATEDIFF(MONTH,OrderDate,ShippedDate) as Meses
FROM Orders
WHERE DATEDIFF(WEEK,OrderDate,ShippedDate)> 4 
/*2*/
SELECT e.EmployeeID, e.LastName,YEAR(o.OrderDate) as año,MONTH(o.OrderDate) as mes,
SUM(od.Quantity*od.UnitPrice) as venta,
SUM(od.Quantity*od.UnitPrice*0.05) as comision
FROM Employees as e 
inner join Employees as em on e.EmployeeID = em.ReportsTo
inner join Orders as o on e.EmployeeID = o.EmployeeID 
inner join [Order Details] as od on od.OrderID = o.OrderID 
GROUP BY e.EmployeeID, e.LastName,YEAR(o.OrderDate), MONTH(o.OrderDate)
/*3*/
SELECT ShipCountry,YEAR(OrderDate) as año,SUM(od.Quantity*od.UnitPrice) as venta 
FROM Orders as o
inner join [Order Details] as od on o.OrderID = od.OrderID
GROUP BY ShipCountry,YEAR(OrderDate)
having SUM(od.Quantity*od.UnitPrice)> 45000 
/*4*/
SELECT p.ProductID,p.ProductName, SUM(od.Quantity)as vendidas,
COUNT(p.ProductID) as 'cantidad Ordenes'
FROM Products as p inner join [Order Details] as od 
on p.ProductID = od.ProductID
inner join Orders as o on o.OrderID = od.OrderID
where p.UnitsOnOrder >=20 and YEAR(o.OrderDate) = 1997
group by p.ProductID,p.ProductName
/*5*/
SELECT p.ProductName,
	p.UnitsInStock,
	p.UnitsOnOrder,
	p.UnitsOnOrder-p.UnitsInStock as Faltante
FROM Products AS p 
WHERE p.Discontinued <>1 and p.UnitsOnOrder>p.UnitsInStock
/*6*/
SELECT p.ProductName,p.UnitPrice
FROM Products AS p
WHERE p.Discontinued<>0 and ((SELECT SUM(p.UnitPrice) FROM Products AS p)/
(SELECT COUNT(p.ProductID) FROM Products AS p))>p.UnitPrice
/*7*/
SELECT o.OrderID, o.OrderDate,o.ShippedDate, 
DATEDIFF(DAY,o.OrderDate,o.ShippedDate) as Diferencia FROM Orders as o
WHERE ((SELECT SUM(DATEDIFF(DAY,o.OrderDate,o.ShippedDate)) FROM Orders as o)
/(SELECT COUNT(o.OrderID) From Orders as o))< DATEDIFF(DAY,o.OrderDate,o.ShippedDate)
/*8*/
SELECT po.ProductID,po.ProductName,po.CategoryID, po.UnitPrice FROM Products as po
WHERE po.Discontinued<>1 
and exists
(SELECT SUM(p.UnitPrice)/COUNT(p.CategoryID)FROM Products as p 
group by p.CategoryID having p.CategoryID = po.CategoryID and SUM(p.UnitPrice)/COUNT(p.CategoryID) < po.UnitPrice) 
/*9*/
select p.ProductID,p.ProductName, p.CategoryID from Products as p
where p.Discontinued<>1 and p.CategoryID = 8 and 
exists(SELECT * FROM Orders as o where YEAR(o.OrderDate)= 1996 and MONTH(o.OrderDate) = 8 and 
DAY(o.OrderDate) between 1 and 15) 
/*10*/
SELECT TOP 1 p.CategoryID,
(SELECT c.CategoryName FROM Categories as c where p.CategoryID = c.CategoryID) as CategoryName,
COUNT(p.CategoryID) as Cantidad
FROM Products as p 
group by p.CategoryID 
order by COUNT(p.CategoryID) desc
 /*11*/
 SELECT p.CategoryID,
		c.CategoryName,
		p.ProductID,
		p.ProductName,
		max (p.MAXIMO) as maxi
	FROM (SELECT po.ProductName, po.CategoryID, po.ProductID,SUM(od.Quantity)as MAXIMO 
	FROM Products as po inner join [Order Details] as od on od.ProductID = po.ProductID
	group by po.CategoryID,po.ProductID,po.ProductName
	) as p 
	inner join Categories as c on c.CategoryID = p.CategoryID
  group by p.CategoryID,c.CategoryName,p.ProductID,p.ProductName
  having p.MAXIMO 
  order by 1 asc , 5 desc
  
 /*11*/
 SELECT p.CategoryID,ca.CategoryName,p.ProductID,p.ProductName,SUM(od.Quantity) as maxi FROM Products as p 
 join [Order Details] as od on p.ProductID = od.ProductID join Categories as ca on 
 ca.CategoryID = p.CategoryID
 group by p.CategoryID,ca.CategoryName,p.ProductID,p.ProductName
 having SUM(od.Quantity) = (SELECT MAX(po.MAXIMO)FROM (SELECT po.ProductName, po.CategoryID, po.ProductID,SUM(od.Quantity)as MAXIMO 
	FROM Products as po inner join [Order Details] as od on od.ProductID = po.ProductID
	group by po.CategoryID,po.ProductID,po.ProductName
	) as po)
